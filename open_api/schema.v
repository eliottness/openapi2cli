module open_api

import x.json2 { Any }
import json

struct Schema {
	title             string
	multiple_of       f64
	maximum           f64
	exclusive_minimum bool
	max_length        u64
	min_length        u64
	pattern           string
	max_items         u64
	min_items         u64
	unique_items      bool
	max_properties    u64
	min_properties    u64
	required          []string
	enum_values       []Any

	type_schema           string
	all_of                ObjectRef<Schema>
	one_of                ObjectRef<Schema>
	any_of                ObjectRef<Schema>
	not                   ObjectRef<Schema>
	items                 ObjectRef<Schema>
	properties            map[string]ObjectRef<Schema>
	additional_properties ObjectRef<Schema>
	description           string
	format                string
	default_value         Any

	nullable      bool
	discriminator Discriminator
	read_only     bool
	write_only    bool
	xml           XML
	external_docs ExternalDocumentation
	example       Any
	deprecated    bool
}

pub fn (mut schema Schema) from_json(json Any) ? {
}

// ---------------------------------------- //

struct Discriminator {
}

pub fn (mut discriminator Discriminator) from_json(json Any) ? {
}

// ---------------------------------------- //

struct XML {
}

pub fn (mut xml XML) from_json(json Any) ? {
}
