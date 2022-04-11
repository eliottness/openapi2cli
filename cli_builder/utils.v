module cli_builder

import cli { Command }
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

fn get_fetch_config(method string, url string, data string) http.FetchConfig {
	return http.FetchConfig{
		method: http.method_from_str(method)
		url: url
		data: data
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
	mut headers := []string{}

	for flag in cmd.flags.get_all_found() {
		match flag.name {
			'body' {
				data = flag.get_string() ?
			}
			'header' {
				headers = flag.get_strings() ?
			}
			else {
				url = url.replace('{' + flag.name + '}', flag.get_string() ?)
			}
		}
	}

	if data == '-' {
		data = get_stdin_input() ?
	} else if os.is_file(data) {
		data = os.read_file(data) ?
	}

	mut config := get_fetch_config(method, url, data)

	if method in ['POST', 'PUT', 'PATCH'] {
		config.header.add(http.CommonHeader.content_type, 'text/plain')
	}

	for header in headers {
		elements := header.split(':')
		if elements.len < 2 {
			println('Error: Wrong header format')
			return
		}
		config.header.add_custom(elements[0], elements[1]) ?
	}

	response := http.fetch(config) ?
	println(response.text)
}
