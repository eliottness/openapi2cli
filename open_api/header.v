module open_api

import x.json2 { Any, decode, raw_decode }

struct Header {
mut:
	required          bool   [required]
	allow_empty_value bool   [json: 'allowEmptyValue']
	description       string
	deprecated        bool
}

pub fn (mut header Header) from_json(f Any) {
}
