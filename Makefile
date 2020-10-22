all: compile

compile:
	quartus_sh --flow compile tipo_r

program:
	quartus_pgm -m jtag -c 1 -o "p;output_files/tipo_r.sof"

jtag:
	sudo killall -9 jtag; sudo jtagconfig 