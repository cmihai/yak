# yak
Yet another Argument parsing pacKage  
(a.k.a. an exercise in yak shaving.)

## What does it do?

It supports simple POSIX-like command-line argument parsing for Tcl applications.

## How do I use it?

	set argv "-a --param 5"
    yak parse "-a|--arg -o -p|--param=TEST" $argv
    puts [yak get -a]       # true
    puts [yak get --arg]    # true
    puts [yak get --param]  # 5
    puts [yak get -o]       # false
    puts [yak get --fancy]  # false

Basically, use `|` to separate short and long argument forms, and `=` to
indicate that it's a value argument and not a flag.

## Why should I use this instead of \<PACKAGE NAME HERE\>?

I have no idea. Sorry.
