module open_api

import x.json2 { Any, decode }
import json

struct OpenApi {
pub mut:
	openapi       string
	info          Info
	paths         map[string]PathItem
	external_docs ExternalDocumentation
	servers       []Server
	components    Components
	security      []SecurityRequirement
	tags          []Tag
}

pub fn (mut open_api OpenApi) from_json(json Any) {
	object := json.as_map()

	check_required<OpenApi>(object, 'openapi', 'info', 'paths')

	for key, value in object {
		match key {
			'openapi' {
				open_api.openapi = value.str()
			}
			'info' {
				open_api.info = decode<Info>(value.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'paths' {
				open_api.paths = decode<map[string]PathItem>(value.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'externalDocs' {
				open_api.external_docs = decode<ExternalDocumentation>(value.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'servers' {
				open_api.servers = decode_array<Server>(value.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'components' {
				open_api.components = decode<Components>(value.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'security' {
				open_api.security = decode_array<SecurityRequirement>(value.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'tags' {
				open_api.tags = decode_array<Tag>(value.json_str()) or {
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

pub fn (mut schema Schema) from_json(json Any) {
}
