module open_api

import x.json2 { Any, decode, raw_decode }

struct Callback {
mut:
	callback map[string]PathItem // Todo: make it match the '{expression}' type
}

pub fn (mut callback Callback) from_json(f Any) {
}