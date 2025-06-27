package breeze;

import breeze.core.Registry;
import breeze.core.Rule;
import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;
using breeze.core.CssTools;
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
		var args:Arguments = expr;
		return switch args.exprs {
			case [expr]:
				var css = '{ ' + expr.extractString().normalizeCss() + ' }';
				var entry:CssEntry = {
					selector: createClassName(),
					specifiers: [],
					modifiers: [],
					wrapper: null,
					css: css,
					priority: 1
				};
				if (args.variants.length > 0) {
					for (name in args.variants) {
						entry = Variant.fromIdentifier(name).parse(entry);
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
	var id = (switch Context.getLocalType().toComplexType() {
		case TPath(p): p.pack.concat([p.name, p.sub].filter(s -> s != null)).join('-');
		default: Context.signature(Context.getLocalType());
	}).sanitizeClassName();
	var pos = Context.currentPos().getInfos();
	return 'bz-$id-${pos.max}';
}
