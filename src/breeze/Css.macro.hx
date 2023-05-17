package breeze;

import breeze.core.CssTools.sanitizeClassName;
import breeze.core.Registry;
import haxe.macro.Context;
import haxe.macro.Expr;
import breeze.core.RuleBuilder;

using breeze.core.MacroTools;
using haxe.macro.Tools;

/**
	Create an arbitrary CSS rule. No checks will be performed --
	this is intended entirely as a way to add CSS that Breeze doesn't
	provide. Only use this as a last resort and check to see if there
	is a function Breeze has!

	```haxe
	var className = Css.rule('
	  color: var(--foo-bar);
	  padding: 100%;
	');
	```

	Note that you should *not* wrap the css in curly braces (see the example
	above).
**/
function rule(...expr:Expr) {
	var args = prepareArguments(expr);
	return switch args.args {
		case [expr]:
			var css = '{' + expr.extractString() + '}';
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

private function createClassName() {
	var id = sanitizeClassName(switch Context.getLocalType().toComplexType() {
		case TPath(p): p.pack.concat([p.name, p.sub].filter(s -> s != null)).join('-');
		default: Context.signature(Context.getLocalType());
	});
	var pos = Context.currentPos().getInfos();
	return 'bz-$id-${pos.max}';
}
