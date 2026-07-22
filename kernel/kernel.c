#include "kernel.h"
#include "terminal/terminal.h"


void kernel_main(void) {
    char *kernel_hello = "Entered the kernel. Yay!";
    
    terminal_init();
    terminal_printf(kernel_hello);
    terminal_printf("\nWelcome to GVUX.");
}
