module open_api

struct OpenApi {
    openapi       string                [required]
    info          Info                  [required]
    paths         Paths                 [required]
    external_docs ExternalDocumentation [json: 'externalDocs']
    servers       []Server
    components    Components
    security      []SecurityRequirement
    tags          []Tag
}

// ---------------------------------------- //

struct Info {
    title            string [required]
    version          string [required]
    terms_of_service string [json: 'termsOfService']
    description      string
    contact          Contact
    license          License
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
    external_docs ExternalDocumentation             [json: 'externalDocs']
    operation_id  string                            [json: 'operationId']
    request_body  RequestBody | Reference           [json: 'requestBody']
    tags          []string
    summary       string
    description   string
    parameters    []Parameter | Reference
    responses     Responses
    callbacks     []map[string]Callback | Reference
    deprecated    bool
    security      []SecurityRequirement
    servers       []Server
}

// ---------------------------------------- //

struct Components {
    security_schemes []map[string]SecurityScheme | Reference [json: 'SecuritySchemes']
    request_bodies   []map[string]RequestBody | Reference    [json: 'requestBodies']
    schemas          []map[string]Schema | Reference
    responses        []map[string]Response | Reference
    parameters       []map[string]Parameter | Reference
    examples         []map[string]Example | Reference
    headers          []map[string]Header | Reference
    links            []map[string]Link | Reference
    callbacks        []map[string]Callback | Reference
}

// ---------------------------------------- //

struct SecurityRequirement {
    requirements map[string][]string // Todo: make it match the '{name}' type
}

struct SecurityScheme {
    security_type       string     [required; json: 'type']
    location            string     [required; json: 'in']
    open_id_connect_url string     [required; json: 'openIdConnectUrl']
    name                string     [required]
    scheme              string     [required]
    flows               OAuthFlows [required]
    bearer_format       string     [json: 'bearerFormat']
    description         string
}

struct OAuthFlows {
    client_credentials OAuthFlow [json: 'clientCredentials']
    authorization_code OAuthFlow [json: 'authorizationCode']
    implicit           OAuthFlow
    password           OAuthFlow
}

struct OAuthFlow {
    authorization_url string              [required; json: 'authorizationUrl']
    token_url         string              [required; json: 'tokenUrl']
    scopes            []map[string]string [required]
    refresh_url       string              [json: 'refreshUrl']
}

// ---------------------------------------- //

struct Tag {
    name          string                [required]
    external_docs ExternalDocumentation [json: 'externalDocs']
    description   string
}

struct ExternalDocumentation {
    description string
    url         string [required]
}

// ---------------------------------------- //

struct Parameter { // Todo: To be completed
    location          string [required; json: 'in']
    name              string [required]
    required          bool   [required]
    allow_empty_value bool   [json: 'allowEmptyValue']
    description       string
    deprecated        bool
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
    external_value string [json: 'externalValue']
    summary        string
    description    string
    value          string // Todo: Find a way to use 'any' type here
}

struct Encoding {
    content_type   string                          [json: 'contentType']
    allow_reserved bool                            [json: 'allowReserved']
    headers        []map[string]Header | Reference
    style          string
    explode        bool
}

struct Header {
    required          bool   [required]
    allow_empty_value bool   [json: 'allowEmptyValue']
    description       string
    deprecated        bool
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
    request_body  string              [json: 'requestBody'] // Todo: Find a way to use 'any' type here
    parameters    []map[string]string // Todo: Find a way to use 'any' type here
    description   string
    server        Server
}

struct Server {
    url         string [required]
    description string
    variables   []map[string]ServerVariable
}

struct ServerVariable {
    default_value string [required; json: 'default']
    enum_values   string [json: 'enum']
    description   string
}
