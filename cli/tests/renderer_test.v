import cli

fn render(data string) string {
	operations := ['frere', 'soeur']
	return $tmpl('../templates/cli.tmpl')
}

fn test_render_hello_world() {
	assert render('World') == 'Hello World\n'
}
