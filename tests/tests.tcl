#!/usr/bin/env tclsh

source src/yak.tcl

proc assert {what} {
	if {![eval "expr \{$what\}"]} {
		set msg "FAILED: $what"
	} else {
		set msg "SUCCESS: $what"
	}

	if {[string length $msg] > 80} {
		set msg "[string range $msg 0 80]..."
	}
	puts $msg
}

yak parse "-a" [list -a]
assert {[yak get -a]}
assert {![yak get -b]}

yak parse "-a" [list -a -b]
assert {[yak get -a]}
assert {![yak get -b]}

yak parse "-a -b" [list -a -b]
assert {[yak get -a]}
assert {[yak get -b]}

yak parse "-a|--ant" [list -a]
assert {[yak get -a]}
assert {[yak get --ant]}

yak parse "-a|--ant=VALUE -b=STATUS -c|--codfish" [list --ant 5 -b {To be done}]
assert {[yak get --ant] == 5}
assert {[yak get -b] eq {To be done}}
assert {![yak get --codfish]}

catch {
	yak blah
} result opts
assert "\[dict get \{$opts\} -code\] != 0"
