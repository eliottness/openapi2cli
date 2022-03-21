module open_api

import x.json2 { Any, decode, raw_decode }
import json

struct Reference {
mut:
	ref string [json: '\$ref'; required]
}

pub fn (mut reference Reference) from_json(json Any) {
}

// ---------------------------------------- //

type ObjectRef<T> = Reference | T

pub fn from_json<T>(json Any) ObjectRef<T> {
	if tmp := decode<Reference>(json.json_str()) {
		return tmp
	}
	return decode<T>(json.json_str()) or { panic('') }
}

// ---------------------------------------- //

pub fn (mut object []ObjectRef<Parameter>) from_json(json Any) {
	for value in json.arr() {
		str := raw_decode(value.json_str()) or { panic('') }
		object << from_json<Parameter>(str)
	}
}
