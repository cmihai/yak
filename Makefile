SOURCES=src/yak.tcl
TESTS=tests/tests.tcl

test: tests/tests.tcl

tests/tests.tcl: src/yak.tcl .phony
	$@

.phony: