module cli_builder

fn render(str string) string {
	name := str
	return $tmpl('../templates/test_renderer.tmpl')
}

fn test_render_hello_world() ? {
	assert render('World') == 'Hello World\n'
}
