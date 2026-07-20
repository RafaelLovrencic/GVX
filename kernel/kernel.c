#define VGA_START ((volatile char*) 0xb8000)
#define VGA_ROW_SIZE 160
#define VGA_WHITE_CHAR_ATTRIB 0x0f

void kernel_main(void) {
    char *kernel_hello = "Entered the kernel. Yay!";
    
    char *curr_char = kernel_hello;
    short offset = 0;
    while (*curr_char) {
        VGA_START[VGA_ROW_SIZE * 14 + offset++] = *curr_char;
        VGA_START[VGA_ROW_SIZE * 14 + offset++] = VGA_WHITE_CHAR_ATTRIB;
        curr_char++;
    }
}
