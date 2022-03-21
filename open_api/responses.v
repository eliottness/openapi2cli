module open_api

import x.json2 { Any }

struct Responses {
mut:
	default_code     Response | Reference [json: 'default']
	http_status_code Response | Reference // Todo: find a way to do integer matching
}

pub fn (mut responses Responses) from_json(json Any) {
}

// ---------------------------------------- //

struct Response {
mut:
	description string                        [required]
	headers     map[string]Header | Reference
	content     map[string]MediaType
	links       map[string]Link | Reference
}

pub fn (mut response Response) from_json(json Any) {
}
