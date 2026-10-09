all: build

block_design:
	vivado -mode batch -source rfsoc-mts.tcl -notrace

build: block_design
	vivado -mode batch -source build_bitstream.tcl -notrace

clean:
	rm -rf block_design *.jou *.log NA .Xil .crashReporter *.txt

.PHONY: all block_design build clean
