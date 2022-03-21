module open_api

import x.json2 { Any, decode, raw_decode }

struct Responses {
mut:
	default_code     Response | Reference [json: 'default']
	http_status_code Response | Reference // Todo: find a way to do integer matching
}

pub fn (mut responses Responses) from_json(f Any) {
}

// ---------------------------------------- //

struct Response {
mut:
	description string                        [required]
	headers     map[string]Header | Reference
	content     map[string]MediaType
	links       map[string]Link | Reference
}

pub fn (mut response Response) from_json(f Any) {
}