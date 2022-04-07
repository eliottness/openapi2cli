module cli

import os
import open_api
import yaml

pub fn build(path string, debug bool) ?string {
	mut content := os.read_file(path) ?
	content = escape_escaped_char(content) ?
	raw_json := yaml.yaml_to_json(content, replace_tags: true, debug: int(debug)) ?
	json_data := open_api.decode<open_api.OpenApi>(raw_json) ?
	return json_data.str()
}
