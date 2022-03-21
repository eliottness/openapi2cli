module open_api

import x.json2 { Any }
import json

struct Server {
pub mut:
	url         string
	description string
	variables   map[string]ServerVariable
}

pub fn (mut server Server) from_json(json Any) {
	object := json.as_map()
	check_required<Server>(object, 'url')

	for key, value in object {
		match key {
			'url' {
				server.url = value.str()
			}
			'description' {
				server.description = value.str()
			}
			'variables' {
				server.variables = decode_map<ServerVariable>(value.json_str()) or {
					panic('Failed Server decoding: $err')
				}
			}
			else {}
		}
	}
}

// ---------------------------------------- //

struct ServerVariable {
pub mut:
	default_value string
	enum_values   string
	description   string
}

pub fn (mut server_variable ServerVariable) from_json(json Any) {
	object := json.as_map()
	check_required<ServerVariable>(object, 'default')

	for key, value in object {
		match key {
			'default' { server_variable.default_value = value.str() }
			'enum' { server_variable.enum_values = value.str() }
			'description' { server_variable.description = value.str() }
			else {}
		}
	}
}
