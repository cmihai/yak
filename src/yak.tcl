#!/usr/bin/env tclsh

namespace eval yak {
	variable parsed;
}

proc yak {command args} {
	if {$command eq "parse"} {
		set pattern [lindex $args 0]
		set arglist [lindex $args 1]
		set template [dict create]

		# Process the command-line pattern
		foreach arg $pattern {
			set argParams [dict create -default true -argType ""]
			dict set template $arg $argParams
		}

		# Parse the command-line arguments
		set ::yak::parsed [dict create]
		foreach arg $arglist {
			if {[dict exists $template $arg]} {
				dict set ::yak::parsed $arg [
					dict get [dict get $template $arg] -default
				]
			}
		}
	} elseif {$command eq "get"} {
		if {![dict exists $::yak::parsed $args]} {
			return false;
		}
		return [dict get $::yak::parsed $args]
	}
}
