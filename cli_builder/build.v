module cli_builder

import os
import open_api
import yaml

fn render(open_api open_api.OpenApi) string {
	operations := [open_api.paths['/batch'].get]
	title := open_api.info.title
	description := open_api.info.description
	return $tmpl('templates/cli.tmpl')
}

pub fn build(path string, debug bool) ?string {
	mut content := os.read_file(path) ?
	content = escape_escaped_char(content) ?
	raw_json := yaml.yaml_to_json(content, replace_tags: true, debug: int(debug)) ?
	open_api := open_api.decode<open_api.OpenApi>(raw_json) ?

	file_path := @VMODROOT + '/templated.v'
	program := render(open_api)
	os.write_file(file_path, program) ?
	return file_path
}
