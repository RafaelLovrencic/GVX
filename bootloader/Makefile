default:
	@echo "Creating template DAPs"
	echo ".equ KERNEL_SECTORS, 0" > stage2_size.inc
	echo ".equ KERNEL_LBA, 0" >> stage2_size.inc

	@echo "Assembling stage 2."
	as --32 stage2.s -o stage2.o
	as --32 paging.s -o paging.o
	ld -m elf_i386 -T stage2_linker.ld stage2.o paging.o -o stage2.bin
	truncate -s %512 stage2.bin

	@echo "Generating stage2 size."
	echo ".equ KERNEL_SECTORS, $$((($$(wc -c < ../kernel/kernel.bin)+511)/512))" > stage2_size.inc
	echo ".equ STAGE2_SECTORS, $$((($$(wc -c < stage2.bin)+511)/512))" >> stage2_size.inc
	echo ".equ KERNEL_LBA, $$((1 + ($$(wc -c < stage2.bin)+511)/512))" >> stage2_size.inc

	@echo "Reassembling stage 2 with proper DAPs."
	as --32 stage2.s -o stage2.o
	as --32 paging.s -o paging.o
	ld -m elf_i386 -T stage2_linker.ld stage2.o paging.o -o stage2.bin
	truncate -s %512 stage2.bin

	@echo "Assembling stage 1."
	as --32 stage1.s -o stage1.o
	ld -m elf_i386 -T stage1_linker.ld stage1.o -o stage1.bin

	cat stage1.bin stage2.bin > bootloader.bin

run:
	qemu-system-x86_64 -drive format=raw,file=bootloader.bin
