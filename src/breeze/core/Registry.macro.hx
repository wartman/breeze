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

@:using(breeze.core.Registry.CssEntryTools)
typedef CssEntry = {
	public var wrapper:Null<String>;
	public var selector:String;
	public var specifiers:Array<{selector:String, ?prefix:Bool}>;
	public var modifiers:Array<String>;
	public var priority:Int;
	public var css:String;
}

class CssEntryTools {
	public static function increasePriority(entry:CssEntry) {
		entry.priority = entry.priority == null ? 2 : entry.priority + 1;
		return entry;
	}

	public static function setWrapper(entry:CssEntry, wrapper:String) {
		if (entry.wrapper != null) {
			Context.error('This rule already has a wrapper -- make sure you haven\'t wrapped it too deeply', Context.currentPos());
		}
		entry.wrapper = wrapper;
		return entry;
	}
}

function registerCss(entry:CssEntry, pos:Position) {
	var parsed = '.${entry.selector.sanitizeCssClassName()}';
	if (entry.modifiers.length > 0) parsed += entry.modifiers.join('');
	if (entry.specifiers.length > 0) {
		var classes = [];
		var prefixes = entry.specifiers.filter(spec -> spec.prefix == true);
		var suffixes = entry.specifiers.filter(spec -> spec.prefix != true);
		for (prefix in prefixes) {
			classes.push(prefix + ' ' + parsed);
		}
		for (suffix in suffixes) {
			classes.push(parsed + ' ' + suffix);
		}
		parsed = classes.join(',');
	}
	parsed += entry.css;
	if (entry.wrapper != null) parsed = entry.wrapper + '{$parsed}';
	return export(entry.selector, parsed, entry.priority, pos);
}

function registerRawCss(id:String, css:String, ?pos:Position) {
	var pos = pos ?? Context.currentPos();
	return export(id, css, 0, pos);
}

private var initialized:Bool = false;

private function export(id:String, css:String, priority:Int, pos:Position) {
	var cls = Context.getLocalClass().get();
	return switch Config.instance().export {
		case Runtime:
			// @todo: This is a bit ugly, but it works well enough for
			// development purposes.
			return macro breeze.Runtime.instance().rule($v{id}, $v{css}, $v{priority});
		case None:
			macro breeze.ClassName.ofString($v{id});
		case File(path):
			// @todo: This works really poorly. All kinds of weird stuff can
			// happen. We need to figure out a bit better how the Completion server
			// and cacheing work, as this only outputs the correct CSS file
			// on a fresh build. The main issue is that the the CSS file will be
			// regenerated whenever the completion server runs, which can be super
			// weird.
			//
			// Take a look at tink_onbuild for some guidance.
			cls.meta.add(CssMeta, [macro $v{id}, macro $v{css}, macro $v{priority}], pos);
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
			var parts = [for (_ => part in Config.instance().preflight) part];
			parts.sort((a, b) -> a.priority - b.priority);
			var preflight = parts.map(part -> part.css).join('\n');
			data.unshift({css: preflight, priority: -1});
		}

		data.sort((a, b) -> a.priority - b.priority);

		ensureDir(path);
		File.saveContent(path, data.map(item -> item.css).join('\n'));
	});
}

private function extractAllCssFromTypes(types:ReadOnlyArray<ModuleType>) {
	var output:Map<String, {css:String, priority:Int}> = [];
	for (type in types) switch type {
		case TClassDecl(_.get() => cls) if (cls.meta.has(CssMeta)):
			var meta = cls.meta.extract(CssMeta);
			for (item in meta) switch item.params {
				case [name, css, priority]:
					var name = name.extractString();
					var css = css.extractString();
					var priority = priority.extractInt();
					output.set(name, {css: css, priority: priority});
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
