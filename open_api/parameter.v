module open_api

import x.json2 { Any }
import json

struct Parameter {
pub mut: // Todo: To be completed
	location          string
	name              string
	required          bool
	allow_empty_value bool
	description       string
	deprecated        bool
}

pub fn (mut parameter Parameter) from_json(json Any) ? {
	object := json.as_map()
	check_required<Parameter>(object, 'in', 'name', 'required') ?

	for key, value in json.as_map() {
		match key {
			'in' {
				parameter.location = value.str()
			}
			'name' {
				parameter.name = value.str()
			}
			'required' {
				parameter.required = value.bool()
			}
			'allowEmptyValue' {
				parameter.allow_empty_value = value.bool()
			}
			'description' {
				parameter.description = value.str()
			}
			'deprecated' {
				parameter.deprecated = value.bool()
			}
			else {}
		}
	}
}
