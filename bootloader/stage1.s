.text
.code16
.global _start
.include "stage2_size.inc"


_start:
    movb %dl, BOOT_DRIVE

    cli
    mov $0x00, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss
    mov $0x7c00, %sp
    sti

    #clear screen
    #mov $0x03, %ax
	#mov $0, %bx
	#int $0x10

    mov $message, %si
    call printf16
    
read_from_drive:
    mov $0x42, %ah
    movb BOOT_DRIVE, %dl
    mov $DAP, %si
    int $0x13

    jnc stage2

    mov $error, %si
    call printf16
    jmp .

stage2:
    mov $loaded, %si
    call printf16
    ljmp $0x0000, $0x8000


BOOT_DRIVE:
    .byte 0

DAP:
    .byte 16             #DAP size
    .byte 0
    .word STAGE2_SECTORS #num of stage 2 sectors
    .word 0x8000         # offset
    .word 0x0000         # segment
    .quad 1              # LBA = 1

message:
    .asciz "Bootloader running."
loaded:
    .asciz "\r\nStage 2 loaded."
error:
    .asciz "Error reading drive!"


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


.fill 510-(.-_start), 1, 0
.word 0xaa55
