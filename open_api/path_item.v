module open_api

import x.json2 { raw_decode, Any, decode }

struct PathItem {
mut:
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

pub fn (mut path_item PathItem) from_json(f Any) {
	obj := f.as_map()
	for k, v in obj {
		match k {
			'\$ref' {
				path_item.ref = v.str()
			}
			'summary' {
				path_item.summary = v.str()
			}
			'description' {
				path_item.description = v.str()
			}
			'get' {
				path_item.get = decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'put' {
				path_item.put = decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'post' {
				path_item.post = decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'delete' {
				path_item.delete = decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'options' {
				path_item.options = decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'head' {
				path_item.head = decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'patch' {
				path_item.patch = decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'trace' {
				path_item.trace = decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'servers' {
				path_item.servers = decode_array<Server>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'parameters' {
				path_item.parameters = decode<[]ObjectRef<Parameter>>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			else {}
		}
	}
}

pub fn (mut paths map[string]PathItem) from_json(f Any) {
	obj := f.as_map()

	for k, v in obj {
		if !k.starts_with('/') {
			panic('Failed map[string]PathItem decoding: path do not start with "/" !')
		}

		for path in paths.keys() {
			cleaned_path := clean_path_expression(path)
			cleaned_k := clean_path_expression(k)

			if cleaned_path == cleaned_k {
				panic('Failed map[string]PathItem decoding: Identical path found !')
			}
		}

		paths[k] = decode<PathItem>(v.json_str()) or {
			panic('Failed map[string]PathItem decoding: $err')
		}
	}
}