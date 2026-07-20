.code64
.global _kstart

.extern kernel_main


_kstart:
    #mov $0xb8000, %rdi
    #mov $14, %rax
    #imul $160, %rax
    #add %rax, %rdi
    #lea msg_kernel(%rip), %rsi
    #call text_mode_print64

    #jmp .

    call kernel_main

    jmp .


msg_kernel:
    .asciz "Entered the kernel."

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
