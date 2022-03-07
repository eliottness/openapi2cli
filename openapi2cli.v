module main

import os
import flag

fn build(path string) string {
	println(path)
	// fp := os.open_file(path, "r") or {
	// 	panic("Cannot open OpenAPI Spec at path: $path")
	// }
	return path
}

fn main() {
	mut fp := flag.new_flag_parser(os.args)

	fp.application('openapi2cli')
	fp.version('0.0.1')
	fp.description('A sample CLI application that prints geometric shapes to the console.')
	fp.skip_executable()

	args := fp.finalize() ?
	if args.len != 1 {
		println("USAGE: ./openapi2cli <path to openapi file>")
		return
	}

	yaml_filepath := args[0] ?
	v_filepath := build(yaml_filepath)
	os.execvp("v", ["build", v_filepath, ]) ?
}