.text 
.code16
.global _start
.global text_mode_print32

.extern setup_paging
.include "stage2_size.inc"

_start:

load_kernel:
    movb %dl, BOOT_DRIVE

    mov $0x42, %ah
    movb BOOT_DRIVE, %dl
    mov $KERNEL_DAP, %si
    int $0x13

    jnc gdt_setup

    mov $error, %si
    call printf16
    jmp .

gdt_setup:
    mov $loaded, %si
    call printf16

    cli
    lgdt gdt_desc

    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0

    ljmp $CODE_SEG, $prot_mode_start

BOOT_DRIVE:
    .byte 0

KERNEL_DAP:
    .byte 16
    .byte 0
    .word KERNEL_SECTORS
    .word 0x0000
    .word 0x1000      # segment -> 0x10000
    .quad KERNEL_LBA

loaded:
    .asciz "\r\nKernel loaded from disk."

error:
    .asciz "\r\nError reading kernel from drive!"

#real mode BIOS printing
#==============================
# requires a pointer to string to be loaded in si
#==============================
printf16:
    mov (%si), %al
    inc %si

    cmp $0, %al
    je return

    mov $0x0e, %ah
    int $0x10
    jmp printf16
return:
    ret
#==============================



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


# GDT 64 bit
#==============================
gdt64_start:
    .long 0x00000000
    .long 0x00000000

#CS descriptor
cs64_desc:
    .word 0x0000     #limit
    .word 0          #base
    .byte 0          #base
    .byte 0b10011010 #access
    .byte 0b00100000 #flags and limit
    .byte 0          #base

#DS descriptor
ds64_desc:
    .word 0x0000     #limit
    .word 0          #base
    .byte 0          #base
    .byte 0b10010010 #access
    .byte 0b00000000 #flags and limit
    .byte 0          #base
gdt64_end:

#GDT descriptor
gdt64_desc:
    .word gdt64_end - gdt64_start - 1
    .long gdt64_start

.equ CODE64_SEG, cs64_desc - gdt64_start
.equ DATA64_SEG, ds64_desc - gdt64_start
#==============================



.code32

#printing via text mode
#==============================
#requires video memory address to be loaded in edi
#and pointer to string to be loaded in esi
#==============================
text_mode_print32:
    movb (%esi), %al
    inc %esi

    cmp $0, %al
    je return32

    movb $0x0f, %ah
    movw %ax, (%edi)
    add $2, %edi
    jmp text_mode_print32
return32:
    ret
#==============================

msg32:
    .asciz "Entered 32 bit mode. Setting up 64 bit mode."

prot_mode_start:

    mov $0xb8000, %edi
    mov $11, %eax
    imul $160, %eax
    add %eax, %edi
    mov $msg32, %esi
    call text_mode_print32

    cli 
    lgdt gdt64_desc

    #build multi-level page table
    #load address of top-level page table into cr3
    #enable PAE
    call setup_paging

    #enable long mode in EFER
    movl $0xc0000080, %ecx
    rdmsr
    orl $0x00000100, %eax
    wrmsr

    #enable paging
    mov %cr0, %eax
    or $0x80000000, %eax
    mov %eax, %cr0

    ljmp $CODE64_SEG, $long_mode_start


.code64

msg64:
    .asciz "Entered 64 bit mode. Progressing to kernel."

long_mode_start:
    
    mov $DATA64_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss

    mov $0x20000, %rsp

    mov $0xb8000, %rdi
    mov $13, %rax
    imul $160, %rax
    add %rax, %rdi
    lea msg64(%rip), %rsi
    call text_mode_print64

    #jmp .

    mov $0x10000, %rax
    jmp *%rax


#printing via text mode
#==============================
#requires video memory address to be loaded in edi
#and pointer to string to be loaded in esi
#==============================
text_mode_print64:
    movb (%rsi), %al
    inc %rsi

    cmp $0, %al
    je return64

    movb $0x0f, %ah
    movw %ax, (%rdi)
    add $2, %rdi
    jmp text_mode_print64
return64:
    ret
#==============================
