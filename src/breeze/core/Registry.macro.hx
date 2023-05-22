package breeze.core;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ModuleType;
import sys.io.File;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using haxe.io.Path;
using haxe.macro.Tools;

final CssMeta = ':bz.css';

typedef CssEntry = {
	public var wrapper:Null<String>;
	public var selector:String;
	public var modifiers:Array<String>;
	public var css:String;
}

function registerCss(css:CssEntry, pos:Position) {
	var parsed = '.${css.selector.sanitizeCssClassName()}';
	if (css.modifiers.length > 0) parsed += css.modifiers.join('');
	parsed += css.css;

	if (css.wrapper != null) {
		parsed = css.wrapper + '{$parsed}';
	}

	export(css.selector, parsed, pos);
}

function registerRawCss(id:String, css:String, ?pos:Position) {
	var pos = pos ?? Context.currentPos();
	export(id, css, pos);
}

private function export(id:String, css:String, pos:Position) {
	var cls = Context.getLocalClass().get();
	switch Config.instance().export {
		case Runtime:
			cls.meta.add(CssMeta, [macro $v{id}, macro $v{css}], pos);
			Context.error('Runtime is not available yet', pos);
		case None:
		case File(path):
			cls.meta.add(CssMeta, [macro $v{id}, macro $v{css}], pos);
			exportFile(path);
	}
}

var initialized:Bool = false;
var output:Map<String, String> = [];

private function extract(exprs:Array<Expr>) {
	switch exprs {
		case [name, css]:
			var name = name.extractString();
			var css = css.extractString();
			output.set(name, css);
		default:
			Context.error('Invalid css data', Context.currentPos());
	}
}

private function extractAllCssFromTypes(types:Array<ModuleType>) {
	output.clear();

	for (type in types) switch type {
		case TClassDecl(t):
			var cls = t.get();
			if (cls.meta.has(CssMeta)) {
				var meta = cls.meta.extract(CssMeta);
				for (item in meta) extract(item.params);
			}
		default:
	}
}

private function exportFile(path:Null<String>) {
	if (initialized) return;
	initialized = true;

	if (Context.defined('display')) return;

	Context.onAfterTyping(types -> {
		extractAllCssFromTypes(types);

		var data = [for (_ => css in output) css];
		var path = getExportFilename(path);

		if (Config.instance().includePreflight) {
			data.unshift(Config.instance().preflight);
		}

		File.saveContent(path, data.join(#if debug '\n' #else '' #end));
	});
}

private function getExportFilename(path:Null<String>) {
	return switch path {
		case null:
			Path.join([sys.FileSystem.absolutePath(Compiler.getOutput().directory()), 'styles']).withExtension('css');
		case abs = _.charAt(0) => '.' | '/':
			abs.withExtension('css');
		case relative:
			Path.join([sys.FileSystem.absolutePath(Compiler.getOutput().directory()), relative]).withExtension('css');
	}
}
