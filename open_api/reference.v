module open_api

import x.json2 { raw_decode, Any, decode }

struct Reference {
mut:
	ref string [json: '\$ref'; required]
}

pub fn (mut reference Reference) from_json(f Any) {
}

// ---------------------------------------- //

type ObjectRef<T> = Reference | T

pub fn from_json<T>(f Any) ObjectRef<T> {
	if tmp := decode<Reference>(f.json_str()) {
		return tmp
	}
	return decode<T>(f.json_str()) or { panic('') }
}

// ---------------------------------------- //

pub fn (mut object []ObjectRef<Parameter>) from_json(f Any) {
	obj := f.arr()

	for k in obj {
		str := raw_decode(k.json_str()) or { panic('') }
		object << from_json<Parameter>(str)
	}
}

