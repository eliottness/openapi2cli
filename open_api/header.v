module open_api

import x.json2 { Any }
import json

struct Header {
pub mut:
	required          bool
	allow_empty_value bool
	description       string
	deprecated        bool
}

pub fn (mut header Header) from_json(json Any) {
	object := json.as_map()
	check_required<Header>(object, 'required')

	for key, value in object {
		match key {
			'required' {
				header.required = value.bool()
			}
			'allowEmptyValue' {
				header.allow_empty_value = value.bool()
			}
			'description' {
				header.description = value.str()
			}
			'deprecated' {
				header.deprecated = value.bool()
			}
			else {}
		}
	}
}
