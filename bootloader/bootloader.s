.text
.code16
.global _start


_start:
    mov $message, %si

loop:
    mov (%si), %al
    inc %si

    cmp $0, %al
    je end

    mov $0x0e, %ah
    int $0x10
    jmp loop

end:
    jmp .


message:
    .asciz "Hello, World!"


.fill 510-(.-_start), 1, 0
.word 0xaa55
