module open_api

import x.json2 { Any, decode, raw_decode }

struct SecurityRequirement {
mut:
	requirements map[string][]string // Todo: make it match the '{name}' type
}

pub fn (mut requirement SecurityRequirement) from_json(f Any) {
}

// ---------------------------------------- //

struct SecurityScheme {
mut:
	security_type       string     [json: 'type'; required]
	location            string     [json: 'in'; required]
	open_id_connect_url string     [json: 'openIdConnectUrl'; required]
	name                string     [required]
	scheme              string     [required]
	flows               OAuthFlows [required]
	bearer_format       string     [json: 'bearerFormat']
	description         string
}

pub fn (mut security_scheme SecurityScheme) from_json(f Any) {
}

// ---------------------------------------- //

struct OAuthFlows {
mut:
	client_credentials OAuthFlow [json: 'clientCredentials']
	authorization_code OAuthFlow [json: 'authorizationCode']
	implicit           OAuthFlow
	password           OAuthFlow
}

pub fn (mut flows OAuthFlows) from_json(f Any) {
}

// ---------------------------------------- //

struct OAuthFlow {
mut:
	authorization_url string            [json: 'authorizationUrl'; required]
	token_url         string            [json: 'tokenUrl'; required]
	scopes            map[string]string [required]
	refresh_url       string            [json: 'refreshUrl']
}

pub fn (mut flow OAuthFlow) from_json(f Any) {
}