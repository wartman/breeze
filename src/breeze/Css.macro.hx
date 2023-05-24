package breeze;

import breeze.core.CssTools.sanitizeClassName;
import breeze.core.Registry;
import haxe.macro.Context;
import haxe.macro.Expr;
import breeze.core.RuleBuilder;

using StringTools;
using breeze.core.MacroTools;
using haxe.macro.Tools;

class Css {
	/**
		Create an arbitrary CSS rule. No checks will be performed to ensure the
		css is valid -- this is intended entirely as an escape hatch if you need
		functionality that Breeze does not provide.

		```haxe
		var className = Css.rule('
		  color: var(--foo-bar);
		  padding: 100%;
		');
		```

		Note that you should *not* wrap the css in curly braces (see the example
		above). Breeze will do this for you.
	**/
	public static function rule(...expr:Expr) {
		var args = prepareArguments(expr);
		return switch args.args {
			case [expr]:
				var css = '{ ' + normalizeCss(expr.extractString()) + ' }';
				var entry:CssEntry = {
					selector: createClassName(),
					wrapper: null,
					css: css,
					modifiers: []
				};
				if (args.variants.length > 0) {
					for (name in args.variants) {
						entry = getVariant(name).parse(entry);
					}
				}
				registerCss(entry, expr.pos);
				macro breeze.ClassName.ofString($v{entry.selector});
			default:
				Context.error('Expected 1 argument', Context.currentPos());
		}
	}
}

private function createClassName() {
	var id = sanitizeClassName(switch Context.getLocalType().toComplexType() {
		case TPath(p): p.pack.concat([p.name, p.sub].filter(s -> s != null)).join('-');
		default: Context.signature(Context.getLocalType());
	});
	var pos = Context.currentPos().getInfos();
	return 'bz-$id-${pos.max}';
}

private function normalizeCss(value:String) {
	return value.replace('\r\n', '\n').split('\n').map(part -> part.trim()).join(' ').trim();
}
