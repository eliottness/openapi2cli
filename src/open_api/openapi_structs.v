module open_api

struct OpenApi {
    openapi       string                [required]
    info          Info                  [required]
    servers       []Server
    paths         Paths                 [required]
    components    Components
    security      []SecurityRequirement
    tags          []Tag
    external_docs ExternalDocumentation [json: 'externalDocs']
}

// ---------------------------------------- //

struct Info {
    title            string [required]
    description      string
    terms_of_service string [json: 'termsOfService']
    contact          Contact
    license          License
    version          string [required]
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
    paths []map[string]PathItem // Todo: find a way for url format matching
}

struct PathItem {
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

struct Callback {
    callback []map[string]PathItem // Todo: make it match the '{expression}' type
}

// ---------------------------------------- //

struct Operation {
    tags          []string
    summary       string
    description   string
    external_docs ExternalDocumentation             [json: 'externalDocs']
    operation_id  string                            [json: 'operationId']
    parameters    []Parameter | Reference
    request_body  RequestBody | Reference           [json: 'requestBody']
    responses     Responses
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
    request_bodies   []map[string]RequestBody | Reference    [json: 'requestBodies']
    headers          []map[string]Header | Reference
    security_schemes []map[string]SecurityScheme | Reference [json: 'SecuritySchemes']
    links            []map[string]Link | Reference
    callbacks        []map[string]Callback | Reference
}

// ---------------------------------------- //

struct SecurityRequirement {
    requirements map[string][]string // Todo: make it match the '{name}' type
}

struct SecurityScheme {
    security_type       string     [required; json: 'type']
    description         string
    name                string     [required]
    location            string     [required; json: 'in']
    scheme              string     [required]
    bearer_format       string     [json: 'bearerFormat']
    flows               OAuthFlows [required]
    open_id_connect_url string     [required; json: 'openIdConnectUrl']
}

struct OAuthFlows {
    implicit           OAuthFlow
    password           OAuthFlow
    client_credentials OAuthFlow [json: 'clientCredentials']
    authorization_code OAuthFlow [json: 'authorizationCode']
}

struct OAuthFlow {
    authorization_url string              [required; json: 'authorizationUrl']
    token_url         string              [required; json: 'tokenUrl']
    refresh_url       string              [json: 'refreshUrl']
    scopes            []map[string]string [required]
}

// ---------------------------------------- //

struct Tag {
    name          string                [required]
    description   string
    external_docs ExternalDocumentation [json: 'externalDocs']
}

struct ExternalDocumentation {
    description string
    url         string [required]
}

// ---------------------------------------- //

struct Parameter { // Todo: To be completed
    name              string [required]
    location          string [required; json: 'in']
    description       string
    required          bool   [required]
    deprecated        bool
    allow_empty_value bool   [json: 'allowEmptyValue']
}

// ---------------------------------------- //

struct RequestBody {
    description string
    content     []map[string]MediaType [required]
    required    bool
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
    ref string [required; json: '\$ref']
}

struct Example {
    summary        string
    description    string
    value          string // Todo: Find a way to use 'any' type here
    external_value string [json: 'externalValue']
}

struct Encoding {
    content_type   string                          [json: 'contentType']
    headers        []map[string]Header | Reference
    style          string
    explode        bool
    allow_reserved bool                            [json: 'allowReserved']
}

struct Header {
    description       string
    required          bool [required]
    deprecated        bool
    allow_empty_value bool [json: 'allowEmptyValue']
}

// ---------------------------------------- //

struct Responses {
    default_code     Response | Reference [json: 'default']
    http_status_code Response | Reference // Todo: find a way to do integer matching
}

struct Response {
    description string [required]
    headers     []map[string]Header | Reference
    content     []map[string]MediaType
    links       []map[string]Link | Reference
}

// ---------------------------------------- //

struct Link {
    operation_ref string              [json: 'operationRef']
    operation_id  string              [json: 'operationId']
    parameters    []map[string]string // Todo: Find a way to use 'any' type here
    request_body  string              [json: 'requestBody'] // Todo: Find a way to use 'any' type here
    description   string
    server        Server
}

struct Server {
    url         string [required]
    description string
    variables   []map[string]ServerVariable
}

struct ServerVariable {
    enum_values   string [json: 'enum']
    default_value string [required; json: 'default']
    description   string
}
