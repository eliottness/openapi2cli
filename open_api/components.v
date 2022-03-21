module open_api

import x.json2 { Any, decode, raw_decode }


struct Components {
mut:
	security_schemes map[string]SecurityScheme | Reference [json: 'SecuritySchemes']
	request_bodies   map[string]RequestBody | Reference    [json: 'requestBodies']
	schemas          map[string]Schema | Reference
	responses        map[string]Response | Reference
	parameters       map[string]Reference | Parameter
	examples         map[string]Example | Reference
	headers          map[string]Header | Reference
	links            map[string]Link | Reference
	callbacks        map[string]Callback | Reference
}

pub fn (mut components Components) from_json(f Any) {
}