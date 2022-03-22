module open_api

import x.json2 { Any, decode }
import json

struct Info {
pub mut:
	title            string
	version          string
	terms_of_service string
	description      string
	contact          Contact
	license          License
}

pub fn (mut info Info) from_json(json Any) {
	object := json.as_map()
	check_required<Info>(object, 'title', 'version')

	for key, value in object {
		match key {
			'title' {
				info.title = value.str()
			}
			'version' {
				info.version = value.str()
			}
			'termsOfService' {
				info.terms_of_service = value.str()
			}
			'description' {
				info.description = value.str()
			}
			'contact' {
				info.contact = decode<Contact>(value.json_str()) or {
					panic('Failed Info decoding: $err')
				}
			}
			'license' {
				info.license = decode<License>(value.json_str()) or {
					panic('Failed Info decoding: $err')
				}
			}
			else {}
		}
	}
}

// ---------------------------------------- //

struct Contact {
pub mut:
	name  string
	url   string
	email string
}

pub fn (mut contact Contact) from_json(json Any) {
	object := json.as_map()
	for key, value in object {
		match key {
			'name' { contact.name = value.str() }
			'url' { contact.url = value.str() }
			'email' { contact.email = value.str() }
			else {}
		}
	}
}

// ---------------------------------------- //

struct License {
pub mut:
	name string
	url  string
}

pub fn (mut license License) from_json(json Any) {
	object := json.as_map()

	if 'name' !in object {
		panic('Failed Info decoding: "name" not specified !')
	}

	for key, value in object {
		match key {
			'name' { license.name = value.str() }
			'url' { license.url = value.str() }
			else {}
		}
	}
}
