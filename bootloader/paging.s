#sources: https://wiki.osdev.org/Setting_Up_Long_Mode#Setting_up_paging, https://github.com/sedflix/lame_bootloader

.code32

.global setup_paging

.extern text_mode_print

.equ PML4T_ADDR, 0x1000
.equ PDPTE_ADDR, 0x2000
.equ PDT_ADDR, 0x3000
.equ PT_ADDR, 0x4000

.equ PT_ADDR_MASK, 0xffffffffff000
.equ PT_PRESENT, 1
.equ PT_READABLE, 2

.equ ENTRIES_PER_PT, 512
.equ SIZEOF_PT_ENTRY, 8
.equ PAGE_SIZE, 0x1000

.equ CR4_PAE_ENABLE, 1 << 5

setup_paging:
    mov $msg_paging, %esi
    call text_mode_print

    mov $PML4T_ADDR, %edi
    mov %edi, %cr3

    xor %eax, %eax
    mov $4096, %ecx
    rep stosb

    mov %cr3, %edi
    movl $(PDPTE_ADDR & PT_ADDR_MASK | PT_PRESENT | PT_READABLE), (%edi)

    mov $PDPTE_ADDR, %edi
    movl $(PDT_ADDR & PT_ADDR_MASK | PT_PRESENT | PT_READABLE), (%edi)

    mov $PDT_ADDR, %edi
    movl $(PT_ADDR & PT_ADDR_MASK | PT_PRESENT | PT_READABLE), (%edi)

    mov $PT_ADDR, %edi
    mov $(PT_PRESENT | PT_READABLE), %ebx
    mov $ENTRIES_PER_PT, %ecx

SetEntry:
    mov %ebx, (%edi)
    add $SIZEOF_PT_ENTRY, %edi
    add $PAGE_SIZE, %ebx
    loop SetEntry

    mov %cr4, %eax
    or $CR4_PAE_ENABLE, %eax
    mov %eax, %cr4

    ret



msg_paging:
    .asciz "Setting up paging."
