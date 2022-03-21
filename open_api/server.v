module open_api

import x.json2 { Any, decode, raw_decode }

struct Server {
mut:
	url         string
	description string
	variables   map[string]ServerVariable
}

pub fn (mut server Server) from_json(f Any) {
	obj := f.as_map()

	if 'url' !in obj {
		panic('Failed Server decoding: "url" not specified !')
	}

	for k, v in obj {
		match k {
			'url' {
				server.url = v.str()
			}
			'description' {
				server.description = v.str()
			}
			'variables' {
				server.variables = decode_map<ServerVariable>(v.json_str()) or {
					panic('Failed Server decoding: $err')
				}
			}
			else {}
		}
	}
}

// ---------------------------------------- //

struct ServerVariable {
mut:
	default_value string
	enum_values   string
	description   string
}

pub fn (mut server_variable ServerVariable) from_json(f Any) {
	obj := f.as_map()

	if 'default' !in obj {
		panic('Failed ServerVariable decoding: "default" not specified !')
	}

	for k, v in obj {
		match k {
			'default' { server_variable.default_value = v.str() }
			'enum' { server_variable.enum_values = v.str() }
			'description' { server_variable.description = v.str() }
			else {}
		}
	}
}