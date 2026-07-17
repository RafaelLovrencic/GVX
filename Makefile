default:
	$(MAKE) -C ./bootloader/
	$(MAKE) -C ./kernel/
	cat ./bootloader/bootloader.bin ./kernel/kernel.bin > gvx.bin

run:
	qemu-system-x86_64 -drive format=raw,file=gvx.bin
