module open_api

import x.json2 { Any }
import json

struct Responses {
pub mut:
	default_response ObjectRef<Response>
	http_status_code ObjectRef<Response> // Todo: find a way to do integer matching
}

pub fn (mut responses Responses) from_json(json Any) ? {
	for key, value in json.as_map() {
		match key {
			'default' {
				responses.default_response = from_json<Response>(value.json_str()) ?
			}
			// Todo finish status code
			else {}
		}
	}
}

// ---------------------------------------- //

struct Response {
pub mut:
	description string
	headers     map[string]ObjectRef<Header>
	content     map[string]MediaType
	links       map[string]ObjectRef<Link>
}

pub fn (mut response Response) from_json(json Any) ? {
	object := json.as_map()
	check_required<Response>(object, 'description') ?

	for key, value in object {
		match key {
			'description' {
				response.description = value.str()
			}
			'headers' {
				response.headers = decode_map_sumtype<Header>(value.json_str(), fake_predicat) or {
					return error('Failed Response decoding: $err')
				}
			}
			'content' {
				response.content = decode_map<MediaType>(value.json_str()) or {
					return error('Failed Response decoding: $err')
				}
			}
			'links' {
				response.links = decode_map_sumtype<Link>(value.json_str(), fake_predicat) or {
					return error('Failed Response decoding: $err')
				}
			}
			else {}
		}
	}
}
