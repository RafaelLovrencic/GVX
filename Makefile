default:
	$(MAKE) -C ./bootloader/
	$(MAKE) -C ./kernel/
	cat ./bootloader/bootloader.bin ./kernel/kernel.bin > gvx.bin

run:
	qemu-system-x86_64 -drive format=raw,file=gvx.bin

debug:
	@printf "In a new terminal run: \n \
		1. gdb gvx.bin \n \
		2. target remote :1234 \n \
		3. layout asm \n \
		4. hbreak *0x7c00 \n \
		5. add other breakpoints as needed \n \
		6. be sure to jump over BIOS functions, they make gdb jump over lots of lines \n\n"
	qemu-system-x86_64 -s -S -drive format=raw,file=gvx.bin
