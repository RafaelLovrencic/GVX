default:
	@echo "Assembling the bootloader."
	as --32 bootloader.s -o bootloader.o
	ld -m elf_i386 -T bootloader_linker.ld bootloader.o -o bootloader.bin

run:
	qemu-system-x86_64 -drive format=raw,file=bootloader.bin
