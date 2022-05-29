module cli_builder

import os
import openapi
import yaml

fn is_basic_http_required(open_api openapi.OpenApi) bool {
	security_schemes := open_api.components.get_basic_http_schemes()
	mut required := false
	for requirement in open_api.security {
		for key, _ in requirement {
			required = required || key in security_schemes
		}
	}
	return required
}

fn render(open_api openapi.OpenApi) string {
	required := is_basic_http_required(open_api)
	api := open_api
	url := open_api.servers[0]
	return $tmpl('templates/cli.tmpl')
}

pub fn build(path string, server string, debug bool) ?string {
	mut content := os.read_file(path)?

	if path.ends_with('.yaml') || path.ends_with('.yml') {
		content = escape_escaped_char(content)?
		content = yaml.yaml_to_json(content, replace_tags: true, debug: int(debug))?
	} else if !path.ends_with('json') {
		return error('Error: You must specify a valid json or yaml file')
	}

	mut open_api := openapi.decode<openapi.OpenApi>(content)?

	validate(mut open_api, server)?

	mut program := render(open_api)
	file_path := @VMODROOT + '/templated.v'
	os.write_file(file_path, program)?
	return file_path
}
