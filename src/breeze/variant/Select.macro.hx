package breeze.variant;

import breeze.core.ErrorTools;
import haxe.macro.Expr;
import breeze.core.RuleBuilder;

using breeze.core.ValueTools;

class Select {
	public static function child(...exprs:Expr) {
		var exprs = exprs.toArray();
		var modifier = exprs.shift();

		if (modifier == null) {
			expectedArguments(1);
		}

		var name = modifier.extractCssValue([Word(['first', 'last', 'odd', 'even'])]);

		return wrapWithVariant(name, entry -> {
			entry.selector = '$name:${entry.selector}';
			entry.modifiers.push(':${name}-child');
			return entry;
		}, exprs);
	}
}
