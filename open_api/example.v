module open_api

import x.json2 { Any }
import json

struct Example {
pub mut:
	external_value string
	summary        string
	description    string
	value          Any
}

pub fn (mut example Example) from_json(json Any) {
	for key, value in json.as_map() {
		match key {
			'externalValue' {
				example.external_value = value.str()
			}
			'summary' {
				example.summary = value.str()
			}
			'description' {
				example.description = value.str()
			}
			'value' {
				example.value = value
			}
			else {}
		}
	}
}
