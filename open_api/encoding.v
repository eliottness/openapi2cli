module open_api

import x.json2 { Any }

struct Encoding {
mut:
	content_type   string                        [json: 'contentType']
	allow_reserved bool                          [json: 'allowReserved']
	headers        map[string]Header | Reference
	style          string
	explode        bool
}

pub fn (mut encoding Encoding) from_json(json Any) {
}
