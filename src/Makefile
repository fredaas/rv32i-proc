RISCV_TOOLCHAIN=riscv32-unknown-elf

CC=$(RISCV_TOOLCHAIN)-gcc
LD=$(RISCV_TOOLCHAIN)-ld
AS=$(RISCV_TOOLCHAIN)-as

OBJSIZE=$(RISCV_TOOLCHAIN)-size
OBJDUMP=$(RISCV_TOOLCHAIN)-objdump
OBJCOPY=$(RISCV_TOOLCHAIN)-objcopy
READELF=$(RISCV_TOOLCHAIN)-readelf

# Warning: This value must match the ram_size constant defined in fpga/lib/riscv/parameters.vhdl
ZERO_PAD=1024

BIN2STR=../bin/bin2str

WARNINGS=-Wall
CFLAGS=-I. -mabi=ilp32 -march=rv32i -Os $(WARNINGS) -ffreestanding -nostartfiles -nostdinc
LDFLAGS=-T lscript.ld --print-memory-usage

OBJ=add.o

.PHONY : clean

all : clean add.bin.out

add.elf : $(OBJ)
	$(LD) -o $@ $^ $(LDFLAGS)

%.o : %.s
	$(CC) -c -o $@ $< $(CFLAGS)

%.bin : %.elf
	$(OBJCOPY) -S -O binary $< $@

%.bin.out : %.bin
	$(BIN2STR) -f 2 -p $(ZERO_PAD) $< > $@

clean :
	rm -f *.o *.elf *.bin *.bin.out *.hex
