module open_api

import x.json2
import os

fn test_basic_open_api_struct() ? {
	content := os.read_file('./src/open_api/testdata/open_api_basic.json') ?
	open_api_obj := json2.decode<OpenApi>(content) ?
	assert open_api_obj.openapi == "3"
	assert open_api_obj.info.title == "Sample Pet Store App"
	assert open_api_obj.info.version == "1.0.1"
	
	assert open_api_obj.paths.len == 1
	assert "/home" in open_api_obj.paths
	assert open_api_obj.paths["/home"].description == "homepage"
	
	assert open_api_obj.tags.len == 2
	assert open_api_obj.tags[0].name == "cat"
	assert open_api_obj.tags[1].name == "dog"

	assert open_api_obj.servers.len == 1
	assert open_api_obj.servers[0].url == "https://random.fr"
	assert open_api_obj.servers[0].variables.len == 1
	assert open_api_obj.servers[0].variables['var1'].default_value == "default" 
}

fn test_open_api_struct_without_required() ? {
	// Todo: We need to wait the implementation of the recover keyword
}

fn test_full_open_api_struct() ? {
	// Todo at the end of the module creation
}
