module main

import cli
import os
import flag

fn main() {
	mut fp := flag.new_flag_parser(os.args)

	fp.application('openapi2cli')
	fp.version('0.0.1')
	fp.description('A sample CLI application that prints geometric shapes to the console.')
	fp.skip_executable()

	debug := fp.bool('debug', 0, false, 'Toggle Debug mode')
	binary_name := fp.string('out-bin', 0, 'cli', 'Output binary name (Default: cli)')

	args := fp.finalize() ?
	if args.len != 1 {
		println('USAGE: ./openapi2cli <path to openapi file>')
		return
	}

	yaml_filepath := args[0] ?
	v_filepath := cli.build(yaml_filepath, debug) ?
	os.execvp('v', [v_filepath, '-o', binary_name]) ?
}
