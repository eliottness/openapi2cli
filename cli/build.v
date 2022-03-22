module cli

import os
import yaml
import open_api

pub fn build(path string, debug bool) ?string {
	content := os.read_file(path) ?
	raw_json := yaml.yaml_to_json(content, replace_tags: true, debug: int(debug)) ?
	json_data := open_api.decode<open_api.OpenApi>(raw_json) ?
	return json_data.str()
}
