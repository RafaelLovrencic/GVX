default:
	$(MAKE) -C ./bootloader/

run:
	qemu-system-x86_64 -disk format=raw, file=gvx.bin
