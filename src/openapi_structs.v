module main

struct OpenApi {
	openapi       string [required]
	info 	      Info [required]
	servers       []Server
	paths         Paths [required]
	components    Components
	security      []SecurityRequirement
	tags 	      []Tag
	external_docs ExternalDocumentation
}

// ---------------------------------------- //

struct Info {
	title 			 string [required]
	version 		 string [required]
	description 	 string
	terms_of_service string
	contact 		 Contact
	license 		 License
}

struct Contact {
	name  string
	url   string
	email string
}

struct License {
	name string [required]
	url  string
}

// ---------------------------------------- //

struct Paths {
	paths []map[string]PathItem
}

struct PathItem {
	ref 		string
	summary 	string
	description string
	get 		Operation
	put 		Operation
	post 		Operation
	delete 		Operation
	options 	Operation
	head 		Operation
	patch 		Operation
	trace 		Operation
	servers 	[]Server
	parameters 	[]Parameter | Reference
}

struct Callback {
	callback []map[string]PathItem
}

// ---------------------------------------- //

struct Operation {
	tags          []string
	summary 	  string
	description   string
	external_docs ExternalDocumentation
	operation_id  string
	parameters    []Parameter | Reference
	request_body  RequestBody | Reference
	responses 	  Responses
	callbacks     []map[string]Callback | Reference
	deprecated    bool
	security      []SecurityRequirement
	servers       []Server
}

// ---------------------------------------- //

struct Components {
	schemas          []map[string]Schema | Reference
	responses        []map[string]Response | Reference
	parameters       []map[string]Parameter | Reference
	examples         []map[string]Example | Reference
	request_bodies   []map[string]RequestBody | Reference
	headers 	     []map[string]Header | Reference
	security_schemes []map[string]SecurityScheme | Reference
	links 			 []map[string]Link | Reference
	callbacks 		 []map[string]Callback | Reference
}

// ---------------------------------------- //

struct SecurityRequirement {
	requirements map[string][]string
}

struct SecurityScheme {
	security_type       string [required]
	description         string
	name 		        string [required]
	location 	        string [required]
	scheme 		        string [required]
	bearer_format       string
	flows 		        OAuthFlows [required]
	open_id_connect_url string [required]
}

struct OAuthFlows {
	implicit 		   OAuthFlow
	password 		   OAuthFlow
	client_credentials OAuthFlow
	authorization_code OAuthFlow
}

struct OAuthFlow {
	authorization_url string [required]
	token_url 		  string [required]
	refresh_url 	  string
	scopes 			  []map[string]string [required]
}

// ---------------------------------------- //

struct Tag {
	name  		  string [required]
	description   string
	external_docs ExternalDocumentation
}

struct ExternalDocumentation {
	description string
	url 		string [required]
}

// ---------------------------------------- //

struct Parameter {
	name 			  string [required]
	location 		  string [required]
	description 	  string
	required 		  bool [required]
	deprecated 		  bool
	allow_empty_value bool
}

// ---------------------------------------- //

struct RequestBody {
	description string
	content 	[]map[string]MediaType [required]
	required 	bool
}

struct MediaType {
	schema   Schema | Reference
	example  string // Todo: Find a way to use 'any' type here
	examples []map[string]Example | Reference
	encoding []map[string]Encoding
}

struct Schema {
	// Todo: flemme
}

struct Reference {
	ref string [required]
}

struct Example {
	summary 	   string
	description    string
	value 		   string // Todo: Find a way to use 'any' type here
	external_value string
}

struct Encoding {
	content_type   string
	headers 	   []map[string]Header | Reference
	style 		   string
	explode 	   bool
	allow_reserved bool
}

struct Header {
	description 	  string
	required 		  bool [required]
	deprecated  	  bool
	allow_empty_value bool
}

// ---------------------------------------- //

struct Responses {
	default_code 	 Response | Reference
	http_status_code Response | Reference
}

struct Response {
	description string [required]
	headers 	[]map[string]Header | Reference
	content 	[]map[string]MediaType
	links 		[]map[string]Link | Reference
}

// ---------------------------------------- //

struct Link {
	operation_ref string
	operation_id  string
	parameters    []map[string]string // Todo: Find a way to use 'any' type here
	request_body  string // Todo: Find a way to use 'any' type here
	description   string
	server 		  Server
}

struct Server {
	url 		string [required]
	description string
	variables   []map[string]ServerVariable
}

struct ServerVariable {
	enum_values   string
	default_value string [required]
	description   string
}
