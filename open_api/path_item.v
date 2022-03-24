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

pub fn (mut path_item PathItem) from_json(json Any) ? {
	object := json.as_map()
	for key, value in object {
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
	path_item.validate(object) ?
}

fn (mut path_item PathItem) validate(object map[string]Any) ? {
	mut checked := map[string]string{}
	for parameter in path_item.parameters {
		if parameter is Reference {
			continue
		}
		param := parameter as Parameter
		if param.name in checked && checked[param.name] == param.location {
			return error('Failed Path_item decoding: parameter with identical "name" and "in" found.')
		}
		checked[param.name] = param.location
	}
}

// ---------------------------------------- //

fn clean_path_expression(path string) string {
	mut path_copy := path.clone()
	mut expression := path_copy.find_between('{', '}')

	for expression != '' {
		path_copy = path_copy.replace(expression, '')
		expression = path_copy.find_between('{', '}')
	}

	return path_copy
}

pub fn (mut paths map[string]PathItem) from_json(json Any) ? {
	mut save_value := map[string][]string{}
	for key, value in json.as_map() {
		if !key.starts_with('/') {
			return error('Failed map[string]PathItem decoding: path do not start with "/" !')
		}

		path_item := decode<PathItem>(value.json_str()) ?
		value_key := value.as_map().keys()

		for path in paths.keys() {
			cleaned_path := clean_path_expression(path)
			cleaned_key := clean_path_expression(key)

			path_item_ref := paths[path]
			value_ref := save_value[path]

			if cleaned_path == cleaned_key {
				verif := ('get' in value_key && 'get' in value_ref)
					|| ('put' in value_key && 'put' in value_ref)
					|| ('post' in value_key && 'post' in value_ref)
					|| ('delete' in value_key && 'delete' in value_ref)
					|| ('options' in value_key && 'options' in value_ref)
					|| ('head' in value_key && 'head' in value_ref)
					|| ('patch' in value_key && 'patch' in value_ref)
					|| ('trace' in value_key && 'trace' in value_ref)
				if verif {
					return error('Failed map[string]PathItem decoding: Identical path found $key $path!')
				}
			}
		}

		save_value[key] = value_key
		paths[key] = path_item
	}
}
