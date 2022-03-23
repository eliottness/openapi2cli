module open_api

import x.json2 { Any }
import json

struct PathItem {
pub mut:
	ref         string
	summary     string
	description string
	get         Operation
	put         Operation
	post        Operation
	delete      Operation
	options     Operation
	head        Operation
	patch       Operation
	trace       Operation
	servers     []Server
	parameters  []ObjectRef<Parameter>
}

pub fn clean_path_expression(path string) string {
	mut path_copy := path.clone()
	mut expression := path_copy.find_between('{', '}')

	for expression != '' {
		path_copy = path_copy.replace(expression, '')
		expression = path_copy.find_between('{', '}')
	}

	return path_copy
}

pub fn (mut path_item PathItem) from_json(json Any) ? {
	for key, value in json.as_map() {
		match key {
			'\$ref' {
				path_item.ref = value.str()
			}
			'summary' {
				path_item.summary = value.str()
			}
			'description' {
				path_item.description = value.str()
			}
			'get' {
				path_item.get = decode<Operation>(value.json_str()) ?
			}
			'put' {
				path_item.put = decode<Operation>(value.json_str()) ?
			}
			'post' {
				path_item.post = decode<Operation>(value.json_str()) ?
			}
			'delete' {
				path_item.delete = decode<Operation>(value.json_str()) ?
			}
			'options' {
				path_item.options = decode<Operation>(value.json_str()) ?
			}
			'head' {
				path_item.head = decode<Operation>(value.json_str()) ?
			}
			'patch' {
				path_item.patch = decode<Operation>(value.json_str()) ?
			}
			'trace' {
				path_item.trace = decode<Operation>(value.json_str()) ?
			}
			'servers' {
				path_item.servers = decode_array<Server>(value.json_str()) ?
			}
			'parameters' {
				path_item.parameters = decode<[]ObjectRef<Parameter>>(value.json_str()) ?
			}
			else {}
		}
	}
}

pub fn (mut paths map[string]PathItem) from_json(json Any) ? {
	for key, value in json.as_map() {
		if !key.starts_with('/') {
			return error('Failed map[string]PathItem decoding: path do not start with "/" !')
		}

		for path in paths.keys() {
			cleaned_path := clean_path_expression(path)
			cleaned_k := clean_path_expression(key)

			if cleaned_path == cleaned_k {
				return error('Failed map[string]PathItem decoding: Identical path found !')
			}
		}

		paths[key] = decode<PathItem>(value.json_str()) ?
	}
}
