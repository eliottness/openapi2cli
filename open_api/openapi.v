module open_api

import x.json2 { Any, decode, raw_decode }

struct OpenApi {
mut:
	openapi       string
	info          Info
	paths         map[string]PathItem
	external_docs ExternalDocumentation
	servers       []Server
	components    Components
	security      []SecurityRequirement
	tags          []Tag
}

pub fn (mut open_api OpenApi) from_json(f Any) {
	obj := f.as_map()

	check_required<OpenApi>(obj, 'openapi', 'info', 'paths')

	for k, v in obj {
		match k {
			'openapi' {
				open_api.openapi = v.str()
			}
			'info' {
				open_api.info = decode<Info>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'paths' {
				open_api.paths = decode<map[string]PathItem>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'externalDocs' {
				open_api.external_docs = decode<ExternalDocumentation>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'servers' {
				open_api.servers = decode_array<Server>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'components' {
				open_api.components = decode<Components>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'security' {
				open_api.security = decode_array<SecurityRequirement>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'tags' {
				open_api.tags = decode_array<Tag>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			else {}
		}
	}
}

// ---------------------------------------- //

struct Schema {
	// Todo: flemme
}

pub fn (mut schema Schema) from_json(f Any) {

}
