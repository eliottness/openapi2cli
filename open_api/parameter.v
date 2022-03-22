module open_api

import x.json2 { Any }
import json

struct Parameter {
pub mut: // Todo: To be completed
	name              string
	location          string
	description       string
	required          bool
	deprecated        bool
	allow_empty_value bool
	style             string
	explode           bool
	allow_reserved    bool
	schema            ObjectRef<Schema>
	example           Any
	examples          map[string]ObjectRef<Example>
	content           map[string]MediaType
}

pub fn (mut parameter Parameter) from_json(json Any) ? {
	object := json.as_map()
	check_required<Parameter>(object, 'in', 'name', 'required') ?

	for key, value in json.as_map() {
		match key {
			'name' {
				parameter.name = value.str()
			}
			'in' {
				parameter.location = value.str()
			}
			'description' {
				parameter.description = value.str()
			}
			'required' {
				parameter.required = value.bool()
			}
			'deprecated' {
				parameter.deprecated = value.bool()
			}
			'allowEmptyValue' {
				parameter.allow_empty_value = value.bool()
			}
			'style' {
				parameter.style = value.str()
			}
			'explode' {
				parameter.explode = value.bool()
			}
			'allowReserved' {
				parameter.allow_reserved = value.bool()
			}
			'schema' {
				parameter.schema = from_json<Schema>(value) ?
			}
			'example' {
				parameter.example = value
			}
			'examples' {
				parameter.examples = decode_map_sumtype<Example>(value.json_str(), fake_predicat) ?
			}
			'content' {
				parameter.content = decode_map<MediaType>(value.json_str()) ?
			}
			else {}
		}
	}
}
