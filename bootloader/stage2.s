.text 
.code16
.global _start


_start:
    cli
    lgdt gdt_desc

    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0

    ljmp $CODE_SEG, $prot_mode_start


# GDT
#==============================
gdt_start:
    .long 0x00000000
    .long 0x00000000

#CS descriptor
cs_desc:
    .word 0xffff     #limit
    .word 0          #base
    .byte 0          #base
    .byte 0b10011010 #access
    .byte 0b11001111 #flags
    .byte 0          #base

#DS descriptor
ds_desc:
    .word 0xffff     #limit
    .word 0          #base
    .byte 0          #base
    .byte 0b10010010 #access
    .byte 0b11001111 #flags
    .byte 0          #base
gdt_end:

#GDT descriptor
gdt_desc:
    .word gdt_end - gdt_start - 1
    .long gdt_start

.equ CODE_SEG, cs_desc - gdt_start
.equ DATA_SEG, ds_desc - gdt_start
#==============================


.code32

msg32:
    .asciz "Entered 32 bit mode. Setting up 64 bit mode."

prot_mode_start:

    mov $0xb8000, %edi
    mov $11, %eax
    imul $160, %eax
    add %eax, %edi
    mov $msg32, %esi
    call text_mode_print

    jmp long_mode_start


#.code64

msg64:
    .asciz "Entered 64 bit mode. Progressing to kernel."

long_mode_start:
    mov $0xb8000, %edi
    mov $12, %eax
    imul $160, %eax
    add %eax, %edi
    mov $msg64, %esi
    call text_mode_print

    jmp .

#printing via text mode
#==============================
#requires video memory address to be loaded in edi
#and pointer to string to be loaded in esi
#==============================
text_mode_print:
    movb (%esi), %al
    inc %esi

    cmp $0, %al
    je return

    movb $0x0f, %ah
    movw %ax, (%edi)
    add $2, %edi
    jmp text_mode_print
return:
    ret
#==============================
