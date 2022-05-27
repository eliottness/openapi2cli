module main

import cli_builder
import os
import flag
import net.urllib

fn main() {
	mut fp := flag.new_flag_parser(os.args)

	fp.application('openapi2cli')
	fp.version('0.0.1')
	fp.description('A sample CLI application that prints geometric shapes to the console.')
	fp.skip_executable()

	debug := fp.bool('debug', `d`, false, 'Toggle Debug mode')
	binary_name := fp.string('bin_name', `b`, 'cli', 'Output binary name (Default: cli)')

	args := fp.finalize() ?
	if args.len != 2 {
		println('USAGE: ./openapi2cli <path to openapi file> <server url>')
		return
	}

	// Check that the server URL is valid
	urllib.parse(args[1]) or {
		println('Invalid server url')
		println('USAGE: ./openapi2cli <path to openapi file> <server url>')
		return
	}

	v_filepath := cli_builder.build(args[0], args[1], debug) ?
	os.execvp('v', [v_filepath, '-o', binary_name]) ?
}
