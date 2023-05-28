package breeze.core;

import haxe.ds.ReadOnlyArray;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.io.File;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using haxe.io.Path;
using haxe.macro.Tools;
using sys.FileSystem;

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
	if (css.wrapper != null) parsed = css.wrapper + '{$parsed}';
	return export(css.selector, parsed, pos);
}

function registerRawCss(id:String, css:String, ?pos:Position) {
	var pos = pos ?? Context.currentPos();
	return export(id, css, pos);
}

private var initialized:Bool = false;

private function export(id:String, css:String, pos:Position) {
	var cls = Context.getLocalClass().get();
	return switch Config.instance().export {
		case Runtime:
			// @todo: This is a bit ugly, but it works well enough for
			// development purposes.
			return macro breeze.Runtime.instance().rule($v{id}, $v{css});
		case None:
			macro breeze.ClassName.ofString($v{id});
		case File(path):
			// @todo: What's the benefit of us adding this to class meta?
			// Could we get the same effect with a simple Map?
			cls.meta.add(CssMeta, [macro $v{id}, macro $v{css}], pos);
			exportFile(path);
			macro breeze.ClassName.ofString($v{id});
	}
}

private function exportFile(path:Null<String>) {
	if (initialized) return;
	initialized = true;

	Context.onAfterTyping(types -> {
		var output = extractAllCssFromTypes(types);
		var data = [for (_ => css in output) css];
		var path = getExportFilename(path);

		if (Config.instance().includePreflight) {
			var preflight = [for (_ => part in Config.instance().preflight) part].join('\n');
			data.unshift(preflight);
		}

		ensureDir(path);
		File.saveContent(path, data.join(#if debug '\n' #else '' #end));
	});
}

private function extractAllCssFromTypes(types:ReadOnlyArray<ModuleType>) {
	var output:Map<String, String> = [];
	for (type in types) switch type {
		case TClassDecl(_.get() => cls) if (cls.meta.has(CssMeta)):
			var meta = cls.meta.extract(CssMeta);
			for (item in meta) switch item.params {
				case [name, css]:
					var name = name.extractString();
					var css = css.extractString();
					output.set(name, css);
				default:
					Context.error('Invalid css data', Context.currentPos());
			}
		default:
	}
	return output;
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

private function ensureDir(path:String) {
	var directory = path.directory();
	if (!directory.exists()) {
		ensureDir(directory);
		directory.createDirectory();
	}
	return path;
}
