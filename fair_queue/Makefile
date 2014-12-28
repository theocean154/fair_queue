.PHONY: all
all:  bench

help:
	@echo "The following make targets are supported:" ;\
	echo " bench  - builds the testbench";\
	echo " wave   - convert vcd to vpd";\
	echo " clean  - cleans testbench and intermediate files" ;\
	echo " help   - show this information";\

bench: 
	vcs -full64 -PP -sverilog +define+SV +define+VPD +lint=all,noVCDE -notice ./*.sv -o fqtestbench.exe

wave:
	vcs -vpd2vcd vcdplus.vpd waveform.vcd
	gtkwave waveform.vcd &

clean:
	rm -rf *.o *~ *.vpd sim* csrc DVEfiles *daidir *exe *.key
