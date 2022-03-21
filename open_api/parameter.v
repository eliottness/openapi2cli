module open_api

import x.json2 { Any }

struct Parameter {
mut: // Todo: To be completed
	location          string [json: 'in'; required]
	name              string [required]
	required          bool   [required]
	allow_empty_value bool   [json: 'allowEmptyValue']
	description       string
	deprecated        bool
}

pub fn (mut parameter Parameter) from_json(json Any) {
}
