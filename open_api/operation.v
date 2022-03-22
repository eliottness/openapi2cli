module open_api

import x.json2 { Any, decode }
import json

struct Operation {
pub mut:
	external_docs ExternalDocumentation
	operation_id  string
	request_body  ObjectRef<RequestBody>
	tags          []string
	summary       string
	description   string
	parameters    []ObjectRef<Parameter>
	responses     Responses
	callbacks     map[string]ObjectRef<Callback>
	deprecated    bool
	security      []SecurityRequirement
	servers       []Server
}

pub fn (mut operation Operation) from_json(json Any) {
	object := json.as_map()
	check_required<Operation>(object, 'responses')

	for key, value in json.as_map() {
		match key {
			'externalDocs' {
				operation.external_docs = decode<ExternalDocumentation>(value.json_str()) or {
					panic('Failed Operation decoding: $err')
				}
			}
			'operationId' {
				operation.operation_id = value.str()
			}
			'request_body' {
				operation.request_body = from_json<RequestBody>(value)
			}
			'tags' {
				operation.tags = decode_array_string(value.json_str()) or {
					panic('Failed Operation decoding: $err')
				}
			}
			'summary' {
				operation.summary = value.str()
			}
			'description' {
				operation.description = value.str()
			}
			'parameters' {
				operation.parameters = decode<[]ObjectRef<Parameter>>(value.json_str()) or {
					panic('Failed Operation decoding: $err')
				}
			}
			'responses' {
				operation.responses = decode<Responses>(value.json_str()) or {
					panic('Failed Operation decoding: $err')
				}
			}
			'callbacks' {
				operation.callbacks = decode_map_sumtype<Callback>(value.json_str()) or {
					panic('Failed Operation decoding: $err')
				}
			}
			'deprecated' {
				operation.deprecated = value.bool()
			}
			'security' {
				operation.security = decode_array<SecurityRequirement>(value.json_str()) or {
					panic('Failed Operation decoding: $err')
				}
			}
			'servers' {
				operation.servers = decode_array<Server>(value.json_str()) or {
					panic('Failed Operation decoding: $err')
				}
			}
			else {}
		}
	}
}

struct ExternalDocumentation {
pub mut:
	description string
	url         string
}

pub fn (mut external_doc ExternalDocumentation) from_json(json Any) {
	object := json.as_map()
	check_required<ExternalDocumentation>(object, 'url')

	for key, value in object {
		match key {
			'description' {
				external_doc.description = value.str()
			}
			'url' {
				external_doc.url = value.str()
			}
			else {}
		}
	}
}
