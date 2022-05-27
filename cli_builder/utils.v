module cli_builder

import regex

fn escape_escaped_char(str string) ?string {
	mut tmp := str.clone()
	mut checked := []string{}

	mut reg := regex.regex_opt(r'\\[a-zA-Z]')?
	for chr in reg.find_all_str(str) {
		if chr in checked {
			continue
		}
		tmp = tmp.replace(chr, '\\$chr')
		checked << chr
	}

	return tmp
}
