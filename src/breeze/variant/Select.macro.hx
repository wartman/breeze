package breeze.variant;

import breeze.core.ErrorTools;
import haxe.macro.Expr;
import breeze.core.Rule;

using breeze.core.ValueTools;

class Select {
	public static function child(...exprs:Expr):Expr {
		var exprs = exprs.toArray();
		var modifier = exprs.shift();

		if (modifier == null) {
			expectedArguments(1);
		}

		var name = modifier.extractCssValue([Word(['first', 'last', 'odd', 'even'])]);

		return Variant.create('select:$name', entry -> {
			entry.selector = '$name:${entry.selector}';
			entry.modifiers.push(':${name}-child');
			return entry;
		}).wrap(exprs);
	}

	public static function descendants(...exprs:Expr):Expr {
		var exprs = exprs.toArray();
		return Variant.create('select:descendants', entry -> {
			entry.selector = '${entry.selector}:*';
			entry.modifiers.push(' *');
			return entry;
		}).wrap(exprs);
	}

	macro public static function before(...exprs:Expr):Expr {
		return Variant.create('select:before', entry -> {
			entry.selector = 'before:${entry.selector}';
			entry.modifiers.push('::before');
			return entry;
		}).wrap(exprs);
	}

	macro public static function after(...exprs:Expr):Expr {
		return Variant.create('select:after', entry -> {
			entry.selector = 'after:${entry.selector}';
			entry.modifiers.push('::after');
			return entry;
		}).wrap(exprs);
	}
}
