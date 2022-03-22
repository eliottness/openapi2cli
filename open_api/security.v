module open_api

import x.json2 { Any, decode }
import json

struct SecurityRequirement {
pub mut:
	requirements map[string][]string // Todo: make it match the '{name}' type
}

pub fn (mut requirement SecurityRequirement) from_json(json Any) {
	// Todo
}

// ---------------------------------------- //

struct SecurityScheme {
pub mut:
	security_type       string     [json: 'type'; required]
	location            string     [json: 'in'; required]
	open_id_connect_url string     [json: 'openIdConnectUrl'; required]
	name                string     [required]
	scheme              string     [required]
	flows               OAuthFlows [required]
	bearer_format       string     [json: 'bearerFormat']
	description         string
}

pub fn (mut security_scheme SecurityScheme) from_json(json Any) {
}

// ---------------------------------------- //

struct OAuthFlows {
pub mut:
	client_credentials OAuthFlow
	authorization_code OAuthFlow
	implicit           OAuthFlow
	password           OAuthFlow
}

pub fn (mut flows OAuthFlows) from_json(json Any) {
	for key, value in json.as_map() {
		match key {
			'clientCredentials' {
				flows.client_credentials = decode<OAuthFlow>(value.json_str()) or {
					panic('Failed OAuthFlows decoding: $err')
				}
			}
			'authorizationCode' {
				flows.authorization_code = decode<OAuthFlow>(value.json_str()) or {
					panic('Failed OAuthFlows decoding: $err')
				}
			}
			'implicit' {
				flows.implicit = decode<OAuthFlow>(value.json_str()) or {
					panic('Failed OAuthFlows decoding: $err')
				}
			}
			'password' {
				flows.password = decode<OAuthFlow>(value.json_str()) or {
					panic('Failed OAuthFlows decoding: $err')
				}
			}
			else {}
		}
	}
}

// ---------------------------------------- //

struct OAuthFlow {
pub mut:
	authorization_url string
	token_url         string
	scopes            map[string]string
	refresh_url       string
}

pub fn (mut flow OAuthFlow) from_json(json Any) {
	object := json.as_map()
	check_required<OAuthFlow>(object, 'authorizationUrl', 'tokenUrl', 'scopes')

	for key, value in object {
		match key {
			'authorizationUrl' {
				flow.authorization_url = value.str()
			}
			'tokenUrl' {
				flow.token_url = value.str()
			}
			'scopes' {
				flow.scopes = decode_map_string(value.json_str()) or {
					panic('Failed OAuthFlow decoding: $err')
				}
			}
			'refreshUrl' {
				flow.refresh_url = value.str()
			}
			else {}
		}
	}
}
