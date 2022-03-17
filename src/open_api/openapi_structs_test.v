module open_api

import json
import os

fn test_full_info_struct() ? {
	content := os.read_file('./src/open_api/testdata/info_object_full.json') ?
	info_obj := json.decode(Info, content) ?
	assert info_obj.title == 'Sample Pet Store App'
	assert info_obj.version == '1.0.1'
	assert info_obj.description == 'This is a sample server for a pet store.'
	assert info_obj.terms_of_service == 'http://example.com/terms/'
	assert info_obj.contact.name == 'API Support'
	assert info_obj.contact.url == 'http://www.example.com/support'
	assert info_obj.contact.email == 'support@example.com'
	assert info_obj.license.name == 'Apache 2.0'
	assert info_obj.license.url == 'https://www.apache.org/licenses/LICENSE-2.0.html'
}

//fn test_basic_info_struct() ? {
//	content := os.read_file('./src/open_api/testdata/info_object_basic.json') ?
//	info_obj := json.decode(Info, content) ?
//	assert info_obj.title == 'Sample Pet Store App'
//	assert info_obj.version == '1.0.1'
//}