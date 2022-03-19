module cli

import os
import x.json2
import yaml
import open_api

pub fn build(path string, debug bool) ?string {
	content := os.read_file(path) ?
	raw_json := yaml.yaml_to_json(content, replace_tags: true, debug: int(debug)) ?
	json_data := json2.decode<open_api.OpenApi>(raw_json) ?
	return json_data.str()
}
