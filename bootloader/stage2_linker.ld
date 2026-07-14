OUTPUT_FORMAT(binary)
ENTRY(_start)

SECTIONS
{
    . = 0x8000;

    .text :
    {
        *(.text)
    }

    /DISCARD/ :
    {
        *(.note.gnu.property)
        *(.note*)
        *(.comment)
    }
}
