module main

import os
import json
import yaml

fn build(path string, debug bool) ?string {
	println(path)
	content := os.read_file(path) ?
	raw_json := yaml.yaml_to_json(content, replace_tags: true, debug: int(debug)) ?
	json_data := json.decode(OpenApi, raw_json) ?

	return path
}
