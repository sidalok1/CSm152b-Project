default: .signals
	gtkwave .signals save.gtkw

.signals: .sim
	vvp .sim -l .log

.sim: $(wildcard src/*) $(wildcard test/*) $(wildcard mem/*)
	iverilog -y src -o .sim test/*.v

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