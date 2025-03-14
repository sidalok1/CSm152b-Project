default: .signals
	gtkwave .signals save.gtkw

.signals: .sim
	cp mem/*.mem .
	vvp .sim -l .log
	rm -f *.mem

.sim: $(wildcard src/*) $(wildcard test/*) $(wildcard mem/*) $(wildcard basys/*)
	iverilog -g2012 -Y .sv -y basys -y src -y mem -o .sim test/*.sv

$(wildcard src/*): src

$(wildcard test/*): test

$(wildcard mem/*): mem

src:
	mkdir src

test: 
	mkdir test

mem:
	mkdir mem

clean:
	rm -f .sim
	rm -f .signals
	rm -f .log
	rm -f *.mem
	
.DELETE_ON_ERROR: clean