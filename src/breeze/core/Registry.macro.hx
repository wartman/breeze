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
			exportRuntime();
		case None:
		case File(path):
			cls.meta.add(CssMeta, [macro $v{id}, macro $v{css}], pos);
			exportFile(path);
	}
}

var initialized:Bool = false;

// @todo: Doing things this way will probably result in
// never removing dead class names. We need to think of a better
// solution.
//
// However, if it's not @:persistent the output is wrong too.
@:persistent var output:Map<String, String> = [];

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

private function exportRuntime() {
	if (initialized) return;
	initialized = true;

	Context.onAfterTyping(types -> {
		extractAllCssFromTypes(types);

		try {
			Context.getType('breeze.Styles');
			return;
		} catch (e) {}

		var exprs = [
			for (key => value in output) macro breeze.Runtime.instance().add($v{key}, $v{value})
		];

		Context.defineType({
			name: 'Styles',
			pack: ['breeze'],
			kind: TDClass(),
			meta: [{name: ':keep', pos: (macro null).pos}],
			pos: (macro null).pos,
			fields: (macro class {
				@:keep public static function __init__() {
					@:mergeBlock $b{exprs};
				}
			}).fields
		});
	});

	// Context.error('Runtime exporting is not implemented yet.', Context.currentPos());
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
