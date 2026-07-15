void kernel_main(void) {
    *(void *) 0xb8000 = 0x0F58;
}
