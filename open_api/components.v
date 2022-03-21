module open_api

import x.json2 { Any, decode, raw_decode }


struct Components {
mut:
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

pub fn (mut components Components) from_json(f Any) {
	obj := f.as_map()

	check_required<OpenApi>(obj, 'openapi', 'info', 'paths')

	for k, v in obj {
		match k {
			'SecuritySchemes' {
				components.security_schemes = decode_map_sumtype<SecurityScheme>(v.json_str()) or {
					panic('Failed Components decoding: $err')
				}
			}
			'requestBodies' {
				components.request_bodies = decode_map_sumtype<RequestBody>(v.json_str()) or {
					panic('Failed Components decoding: $err')
				}
			}
			'schemas' {
				components.schemas = decode_map_sumtype<Schema>(v.json_str()) or {
					panic('Failed Components decoding: $err')
				}
			}
			'responses' {
				components.responses = decode_map_sumtype<Response>(v.json_str()) or {
					panic('Failed Components decoding: $err')
				}
			}
			'parameters' {
				components.parameters = decode_map_sumtype<Parameter>(v.json_str()) or {
					panic('Failed Components decoding: $err')
				}
			}
			'examples' {
				components.examples = decode_map_sumtype<Example>(v.json_str()) or {
					panic('Failed Components decoding: $err')
				}
			}
			'headers' {
				components.headers = decode_map_sumtype<Header>(v.json_str()) or {
					panic('Failed Components decoding: $err')
				}
			}
			'links' {
				components.links = decode_map_sumtype<Link>(v.json_str()) or {
					panic('Failed Components decoding: $err')
				}
			}
			'callbacks' {
				components.callbacks = decode_map_sumtype<Callback>(v.json_str()) or {
					panic('Failed Components decoding: $err')
				}
			}
			else {}
		}
	}
}