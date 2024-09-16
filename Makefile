.PHONY : clean main format

all : clean main

GHDL_FLAGS=--std=08 -fexplicit --ieee="synopsys"

LIBDIR=fpga/riscv
TESTDIR=fpga/test

main :
	./bin/bin2str -f 2 -b 1 -p 1024 code.hex > code.bin
	ghdl -a $(GHDL_FLAGS) --work=riscv $(LIBDIR)/parameters.vhdl
	ghdl -a $(GHDL_FLAGS) --work=riscv $(LIBDIR)/utils.vhdl
	ghdl -a $(GHDL_FLAGS) --work=riscv $(LIBDIR)/dmem.vhdl
	ghdl -a $(GHDL_FLAGS) $(TESTDIR)/dmem_tb.vhdl
	ghdl -e $(GHDL_FLAGS) dmem_tb
	ghdl -r $(GHDL_FLAGS) dmem_tb --vcd=dmem_tb.vcd --stop-time=400ns

clean :
	rm -f *.cf *.bin *.vcd

format :
	vsg -c .vsg.yaml --fix -f fpga/lib/riscv/*.vhdl
	vsg -c .vsg.yaml --fix -f fpga/test/*.vhdl
