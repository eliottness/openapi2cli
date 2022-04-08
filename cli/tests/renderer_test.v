import cli
import open_api
import yaml
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

fn render(operation_list []open_api.Operation) string {
	operations := operation_list.clone()
	title := 'title'
	description := 'description'
	return $tmpl('../templates/cli.tmpl')
}

fn test_render_hello_world() ? {
	mut content := os.read_file(@VMODROOT + '/open_api/testdata/open_api_complex.yaml') ?
	content = escape_escaped_char(content) ?
	raw_json := yaml.yaml_to_json(content, replace_tags: true) ?
	open_api := open_api.decode<open_api.OpenApi>(raw_json) ?
	assert render([open_api.paths['/batch'].get]) == 'Hello World\n'
}
