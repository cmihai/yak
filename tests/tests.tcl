#!/usr/bin/env tclsh

source src/yak.tcl

proc assert {what} {
	if {![eval "expr \{$what\}"]} {
		puts "FAILED: $what"
	} else {
		puts "SUCCESS: $what"
	}
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

yak parse "-a|--arg" [list -a --arg]
assert {[yak get -a]}
assert {[yak get --arg]}
