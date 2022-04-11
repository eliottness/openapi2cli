module cli_builder

import cli
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

pub fn execute_command(method string, path string, content_types []string, cmd cli.Command) ? {
	flags := cmd.flags.get_all_found()
	flags_name := flags.map(fn (elt cli.Flag) string {
		return elt.name
	})

	if 'body' in flags_name && 'body_stdin' in flags_name {
		println("Error: You cant use 'body' and 'body_stdin' simultaneously")
		return
	}

	if method in ['PUT', 'POST', 'PATCH'] && 'body' !in flags_name && 'body_stdin' !in flags_name {
		println('Error: Specifying a body is mandatory for this operation.')
		return
	}

	mut data := ''
	mut url := path
	for flag in flags {
		if flag.flag == cli.FlagType.string {
			if flag.name != 'body' {
				url = url.replace('{' + flag.name + '}', flag.get_string() ?)
			} else {
				data = flag.get_string() ?
			}
		}
	}

	if 'body_stdin' in flags_name {
		data = os.input('Enter request body:\n')
	} else if os.is_file(data) {
		data = os.read_file(data) ?
	}

	mut config := get_fetch_config(method, url, data)

	if method in ['POST', 'PUT', 'PATCH'] {
		config.header.add(http.CommonHeader.content_type, 'text/plain')
	}

	response := http.fetch(config) ?
	println(response.text)
}
