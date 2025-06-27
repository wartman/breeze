package breeze.core;

using StringTools;

function sanitizeClassName(name:String) {
	return name.toLowerCase().replace('.', '_').replace(',', '_').replace(' ', '_');
}

function sanitizeCssClassName(name:String) {
	name = name.toLowerCase();
	for (char in [':', '#', '+', '/', '*', '.', '[', ']', '(', ')', '%']) {
		name = name.replace(char, '\\$char');
	}
	return name;
}

function normalizeCss(value:String) {
	return value.replace('\r\n', '\n').split('\n').map(part -> part.trim()).join(' ').trim();
}
