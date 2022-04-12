module cli_builder

import cli { Command }
import encoding.base64
import net.http
import os
import regex

fn escape_escaped_char(str string) ?string {
	mut tmp := str.clone()
	mut checked := []string{}

	mut reg := regex.regex_opt(r'\\[a-zA-Z]') ?
	for char in reg.find_all_str(str) {
		if char in checked {
			continue
		}
		tmp = tmp.replace(char, '\\$char')
		checked << char
	}

	return tmp
}

// ------------ Template utils ------------ //

fn get_fetch_config(method string, url string, data string, header http.Header) http.FetchConfig {
	return http.FetchConfig{
		method: http.method_from_str(method)
		url: url
		data: data
		header: header
	}
}

fn get_stdin_input() ?string {
	mut input := ''
	for {
		str := os.input_opt('') or { break }
		input += str
	}
	return input
}

pub fn execute_command(method string, path string, content_types []string, cmd Command) ? {
	mut url := path
	mut data := ''
	mut header := http.new_header(http.HeaderConfig{})

	for flag in cmd.flags.get_all_found() {
		match flag.name {
			'body' {
				data = flag.get_string() ?
				if data == '-' {
					data = get_stdin_input() ?
				} else if os.is_file(data) {
					data = os.read_file(data) ?
				}
			}
			'header' {
				for h in flag.get_strings() ? {
					tmp := h.split(':')
					if tmp.len < 2 {
						println('Error: Wrong header format.')
						return
					}
					header.add_custom(tmp[0], tmp[1]) ?
				}
			}
			'auth' {
				auth := flag.get_string() ?
				header.add_custom('Authorization', 'Basic ' + base64.encode_str(auth)) ?
			}
			else {
				url = url.replace('{' + flag.name + '}', flag.get_string() ?)
			}
		}
	}

	mut config := get_fetch_config(method, url, data, header)

	if method in ['POST', 'PUT', 'PATCH'] {
		config.header.add(http.CommonHeader.content_type, 'text/plain')
	}

	response := http.fetch(config) ?
	println(response.text)
}
