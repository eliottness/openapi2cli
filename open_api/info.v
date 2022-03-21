module open_api

import x.json2 { Any, decode }

struct Info {
mut:
	title            string
	version          string
	terms_of_service string
	description      string
	contact          Contact
	license          License
}

pub fn (mut info Info) from_json(f Any) {
	obj := f.as_map()

	required_fields := ['title', 'version']
	for field in required_fields {
		if field !in obj {
			panic('Failed Info decoding: "$field" not specified !')
		}
	}

	for k, v in obj {
		match k {
			'title' {
				info.title = v.str()
			}
			'version' {
				info.version = v.str()
			}
			'termsOfService' {
				info.terms_of_service = v.str()
			}
			'description' {
				info.description = v.str()
			}
			'contact' {
				info.contact = decode<Contact>(v.json_str()) or {
					panic('Failed Info decoding: $err')
				}
			}
			'license' {
				info.license = decode<License>(v.json_str()) or {
					panic('Failed Info decoding: $err')
				}
			}
			else {}
		}
	}
}

// ---------------------------------------- //

struct Contact {
mut:
	name  string
	url   string
	email string
}

pub fn (mut contact Contact) from_json(f Any) {
	obj := f.as_map()
	for k, v in obj {
		match k {
			'name' { contact.name = v.str() }
			'url' { contact.url = v.str() }
			'email' { contact.email = v.str() }
			else {}
		}
	}
}

// ---------------------------------------- //

struct License {
mut:
	name string
	url  string
}

pub fn (mut license License) from_json(f Any) {
	obj := f.as_map()

	if 'name' !in obj {
		panic('Failed Info decoding: "name" not specified !')
	}

	for k, v in obj {
		match k {
			'name' { license.name = v.str() }
			'url' { license.url = v.str() }
			else {}
		}
	}
}