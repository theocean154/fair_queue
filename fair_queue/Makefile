.PHONY: all
all:  bench

help:
	@echo "The following make targets are supported:" ;\
	echo " bench  - builds the testbench";\
	echo " wave   - convert vcd to vpd";\
	echo " clean  - cleans testbench and intermediate files" ;\
	echo " help   - show this information";\

verilator:
	rm -rf obj_dir
	rm -f  waveform.vcd
	verilator -Wall --cc --trace fq.sv --exe fq_tb.cpp
	make -j -C obj_dir/ -f Vfq.mk Vfq
	obj_dir/Vfq


bench: 
	vcs -full64 -PP -sverilog +define+SV +define+VPD +lint=all,noVCDE -notice ./*.sv -o fqtestbench.exe

wave:
	vcs -vpd2vcd vcdplus.vpd waveform.vcd
	gtkwave waveform.vcd &

clean:
	rm -rf *.o *~ *.vpd sim* csrc DVEfiles *daidir *exe *.key
