#!/usr/bin/env tclsh

namespace eval yak {
	variable parsed;

	proc parse {pattern arglist} {
		set template [dict create]

		# Process the command-line pattern
		foreach arg $pattern {
			set argParams [dict create -forms [list] -default true -argVar ""]

			# Is it a flag or should it have a value?
			if {[string match "*=*" $arg]} {
				set idx [string first "=" $arg]
				dict set argParams -argVar \
					[string range $arg [expr {$idx + 1}] end]
				set arg [string range $arg 0 [expr {$idx - 1}]]
			}

			# Does the argument come in long and short forms?
			set forms [list $arg]
			if {[string match "-*|-*" $arg]} {
				set idx [string first "|" $arg]
				set forms [list \
					[string range $arg 0 [expr {$idx - 1}]] \
					[string range $arg [expr {$idx + 1}] end] \
				]
			}

			dict set argParams -forms $forms
			foreach form $forms {
				dict set template $form $argParams
			}
		}

		# Parse the command-line arguments
		set ::yak::parsed [dict create]
		for {set i 0} {$i < [llength $arglist]} {incr i} {
			set arg [lindex $arglist $i]

			if {[dict exists $template $arg]} {
				set argtype [dict get $template $arg]
				if {[dict get $argtype -argVar] eq ""} {
					set value [dict get $argtype -default]
				} else {
					set value [lindex $arglist [incr i]]
				}

				foreach form [dict get $argtype -forms] {
					dict set ::yak::parsed $form $value
				}
			}
		}
	}

	proc get {arg} {
		if {![dict exists $::yak::parsed $arg]} {
			return false;
		}
		return [dict get $::yak::parsed $arg]
	}
}

proc yak {command args} {
	if {$command eq "parse"} {
		::yak::parse {*}$args
	} elseif {$command eq "get"} {
		return [::yak::get $args]
	} else {
		error "Invalid command: $command"
	}
}
