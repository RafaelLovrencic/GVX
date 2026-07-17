ENTRY(_kstart)
OUTPUT_FORMAT(binary)
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

    /DISCARD/ :
    {
        *(.note.gnu.property)
        *(.note*)
        *(.comment)
    }
}
