default:
	$(MAKE) -C ./bootloader/
	$(MAKE) -C ./kernel/

run:
	qemu-system-x86_64 -drive format=raw,file=gvx.bin
