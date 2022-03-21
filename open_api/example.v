module open_api

import x.json2 { Any }

struct Example {
pub mut:
	external_value string [json: 'externalValue']
	summary        string
	description    string
	value          Any
}

pub fn (mut example Example) from_json(json Any) {
}
