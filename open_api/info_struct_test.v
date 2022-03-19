module open_api

import x.json2
import os

fn test_basic_info_struct() ? {
	content := '{ "title": "random", "version": "1.0.1" }'
	info_obj := json2.decode<Info>(content) ?
	assert info_obj.title == 'random'
	assert info_obj.version == '1.0.1'
}

fn test_info_struct_without_required() ? {
	// Todo: We need to wait the implementation of the recover keyword
}

fn test_full_info_struct() ? {
	content := os.read_file('./open_api/testdata/info.json') ?
	info_obj := json2.decode<Info>(content) ?
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