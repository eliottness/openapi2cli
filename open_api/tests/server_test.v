import open_api
import os

fn test_server_struct() ? {
	content := os.read_file(@VMODROOT + '/open_api/testdata/server.json') ?
	server := open_api.decode<open_api.Server>(content) ?

	assert server.url == 'https://{username}.gigantic-server.com:{port}/{basePath}'
	assert server.description == 'The production API server'

	assert server.variables.len == 3
	assert server.variables['username'].default_value == 'demo'
	assert server.variables['username'].description == 'this value is assigned by the service provider, in this example `gigantic-server.com`'
	assert server.variables['port'].enum_values == ['8443', '443']
	assert server.variables['basePath'].default_value == 'v2'
}
