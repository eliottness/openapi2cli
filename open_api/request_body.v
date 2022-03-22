module open_api

import x.json2 { Any }
import json

struct RequestBody {
pub mut:
	description string
	content     map[string]MediaType
	required    bool
}

pub fn (mut request_body RequestBody) from_json(json Any) ? {
	object := json.as_map()
	check_required<RequestBody>(object, 'content') ?

	for key, value in object {
		match key {
			'description' {
				request_body.description = value.str()
			}
			'content' {
				request_body.content = decode_map<MediaType>(value.json_str()) or {
					return error('Failed RequestBody decoding: $err')
				}
			}
			'required' {
				request_body.required = value.bool()
			}
			else {}
		}
	}
}

// ---------------------------------------- //

struct MediaType {
pub mut:
	schema   ObjectRef<Schema>
	example  Any
	examples map[string]ObjectRef<Example>
	encoding map[string]Encoding
}

pub fn (mut media_type MediaType) from_json(json Any) ? {
	for key, value in json.as_map() {
		match key {
			'schema' {
				media_type.schema = from_json<Schema>(value.json_str()) ?
			}
			'example' {
				media_type.example = value
			}
			'examples' {
				media_type.examples = decode_map_sumtype<Example>(value.json_str(), fake_predicat) or {
					return error('Failed MediaType decoding: $err')
				}
			}
			'encoding' {
				media_type.encoding = decode_map<Encoding>(value.json_str()) or {
					return error('Failed MediaType decoding: $err')
				}
			}
			else {}
		}
	}
}
