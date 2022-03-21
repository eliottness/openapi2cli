module open_api

import x.json2 { Any }

struct Callback {
mut:
	callback map[string]PathItem // Todo: make it match the '{expression}' type
}

pub fn (mut callback Callback) from_json(json Any) {
}
