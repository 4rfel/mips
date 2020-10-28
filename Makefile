all: compile

compile:
	quartus_sh --flow compile mips

program:
	quartus_pgm -m jtag -c 1 -o "p;output_files/mips.sof"

jtag:
	sudo killall -9 jtag; sudo jtagconfig 