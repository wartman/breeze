package breeze.core;

import sys.io.File;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;

using haxe.io.Path;
using breeze.core.MacroTools;
using breeze.core.CssTools;

final CssMeta = ':breeze.css';

typedef CssEntry = {
	public var wrapper:Null<String>;
	public var selector:String;
	public var modifiers:Array<String>;
	public var css:String;
}

function registerCss(css:CssEntry, pos:Position) {
	var cls = Context.getLocalClass().get();

	var parsed = '.${css.selector.sanitizeCssClassName()}';
	if (css.modifiers.length > 0) parsed += css.modifiers.join('');
	parsed += ' ' + css.css;

	if (css.wrapper != null) {
		parsed = css.wrapper + ' {$parsed}';
	}

	cls.meta.add(CssMeta, [macro $v{css.selector}, macro $v{parsed}], pos);

	// @todo: Only export if this is in export mode.
	export();
}

var initialized:Bool = false;

// @todo: allow this to have several modes.
private function export() {
	if (initialized) return;
	initialized = true;

	var output:Map<String, String> = [];

	function extract(exprs:Array<Expr>) {
		switch exprs {
			case [name, css]:
				var name = name.extractString();
				var css = css.extractString();
				output.set(name, css);
			default:
				Context.error('Invalid css data', Context.currentPos());
		}
	}

	Context.onAfterTyping(types -> {
		if (Context.defined('display') || Context.defined('breeze.ignore')) return;

		for (type in types) switch type {
			case TClassDecl(t):
				var cls = t.get();
				if (cls.meta.has(CssMeta)) {
					var meta = cls.meta.extract(CssMeta);
					for (item in meta) extract(item.params);
				}
			default:
		}

		var data = [for (_ => css in output) css].join('\n');
		var path = getExportFilename();
		File.saveContent(path, data);
	});
}

private function getExportFilename() {
	return switch Context.definedValue('breeze.output') {
		case null:
			Path.join([sys.FileSystem.absolutePath(Compiler.getOutput().directory()), 'styles']).withExtension('css');
		case abs = _.charAt(0) => '.' | '/':
			abs.withExtension('css');
		case relative:
			Path.join([sys.FileSystem.absolutePath(Compiler.getOutput().directory()), relative]).withExtension('css');
	}
}
