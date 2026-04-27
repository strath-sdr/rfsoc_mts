all: block_design bitstream clean

block_design:
	vivado -mode batch -source make_block_design.tcl -notrace

bitstream:
	vivado -mode batch -source make_bitstream.tcl -notrace

clean:
	rm -rf mts *.jou *.log NA .Xil