module open_api

import x.json2 { Any, decode, raw_decode }

struct Link {
mut:
	operation_ref string         [json: 'operationRef']
	operation_id  string         [json: 'operationId']
	request_body  Any            [json: 'requestBody']
	parameters    map[string]Any
	description   string
	server        Server
}

pub fn (mut link Link) from_json(f Any) {
}