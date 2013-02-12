# ECE437 Makefile

COMPILE.VHDL = vcom
COMPILE.VHDLFLAGS = -93
COMPILE.V = vlog
COMPILE.VFLAGS = +acc
COMPILE.SV = vlog
COMPILE.SVFLAGS = -sv
SRCDIR = ./source
WORKDIR = ./work

#Rules

%.vhd : $(SRCDIR)/%.vhd
	if [ ! -d $(WORKDIR) ]; then vlib $(WORKDIR); fi
	$(COMPILE.VHDL) $(COMPILE.VHDLFLAGS) $(SRCDIR)/$@

%.v : $(SRCDIR)/%.v
	if [ ! -d $(WORKDIR) ]; then vlib $(WORKDIR); fi
	$(COMPILE.V) $(COMPILE.VFLAGS) $(SRCDIR)/$@

%.sv : $(SRCDIR)/%.sv
	if [ ! -d $(WORKDIR) ]; then vlib $(WORKDIR); fi
	$(COMPILE.SV) $(COMPILE.SVFLAGS) $(SRCDIR)/$@

# begin HDL files (keep this)

a32bitsubr.vhd : a1bitaddr.vhd
a32bitaddr.vhd : a1bitaddr.vhd
alu.vhd : a32bitaddr.vhd a32bitsubr.vhd shifter.vhd 
registerFile_tb.vhd : registerFile.vhd
regTest.vhd: registerFile.vhd
VarLatRam.vhd : ram.vhd
mycpu.vhd : a32bitaddr.vhd registerFile.vhd alu.vhd Extender.vhd pipelinecontroller.vhd MemControl.vhd icache.vhd dcache.vhd
cpu.vhd : mycpu.vhd VarLatRAM.vhd

tb_cpu.vhd : cpu.vhd

# end HDL files (keep this)

# Lab Rules DO NOT CHANGE THESE
# OR YOU MAY FAIL THE GRADING SCRIPT
lab1: registerFile_tb.vhd
lab2: tb_alu.vhd
lab4: tb_cpu.vhd
lab5: tb_cpu.vhd
lab6: tb_cpu.vhd
lab7: tb_cpu.vhd
lab8: tb_cpu.vhd
lab9: tb_cpu.vhd
lab10: tb_cpu.vhd
lab11: tb_cpu.vhd
lab12: tb_cpu.vhd


# Time Saving Rules
clean:
	$(RM) -rf $(WORKDIR) *.log transcript \._* mapped/* *.hex \.leda* *.sdo
