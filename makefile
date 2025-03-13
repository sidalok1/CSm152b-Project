default: .signals
	gtkwave .signals save.gtkw

.signals: .sim
	vvp .sim -l .log

.sim: $(wildcard src/*) $(wildcard test/*) $(wildcard mem/*) $(wildcard basys/*)
	iverilog -g2012 -Y .sv -y basys -y src -o .sim test/*.sv

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
	
.DELETE_ON_ERROR: clean