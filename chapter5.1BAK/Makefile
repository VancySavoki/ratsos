# tools
PLATFORM=Linux
NASM=nasm
BOCHS=bochs
BXIMAGE=bximage
CC=cc
LD=ld

# args
boot=boot
kernel=kernel
build=build
ENTRY_POINT =  0x70000
CFLAGS = -m32 -c  # --Wall -W  fno-builtin -Wstrict-prototypes -Wmissing-prototypes 
LDFLAGS = -m elf_i386 -e _start -Ttext $(ENTRY_POINT) 


target: prepare image  
	$(BOCHS) -f bochsrc.me

image:$(build)/ratsos.img
	@echo "complete build ratsos.img"

$(build)/ratsos.img: $(build)/boot.bin $(build)/loader.bin $(build)/kernel.bin
	$(BXIMAGE) -mode=create  -hd=32M  -imgmode=flat  -q $(build)/ratsos.img 
	sleep 1
	dd if=$(build)/boot.bin of=$(build)/ratsos.img bs=512 count=1  conv=notrunc
	dd if=$(build)/loader.bin of=$(build)/ratsos.img bs=512 count=4 seek=1 conv=notrunc
	dd if=$(build)/kernel.bin of=$(build)/ratsos.img bs=512 count=25 seek=5 conv=notrunc

$(build)/kernel.bin: $(build)/kernel.o
	$(LD) $(build)/main.o -o $(build)/kernel.bin $(LDFLAGS) 

$(build)/kernel.o: $(kernel)/main.c
	$(CC) $(kernel)/main.c  -o $(build)/main.o    $(CFLAGS) 

$(build)/%.bin: $(boot)/%.asm
	$(NASM) -f bin -o $(build)/$*.bin $(boot)/$*.asm	


prepare: 
	@echo "prepare dir $(build)"
    ifeq ($(build), $(wildcard $(build)))
		@echo "build directory exist..."
    else
		mkdir -p $(build)
    endif

clean:
	@echo "clean dir $(build)"
	rm -rf $(build)/*
