import cli_builder
import open_api
import yaml
import os
import regex

fn render(str string) string {
	name := str
	return $tmpl('../templates/test_renderer.tmpl')
}

fn test_render_hello_world() ? {
	assert render('World') == 'Hello World\n'
}
