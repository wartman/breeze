package breeze.core;

using StringTools;

function sanitizeClassName(name:String) {
	return name.toLowerCase().replace('.', '_').replace(' ', '_');
}

function sanitizeCssClassName(name:String) {
	return name.toLowerCase().replace(':', '\\:');
}
