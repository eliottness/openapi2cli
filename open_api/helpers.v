module open_api

import x.json2 { Any, decode, raw_decode }

pub fn decode_array<T>(src string) ?[]T {
	res := raw_decode(src) ?
	mut typ := []T{}

	for k in res.arr() {
		typ << decode<T>(k.json_str()) or { panic('Failed $T.name decoding: $err') }
	}
	return typ
}

pub fn decode_map<T>(src string) ?map[string]T {
	res := raw_decode(src) ?
	mut typ := map[string]T{}

	for k, v in res.as_map() {
		typ[k] = decode<T>(v.json_str()) or { panic('Failed $T.name decoding: $err') }
	}
	return typ
}

pub fn check_required<T>(object map[string]Any, required_fields []string) {
	for field in required_fields {
		if field !in object {
			panic('Failed $T.name decoding: "$field" not specified !')
		}
	}
}