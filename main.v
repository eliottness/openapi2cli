module main

import cli_builder
import os
import flag

fn main() {
	mut fp := flag.new_flag_parser(os.args)

	fp.application('openapi2cli')
	fp.version('0.0.1')
	fp.description('A sample CLI application that prints geometric shapes to the console.')
	fp.skip_executable()

	debug := fp.bool('debug', `d`, false, 'Toggle Debug mode')
	binary_name := fp.string('bin_name', `b`, 'cli', 'Output binary name (Default: cli)')

	args := fp.finalize() ?
	if args.len != 1 {
		println('USAGE: ./openapi2cli <path to openapi file>')
		return
	}

	yaml_filepath := args[0] ?
	v_filepath := cli_builder.build(yaml_filepath, debug) ?
	os.execute('v $v_filepath -o $binary_name ')

	if !debug {
		os.rm(v_filepath) ?
	}
}
