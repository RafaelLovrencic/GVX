FLAGS = -ffreestanding \
    -m64 \
    -mno-red-zone \
    -fno-stack-protector \
    -fno-pic \
    -fno-pie \
    -nostdlib \
    -nostartfiles \
    -c


default:
	@echo "Assembling the kernel."

	as --64 kernel.s -o kernel.o

	gcc $(FLAGS) kernel.c -o kernel_c.o
	gcc $(FLAGS) terminal/terminal.c -o terminal/terminal.o

	ld -m elf_x86_64 -T kernel_linker.ld \
		kernel.o \
		kernel_c.o \
		terminal/terminal.o \
		-o kernel.bin
	truncate -s %512 kernel.bin

	echo ".equ KERNEL_SECTORS, $$((($$(wc -c < kernel.bin))/512))" > kernel_size.inc
