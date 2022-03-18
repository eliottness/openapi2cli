module open_api

import x.json2

struct OpenApi {
mut:
    openapi       string
    info          Info
    paths         map[string]PathItem
    external_docs ExternalDocumentation
    servers       []Server
    components    Components
    security      []SecurityRequirement
    tags          []Tag
}

fn (mut open_api OpenApi) from_json(f json2.Any) {
    obj := f.as_map()
	
	required_fields := ['openapi', 'info', 'paths']
	for field in required_fields {
		if !(field in obj) {
			panic('Failed OpenApi decoding: "$field" not specified !')
		}
	}

	for k, v in obj {
        match k {
            'openapi' { open_api.openapi = v.str() }
            'info' { open_api.info = json2.decode<Info>(v.json_str()) or { panic('Failed OpenApi decoding: $err')} }
			'paths' { open_api.paths = json2.decode<map[string]PathItem>(v.json_str()) or { panic('Failed OpenApi decoding: $err')} }
			'externalDocs' { open_api.external_docs = json2.decode<ExternalDocumentation>(v.json_str()) or { panic('Failed OpenApi decoding: $err')} }
			'servers' { open_api.servers = json2.decode<[]Server>(v.json_str()) or { panic('Failed OpenApi decoding: $err')} }
			'components' { open_api.components = json2.decode<Components>(v.json_str()) or { panic('Failed OpenApi decoding: $err')} }
            'security' { open_api.security = json2.decode<[]SecurityRequirement>(v.json_str()) or { panic('Failed OpenApi decoding: $err')} }
            'tags' { open_api.tags = json2.decode<[]Tag>(v.json_str()) or { panic('Failed OpenApi decoding: $err')} }
            else {}
        }
    }
}

// ---------------------------------------- //

struct Info {
mut:
    title            string
    version          string
    terms_of_service string
    description      string
    contact          Contact
    license          License
}

fn (mut info Info) from_json(f json2.Any) {
    obj := f.as_map()
	
	required_fields := ['title', 'version']
	for field in required_fields {
		if !(field in obj) {
			panic('Failed Info decoding: "$field" not specified !')
		}
	}

	for k, v in obj {
        match k {
            'title' { info.title = v.str() }
            'version' { info.version = v.str() }
            'termsOfService' { info.terms_of_service = v.str() }
			'description' { info.description = v.str() }
			'contact' { info.contact = json2.decode<Contact>(v.json_str()) or { panic('Failed Info decoding: $err')} }
			'license' { info.license = json2.decode<License>(v.json_str()) or { panic('Failed Info decoding: $err')} }
            else {}
        }
    }
}

// ---------------------------------------- //

struct Contact {
mut:
    name  string
    url   string
    email string
}

fn (mut contact Contact) from_json(f json2.Any) {
    obj := f.as_map()
    for k, v in obj {
        match k {
            'name' { contact.name = v.str() }
            'url' { contact.url = v.str() }
            'email' { contact.email = v.str() }
            else {}
        }
    }
}

// ---------------------------------------- //

struct License {
mut:
    name string
    url  string
}

fn (mut license License) from_json(f json2.Any) {
    obj := f.as_map()

	if !('name' in obj) {
		panic('Failed Info decoding: "name" not specified !')
	}

    for k, v in obj {
        match k {
            'name' { license.name = v.str() }
            'url' { license.url = v.str() }
            else {}
        }
    }
}

// ---------------------------------------- //

struct PathItem {
mut:
    ref         string [json: '\$ref']
    summary     string
    description string
    get         Operation
    put         Operation
    post        Operation
    delete      Operation
    options     Operation
    head        Operation
    patch       Operation
    trace       Operation
    servers     []Server
    parameters  []Parameter | Reference
}

fn (mut paths map[string]PathItem) from_json(f json2.Any) {

}

fn (mut path_item PathItem) from_json(f json2.Any) {
    obj := f.as_map()

	for k, v in obj {
        match k {
            'description' { path_item.description = v.str() }
            else {}
        }
    }
}

// ---------------------------------------- //

struct Callback {
mut:
    callback map[string]PathItem // Todo: make it match the '{expression}' type
}

fn (mut callback Callback) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Operation {
mut:
    external_docs ExternalDocumentation             [json: 'externalDocs']
    operation_id  string                            [json: 'operationId']
    request_body  RequestBody | Reference           [json: 'requestBody']
    tags          []string
    summary       string
    description   string
    parameters    []Parameter | Reference
    responses     Responses
    callbacks     map[string]Callback | Reference
    deprecated    bool
    security      []SecurityRequirement
    servers       []Server
}

