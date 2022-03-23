module open_api

import x.json2 { Any }
import json

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
				media_type.examples = decode_map_sumtype<Example>(value.json_str(), fake_predicat) ?
			}
			'encoding' {
				media_type.encoding = decode_map<Encoding>(value.json_str()) ?
			}
			else {}
		}
	}
}

// ---------------------------------------- //

struct Encoding {
pub mut:
	content_type   string
	allow_reserved bool
	headers        map[string]ObjectRef<Header>
	style          string
	explode        bool
}

pub fn (mut encoding Encoding) from_json(json Any) ? {
	for key, value in json.as_map() {
		match key {
			'contentType' {
				encoding.content_type = value.str()
			}
			'allowReserved' {
				encoding.allow_reserved = value.bool()
			}
			'headers' {
				encoding.headers = decode_map_sumtype<Header>(value.json_str(), fake_predicat) ?
			}
			'style' {
				encoding.style = value.str()
			}
			'explode' {
				encoding.explode = value.bool()
			}
			else {}
		}
	}
}