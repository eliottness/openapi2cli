module open_api

import x.json2 { Any }
import json

struct Encoding {
pub mut:
	content_type   string
	allow_reserved bool
	headers        map[string]ObjectRef<Header>
	style          string
	explode        bool
}

pub fn (mut encoding Encoding) from_json(json Any) {
	for key, value in json.as_map() {
		match key {
			'contentType' {
				encoding.content_type = value.str()
			}
			'allowReserved' {
				encoding.allow_reserved = value.bool()
			}
			'headers' {
				encoding.headers = decode_map_sumtype<Header>(value.json_str(), fake_predicat) or {
					panic('Failed "Encoding" decoding: $err')
				}
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
