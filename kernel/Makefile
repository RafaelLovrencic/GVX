default:
	@echo "Assembling the kernel."
	as --64 kernel.s -o kernel.o
	ld -m elf_x86_64 -T kernel_linker.ld kernel.o -o kernel.bin
	truncate -s %512 kernel.bin

	echo ".equ KERNEL_SECTORS, $$((($$(wc -c < kernel.bin))/512))" > kernel_size.inc
