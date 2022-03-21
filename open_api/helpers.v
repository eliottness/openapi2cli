module open_api

import x.json2 { Any, decode, raw_decode }
import json

pub fn decode_array<T>(src string) ?[]T {
	json := raw_decode(src) ?
	mut typ := []T{}

	for value in json.arr() {
		typ << decode<T>(value.json_str()) or { panic('Failed $T.name decoding: $err') }
	}
	return typ
}

pub fn decode_map<T>(src string) ?map[string]T {
	json := raw_decode(src) ?
	mut typ := map[string]T{}

	for key, value in json.as_map() {
		typ[key] = decode<T>(value.json_str()) or { panic('Failed $T.name decoding: $err') }
	}
	return typ
}

pub fn decode_map_sumtype<T>(src string) ?map[string]ObjectRef<T> {
	json := raw_decode(src) ?
	mut typ := map[string]ObjectRef<T>{}

	for key, value in json.as_map() {
		typ[key] = from_json<T>(value.json_str())
	}
	return typ
}

pub fn check_required<T>(object map[string]Any, required_fields ...string) {
	for field in required_fields {
		if field !in object {
			panic('Failed $T.name decoding: "$field" not specified !')
		}
	}
}
