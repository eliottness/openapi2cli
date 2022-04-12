module cli_builder

import cli { Command }
import encoding.base64
import net.http
import os
import regex
import term

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

fn get_fetch_config(method string, url string, data string, header http.Header, redirect bool) http.FetchConfig {
	return http.FetchConfig{
		method: http.method_from_str(method)
		url: url
		data: data
		header: header
		allow_redirect: redirect
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
	mut output := ''
	mut location := false
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
					header.add_custom(tmp[0].to_lower(), tmp[1]) ?
				}
			}
			'auth' {
				auth := flag.get_string() ?
				header.add_custom('authorization', 'Basic ' + base64.encode_str(auth)) ?
			}
			'output' {
				output = flag.get_string() ?
				if os.exists(output) {
					println('Error: Output file already exists.')
					return
				}
			}
			'location' {
				location = flag.get_bool() ?
			}
			else {
				url = url.replace('{' + flag.name + '}', flag.get_string() ?)
			}
		}
	}

	if content_types.len == 1 {
		header.add_custom('content_type', content_types.first()) ?
	}

	if content_types.len > 1 {
		values := header.custom_values('content-type', http.HeaderQueryConfig{true})
		if values.len != 1 || values[0] !in content_types {
			println('You must specify the content-type header once with one of these values: $content_types')
			return
		}
		header.add_custom('content_type', values[0]) ?
	}

	config := get_fetch_config(method, url, data, header, location)
	response := http.fetch(config) ?
	status_code := response.status().int()

	if 300 <= status_code && status_code < 400 {
		eprintln(term.warn_message('Warning: You received a redirection status_code, to enable redirection add the -l flag.'))
	}

	if output != '' {
		os.write_file(output, response.text) ?
	} else {
		println(response.text)
	}
}
