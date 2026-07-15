ENTRY(_kstart)
SECTIONS {
    . = 0x10000;
    
    .text ALIGN(4K) : {
        *(.multiboot) /*for GRUB*/
        *(.text)
    }

    .rodata ALIGN(4K) : {
        *(.rodata)
    }

    .data ALIGN(4K) : {
        *(.data)
    }

    .bss ALIGN(4K) : {
        *(COMMON)
        *(.bss)
    }
}
