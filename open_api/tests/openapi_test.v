import open_api
import yaml
import os
import regex

fn test_basic_open_api_struct() ? {
	content := os.read_file(@VMODROOT + '/open_api/testdata/open_api_basic.json') ?
	open_api := open_api.decode<open_api.OpenApi>(content) ?
	assert open_api.openapi == '3'
	assert open_api.info.title == 'Sample Pet Store App'
	assert open_api.info.version == '1.0.1'

	assert open_api.paths.len == 1
	assert '/home' in open_api.paths
	assert open_api.paths['/home'].description == 'homepage'

	assert open_api.tags.len == 2
	assert open_api.tags[0].name == 'cat'
	assert open_api.tags[1].name == 'dog'

	assert open_api.servers.len == 1
	assert open_api.servers[0].url == 'https://random.fr'
	assert open_api.servers[0].variables.len == 1
	assert open_api.servers[0].variables['var1'].default_value == 'default'
}

fn test_open_api_struct_without_paths() ? {
	content := '{ "openapi": "3", "info": {"title": "oui", "version": "1"} }'
	info := open_api.decode<open_api.OpenApi>(content) or { return }
	assert false
}

fn test_open_api_struct_without_info() ? {
	content := '{ "openapi": "3", "paths": {} }'
	info := open_api.decode<open_api.OpenApi>(content) or { return }
	assert false
}

fn test_open_api_struct_without_openapi() ? {
	content := '{ "info": {"title": "oui", "version": "1"}, "paths": {} }'
	info := open_api.decode<open_api.OpenApi>(content) or { return }
	assert false
}

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

fn test_full_open_api_struct() ? {
	mut content := os.read_file(@VMODROOT + '/open_api/testdata/open_api_complex.yaml') ?
	content = escape_escaped_char(content) ?
	json := yaml.yaml_to_json(content, replace_tags: true) ?
	open_api := open_api.decode<open_api.OpenApi>(json) ?
}
