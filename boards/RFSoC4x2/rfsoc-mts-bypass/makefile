overlay_name := rfsoc-mts

all: build

block_design:
	vivado -mode batch -source $(overlay_name).tcl -notrace

build: block_design
	vivado -mode batch -source build_bitstream.tcl -notrace

clean:
	rm -rf block_design $(wildcard *.jou *.log *.txt) NA .Xil .crashReporter

.PHONY: all block_design build clean