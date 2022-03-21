module open_api

import x.json2 { Any, decode, raw_decode }

struct RequestBody {
mut:
	description string
	content     map[string]MediaType [required]
	required    bool
}

pub fn (mut request_body RequestBody) from_json(f Any) {
}

// ---------------------------------------- //

struct MediaType {
mut:
	schema   Schema | Reference
	example  Any
	examples map[string]Example | Reference
	encoding map[string]Encoding
}

pub fn (mut media_type MediaType) from_json(f Any) {
}