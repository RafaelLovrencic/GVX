# GVUX
A minimal x86_64 operating system written from scratch in C and Assembly, built to run on QEMU.

# Prerequisites

* the GNU Assembler and compiler
* qemu x86_64 emulator

### Building from source:

Simply run the root Makefile using the default target. Run the OS by using the run target in the Makefile or by running gvux binary in qemu with the following parameters: ```-drive format=raw, file=gvux.bin```.

If building by components, first build the kernel and then the bootloader following the instructions provided below, then concatenate their binaries into a single file and run it in qemu.

## Bootloader

The GVUX bootloader is written in x86 Assembly using the AT&T syntax and assembled using the GNU Assembler.

#### Building the bootloader:
1. ```cd ./bootloader/```
2. ```make```

#### Running the bootloader:
1. ```make run```

Alternatively, use the commands provided in the Makefile default target and then the run target.

Since implementing kernel entry it is not recommended to run only the bootloader since the jump to kernel will cause qemu to be stuck in a reset loop. A solution would be to uncomment ```jmp .``` before the ```mov $0x10000, %rax``` in stage2.s.

## Kernel

GVUX features a monolithic kernel.

#### Building the kernel:
* ```cd ./kernel/```
* ```make```

Alternatively, use the commands provided in the Makefile default target and then the run target.
