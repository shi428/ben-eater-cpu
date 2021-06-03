SRCDIR = source/modules
INCDIR = include
TBDIR = testbench
DEPDIR = dependencies
LIBDIR = work

VLOG = vlog  -sv
SIM = vsim -suppress 12100 -L ~/intelFPGA_lite/20.1/modelsim_ase/altera/verilog/altera_mf 
VERFLAGS = -sv12compat -mfcu -lint +incdir+$(INCDIR) -suppress 12110


MODSTEM = $(notdir $(basename $(wildcard $(SRCDIR)/*.sv)))
TBSTEM = $(notdir $(basename $(wildcard $(TBDIR)/*.sv)))
SVSTEM = $(MODSTEM) $(TBSTEM)
HDSTEM = $(notdir $(basename $(wildcard $(INCDIR)/*.vh)))

SRCSTEM = $(SVSTEM)
SRCS = $(addsuffix .sv, $(SRCSTEM))
HEADERS = $(addsuffix .vh, $(HDSTEM))
DEPS = $(addsuffix .d, $(SVSTEM) $(HDSTEM))
ELAD = $(addsuffix .elad, $(TBSTEM))
TCLD = $(addsuffix .tcld, $(TBSTEM))
ELA = $(addsuffix .ela, $(TBSTEM))
NODEPS = clean
.PHONY: $(NODEPS)

.SUFFIXES:
.SUFFIXES: .vh .sv .d .ela .svo .vho

vpath %.vh $(INCDIR)/
vpath %.sv $(SRCDIR)/ $(TBDIR)/
vpath %.d $(DEPDIR)/
vpath % $(DEPDIR)/
default:
	echo help
ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(NODEPS))))
-include $(addprefix $(DEPDIR)/, $(DEPS))
endif

ifneq (0, $(words $(filter %.wcfg, $(MAKECMDGOALS))))
DOFILES = $(notdir $(basename $(wildcard *.wcfg)))
DOFILE = $(filter $(MAKECMDGOALS:%.wcfg=%) $(MAKECMDGOALS:%_tb.wcfg=%), $(DOFILES))
ifeq (1, $(words $(DOFILE)))
  WAVDO =  -view $(DOFILE).wcfg
else
  WAVDO = 
endif
SIMDO = run -all
else
SIMDO = run -all; exit;
endif
$(DEPDIR):
	test -d $(DEPDIR) || mkdir $(DEPDIR)
$(LIBDIR):
	test -d $(LIBDIR) || vlib $(LIBDIR)
%.d: | $(DEPDIR)
	scripts/dependencies.py $@ > $@
%.vho: %.vh
	$(XVLOG) $(VERFLAGS) $<
	touch $(DEPDIR)/$@
%.svo: %.sv
	$(VLOG) $(VERFLAGS) $<
	touch $(DEPDIR)/$@
%_tb.sim %.sim: %_tb
	$(SIM) -c $(LIBDIR).$(addsuffix _tb, $*) -do "run -all; exit"
clean:
	rm -rf dependencies *.tcl *.log *.do v* mem* transcript $(LIBDIR) synthesis mapped fpga
