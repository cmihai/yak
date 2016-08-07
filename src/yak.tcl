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
			set forms [list $arg]
			set argParams [dict create -default true -argType ""]

			# Does the argument come in long and short forms?
			if {[string match "-*|-*" $arg]} {
				set idx [string first "|" $arg]
				set forms [list \
					[string range $arg 0 [expr {$idx - 1}]] \
					[string range $arg [expr {$idx + 1}] end] \
				]
			}

			foreach form $forms {
				dict set template $form $argParams
			}
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
