module open_api

import x.json2

// -----------TEMPLATED FUNCTIONS---------- //

pub fn from_json_array<T>(mut object []T, f json2.Any) {
	obj := f.arr()

	for k in obj {
		object << json2.decode<T>(k.json_str()) or { panic('Failed $T.name decoding: $err') }
	}
}

pub fn from_json_map<T>(mut object map[string]T, f json2.Any) {
	obj := f.as_map()

	for k, v in obj {
		object[k] = json2.decode<T>(v.json_str()) or { panic('Failed $T.name decoding: $err') }
	}
}

// ---------------------------------------- //

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

pub fn (mut open_api OpenApi) from_json(f json2.Any) {
	obj := f.as_map()

	required_fields := ['openapi', 'info', 'paths']
	for field in required_fields {
		if field !in obj {
			panic('Failed OpenApi decoding: "$field" not specified !')
		}
	}

	for k, v in obj {
		match k {
			'openapi' {
				open_api.openapi = v.str()
			}
			'info' {
				open_api.info = json2.decode<Info>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'paths' {
				open_api.paths = json2.decode<map[string]PathItem>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'externalDocs' {
				open_api.external_docs = json2.decode<ExternalDocumentation>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'servers' {
				open_api.servers = json2.decode<[]Server>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'components' {
				open_api.components = json2.decode<Components>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'security' {
				open_api.security = json2.decode<[]SecurityRequirement>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
			'tags' {
				open_api.tags = json2.decode<[]Tag>(v.json_str()) or {
					panic('Failed OpenApi decoding: $err')
				}
			}
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

pub fn (mut info Info) from_json(f json2.Any) {
	obj := f.as_map()

	required_fields := ['title', 'version']
	for field in required_fields {
		if field !in obj {
			panic('Failed Info decoding: "$field" not specified !')
		}
	}

	for k, v in obj {
		match k {
			'title' {
				info.title = v.str()
			}
			'version' {
				info.version = v.str()
			}
			'termsOfService' {
				info.terms_of_service = v.str()
			}
			'description' {
				info.description = v.str()
			}
			'contact' {
				info.contact = json2.decode<Contact>(v.json_str()) or {
					panic('Failed Info decoding: $err')
				}
			}
			'license' {
				info.license = json2.decode<License>(v.json_str()) or {
					panic('Failed Info decoding: $err')
				}
			}
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

pub fn (mut contact Contact) from_json(f json2.Any) {
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

pub fn (mut license License) from_json(f json2.Any) {
	obj := f.as_map()

	if 'name' !in obj {
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
	ref         string
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
	parameters  ParameterRef
}

pub fn clean_path_expression(path string) string {
	mut path_copy := path.clone()
	mut expression := path_copy.find_between('{', '}')

	for expression != '' {
		path_copy = path_copy.replace(expression, '')
		expression = path_copy.find_between('{', '}')
	}

	return path_copy
}

pub fn (mut path_item PathItem) from_json(f json2.Any) {
	obj := f.as_map()
	for k, v in obj {
		match k {
			'\$ref' {
				path_item.ref = v.str()
			}
			'summary' {
				path_item.summary = v.str()
			}
			'description' {
				path_item.description = v.str()
			}
			'get' {
				path_item.get = json2.decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'put' {
				path_item.put = json2.decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'post' {
				path_item.post = json2.decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'delete' {
				path_item.delete = json2.decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'options' {
				path_item.options = json2.decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'head' {
				path_item.head = json2.decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'patch' {
				path_item.patch = json2.decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'trace' {
				path_item.trace = json2.decode<Operation>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'servers' {
				path_item.servers = json2.decode<[]Server>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			'parameters' {
				path_item.parameters = json2.decode<ParameterRef>(v.json_str()) or {
					panic('Failed PathItem decoding: $err')
				}
			}
			else {}
		}
	}
}

pub fn (mut paths map[string]PathItem) from_json(f json2.Any) {
	obj := f.as_map()

	for k, v in obj {
		if !k.starts_with('/') {
			panic('Failed map[string]PathItem decoding: path do not start with "/" !')
		}

		for path in paths.keys() {
			cleaned_path := clean_path_expression(path)
			cleaned_k := clean_path_expression(k)

			if cleaned_path == cleaned_k {
				panic('Failed map[string]PathItem decoding: Identical path found !')
			}
		}

		paths[k] = json2.decode<PathItem>(v.json_str()) or {
			panic('Failed map[string]PathItem decoding: $err')
		}
	}
}

// ---------------------------------------- //

struct Callback {
mut:
	callback map[string]PathItem // Todo: make it match the '{expression}' type
}

pub fn (mut callback Callback) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Operation {
mut:
	external_docs ExternalDocumentation           [json: 'externalDocs']
	operation_id  string                          [json: 'operationId']
	request_body  RequestBody | Reference         [json: 'requestBody']
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

pub fn (mut operation Operation) from_json(f json2.Any) {
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

pub fn (mut components Components) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct SecurityRequirement {
mut:
	requirements map[string][]string // Todo: make it match the '{name}' type
}

pub fn (mut requirements []SecurityRequirement) from_json(f json2.Any) {
}

pub fn (mut requirement SecurityRequirement) from_json(f json2.Any) {
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

pub fn (mut security_scheme SecurityScheme) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct OAuthFlows {
mut:
	client_credentials OAuthFlow [json: 'clientCredentials']
	authorization_code OAuthFlow [json: 'authorizationCode']
	implicit           OAuthFlow
	password           OAuthFlow
}

pub fn (mut flows OAuthFlows) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct OAuthFlow {
mut:
	authorization_url string            [json: 'authorizationUrl'; required]
	token_url         string            [json: 'tokenUrl'; required]
	scopes            map[string]string [required]
	refresh_url       string            [json: 'refreshUrl']
}

pub fn (mut flow OAuthFlow) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Tag {
mut:
	name          string
	external_docs ExternalDocumentation
	description   string
}

pub fn (mut tags []Tag) from_json(f json2.Any) {
	from_json_array<Tag>(mut tags, f)
}

pub fn (mut tag Tag) from_json(f json2.Any) {
	obj := f.as_map()

	if 'name' !in obj {
		panic('Failed Tag decoding: "name" not specified !')
	}

	for k, v in obj {
		match k {
			'name' {
				tag.name = v.str()
			}
			'externalDocs' {
				tag.external_docs = json2.decode<ExternalDocumentation>(v.json_str()) or {
					panic('Failed Tag decoding: $err')
				}
			}
			'description' {
				tag.description = v.str()
			}
			else {}
		}
	}
}

// ---------------------------------------- //

struct ExternalDocumentation {
mut:
	description string
	url         string [required]
}

pub fn (mut external_doc ExternalDocumentation) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Parameter {
mut: // Todo: To be completed
	location          string [json: 'in'; required]
	name              string [required]
	required          bool   [required]
	allow_empty_value bool   [json: 'allowEmptyValue']
	description       string
	deprecated        bool
}

pub fn (mut parameter Parameter) from_json(f json2.Any) {
}

pub fn (mut parameters []Reference) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct RequestBody {
mut:
	description string
	content     map[string]MediaType [required]
	required    bool
}

pub fn (mut request_body RequestBody) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct MediaType {
mut:
	schema   Schema | Reference
	example  json2.Any
	examples map[string]Example | Reference
	encoding map[string]Encoding
}

pub fn (mut media_type MediaType) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Schema {
	// Todo: flemme
}

// ---------------------------------------- //

struct Reference {
mut:
	ref string [json: '\$ref'; required]
}

pub fn (mut reference Reference) from_json(f json2.Any) {
}

// ---------------------------------------- //

type ParameterRef = Reference | []Parameter

pub fn (mut parameters ParameterRef) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Example {
mut:
	external_value string    [json: 'externalValue']
	summary        string
	description    string
	value          json2.Any
}

pub fn (mut example Example) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Encoding {
mut:
	content_type   string                        [json: 'contentType']
	allow_reserved bool                          [json: 'allowReserved']
	headers        map[string]Header | Reference
	style          string
	explode        bool
}

pub fn (mut encoding Encoding) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Header {
mut:
	required          bool   [required]
	allow_empty_value bool   [json: 'allowEmptyValue']
	description       string
	deprecated        bool
}

pub fn (mut header Header) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Responses {
mut:
	default_code     Response | Reference [json: 'default']
	http_status_code Response | Reference // Todo: find a way to do integer matching
}

pub fn (mut responses Responses) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Response {
mut:
	description string                        [required]
	headers     map[string]Header | Reference
	content     map[string]MediaType
	links       map[string]Link | Reference
}

pub fn (mut response Response) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Link {
mut:
	operation_ref string               [json: 'operationRef']
	operation_id  string               [json: 'operationId']
	request_body  json2.Any            [json: 'requestBody']
	parameters    map[string]json2.Any
	description   string
	server        Server
}

pub fn (mut link Link) from_json(f json2.Any) {
}

// ---------------------------------------- //

struct Server {
mut:
	url         string
	description string
	variables   map[string]ServerVariable
}

pub fn (mut servers []Server) from_json(f json2.Any) {
	from_json_array<Server>(mut servers, f)
}

pub fn (mut server Server) from_json(f json2.Any) {
	obj := f.as_map()

	if 'url' !in obj {
		panic('Failed Server decoding: "url" not specified !')
	}

	for k, v in obj {
		match k {
			'url' {
				server.url = v.str()
			}
			'description' {
				server.description = v.str()
			}
			'variables' {
				server.variables = json2.decode<map[string]ServerVariable>(v.json_str()) or {
					panic('Failed Server decoding: $err')
				}
			}
			else {}
		}
	}
}

// ---------------------------------------- //

struct ServerVariable {
mut:
	default_value string
	enum_values   string
	description   string
}

pub fn (mut object map[string]ServerVariable) from_json(f json2.Any) {
	from_json_map<ServerVariable>(mut object, f)
}

pub fn (mut server_variable ServerVariable) from_json(f json2.Any) {
	obj := f.as_map()

	if 'default' !in obj {
		panic('Failed ServerVariable decoding: "default" not specified !')
	}

	for k, v in obj {
		match k {
			'default' { server_variable.default_value = v.str() }
			'enum' { server_variable.enum_values = v.str() }
			'description' { server_variable.description = v.str() }
			else {}
		}
	}
}
