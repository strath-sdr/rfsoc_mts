all: build

block_design:
	vivado -mode batch -source rfsoc-mts.tcl -notrace

build: block_design
	vivado -mode batch -source build_bitstream.tcl -notrace

clean:
	rm -rf rfsoc-mts *.jou *.log NA .Xil .crashReporter

.PHONY: all block_design build clean
