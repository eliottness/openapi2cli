module open_api

import x.json2 { Any }
import json
import regex

struct Components {
pub mut:
	security_schemes map[string]ObjectRef<SecurityScheme>
	request_bodies   map[string]ObjectRef<RequestBody>
	schemas          map[string]ObjectRef<Schema>
	responses        map[string]ObjectRef<Response>
	parameters       map[string]ObjectRef<Parameter>
	examples         map[string]ObjectRef<Example>
	headers          map[string]ObjectRef<Header>
	links            map[string]ObjectRef<Link>
	callbacks        map[string]ObjectRef<Callback>
}

fn check_key_regex(str string) bool {
	mut reg := regex.regex_opt(r'^[\w\.\-]+$') or { panic('Failed to initialize regex expression') }
	return reg.matches_string(str)
}

pub fn (mut components Components) from_json(json Any) ? {
	for key, value in json.as_map() {
		match key {
			'securitySchemes' {
				components.security_schemes = decode_map_sumtype<SecurityScheme>(value.json_str(),
					check_key_regex) ?
			}
			'requestBodies' {
				components.request_bodies = decode_map_sumtype<RequestBody>(value.json_str(),
					check_key_regex) ?
			}
			'schemas' {
				components.schemas = decode_map_sumtype<Schema>(value.json_str(), check_key_regex) or {
					return error('Failed Components decoding: $err')
				}
			}
			'responses' {
				components.responses = decode_map_sumtype<Response>(value.json_str(),
					check_key_regex) ?
			}
			'parameters' {
				components.parameters = decode_map_sumtype<Parameter>(value.json_str(),
					check_key_regex) ?
			}
			'examples' {
				components.examples = decode_map_sumtype<Example>(value.json_str(), check_key_regex) or {
					return error('Failed Components decoding: $err')
				}
			}
			'headers' {
				components.headers = decode_map_sumtype<Header>(value.json_str(), check_key_regex) or {
					return error('Failed Components decoding: $err')
				}
			}
			'links' {
				components.links = decode_map_sumtype<Link>(value.json_str(), check_key_regex) or {
					return error('Failed Components decoding: $err')
				}
			}
			'callbacks' {
				components.callbacks = decode_map_sumtype<Callback>(value.json_str(),
					check_key_regex) ?
			}
			else {}
		}
	}
}
