import open_api
import x.json2
import os

fn test_callback_struct() ? {
	content := os.read_file(@VMODROOT + '/open_api/testdata/callback.json') ?
	components := json2.decode<open_api.Components>(content) ?
	callback := components.callbacks['test1'] as open_api.Callback

	assert callback.len == 2
	assert callback['some_url'].summary == 'summary1'
	assert callback['other_url'].summary == 'summary2'
}
