module open_api

import x.json2 { Any, decode, raw_decode }

struct Tag {
mut:
	name          string
	external_docs ExternalDocumentation
	description   string
}

pub fn (mut tag Tag) from_json(f Any) {
	obj := f.as_map()

	check_required<Tag>(obj, 'name')

	for k, v in obj {
		match k {
			'name' {
				tag.name = v.str()
			}
			'externalDocs' {
				tag.external_docs = decode<ExternalDocumentation>(v.json_str()) or {
					panic('Failed Tag decoding: $err')
				}
			}
			'description' {
				tag.description = v.str()
			}
			else {}
		}
	}
}