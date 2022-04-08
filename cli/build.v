module cli

import os
import open_api
import yaml

fn render(operation_list []open_api.Operation, info_title string, info_description string) string {
	operations := operation_list.clone()
	title := info_title
	name := info_title
	description := info_description
	return $tmpl('./templates/test_renderer.tmpl')
}

pub fn build(path string, debug bool) ?string {
	mut content := os.read_file(path) ?
	content = escape_escaped_char(content) ?
	raw_json := yaml.yaml_to_json(content, replace_tags: true, debug: int(debug)) ?
	open_api := open_api.decode<open_api.OpenApi>(raw_json) ?
	program := render([open_api.paths['/batch'].get], open_api.info.title, open_api.info.description)

	os.write_file('./templated.v', program) ?

	return './templated.v'
}
