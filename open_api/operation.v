module open_api

import x.json2 { Any }

struct Operation {
mut:
	external_docs ExternalDocumentation           [json: 'externalDocs']
	operation_id  string                          [json: 'operationId']
	request_body  RequestBody | Reference         [json: 'requestBody']
	tags          []string
	summary       string
	description   string
	parameters    []Reference | Parameter
	responses     Responses
	callbacks     map[string]Callback | Reference
	deprecated    bool
	security      []SecurityRequirement
	servers       []Server
}

pub fn (mut operation Operation) from_json(json Any) {
}

struct ExternalDocumentation {
mut:
	description string
	url         string [required]
}

pub fn (mut external_doc ExternalDocumentation) from_json(json Any) {
}