fn (mut operation Operation) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Components {
mut:
    security_schemes map[string]SecurityScheme | Reference [json: 'SecuritySchemes']
    request_bodies   map[string]RequestBody | Reference    [json: 'requestBodies']
    schemas          map[string]Schema | Reference
    responses        map[string]Response | Reference
    parameters       map[string]Parameter | Reference
    examples         map[string]Example | Reference
    headers          map[string]Header | Reference
    links            map[string]Link | Reference
    callbacks        map[string]Callback | Reference
}

fn (mut components Components) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct SecurityRequirement {
mut:
    requirements map[string][]string // Todo: make it match the '{name}' type
}

fn (mut requirements []SecurityRequirement) from_json(f json2.Any) {

}

fn (mut requirement SecurityRequirement) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct SecurityScheme {
mut:
    security_type       string     [required; json: 'type']
    location            string     [required; json: 'in']
    open_id_connect_url string     [required; json: 'openIdConnectUrl']
    name                string     [required]
    scheme              string     [required]
    flows               OAuthFlows [required]
    bearer_format       string     [json: 'bearerFormat']
    description         string
}

fn (mut security_scheme SecurityScheme) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct OAuthFlows {
mut:
    client_credentials OAuthFlow [json: 'clientCredentials']
    authorization_code OAuthFlow [json: 'authorizationCode']
    implicit           OAuthFlow
    password           OAuthFlow
}

fn (mut flows OAuthFlows) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct OAuthFlow {
mut:
    authorization_url string              [required; json: 'authorizationUrl']
    token_url         string              [required; json: 'tokenUrl']
    scopes            map[string]string [required]
    refresh_url       string              [json: 'refreshUrl']
}

fn (mut flow OAuthFlow) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Tag {
mut:
    name          string                [required]
    external_docs ExternalDocumentation [json: 'externalDocs']
    description   string
}

fn (mut tags []Tag) from_json(f json2.Any) {

}

fn (mut tag Tag) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct ExternalDocumentation {
mut:
    description string
    url         string [required]
}

fn (mut external_doc ExternalDocumentation) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Parameter { // Todo: To be completed
mut:
    location          string [required; json: 'in']
    name              string [required]
    required          bool   [required]
    allow_empty_value bool   [json: 'allowEmptyValue']
    description       string
    deprecated        bool
}

fn (mut parameter Parameter) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct RequestBody {
mut:
    description string
    content     map[string]MediaType [required]
    required    bool
}

fn (mut request_body RequestBody) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct MediaType {
mut:
    schema   Schema | Reference
    example  json2.Any
    examples map[string]Example | Reference
    encoding map[string]Encoding
}

fn (mut media_type MediaType) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Schema {
    // Todo: flemme
}

// ---------------------------------------- //

struct Reference {
mut:
    ref string [required; json: '\$ref']
}

fn (mut reference Reference) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Example {
mut:
    external_value string [json: 'externalValue']
    summary        string
    description    string
    value          json2.Any
}

fn (mut example Example) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Encoding {
mut:
    content_type   string                          [json: 'contentType']
    allow_reserved bool                            [json: 'allowReserved']
    headers        map[string]Header | Reference
    style          string
    explode        bool
}

fn (mut encoding Encoding) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Header {
mut:
    required          bool   [required]
    allow_empty_value bool   [json: 'allowEmptyValue']
    description       string
    deprecated        bool
}

fn (mut header Header) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Responses {
mut:
    default_code     Response | Reference [json: 'default']
    http_status_code Response | Reference // Todo: find a way to do integer matching
}

fn (mut responses Responses) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Response {
mut:
    description string [required]
    headers     map[string]Header | Reference
    content     map[string]MediaType
    links       map[string]Link | Reference
}

fn (mut response Response) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Link {
mut:
    operation_ref string              [json: 'operationRef']
    operation_id  string              [json: 'operationId']
    request_body  json2.Any           [json: 'requestBody']
    parameters    map[string]json2.Any
    description   string
    server        Server
}

fn (mut link Link) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct Server {
mut:
    url         string [required]
    description string
    variables   map[string]ServerVariable
}

fn (mut servers []Server) from_json(f json2.Any) {

}

fn (mut server Server) from_json(f json2.Any) {

}

// ---------------------------------------- //

struct ServerVariable {
mut:
    default_value string [required; json: 'default']
    enum_values   string [json: 'enum']
    description   string
}

fn (mut server_variable ServerVariable) from_json(f json2.Any) {

}
