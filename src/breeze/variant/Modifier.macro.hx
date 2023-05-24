package breeze.variant;

import breeze.core.ErrorTools;
import breeze.core.RuleBuilder;
import haxe.macro.Expr;

using breeze.core.ValueTools;

class Modifier {
	public static function on(...exprs:Expr) {
		var exprs = exprs.toArray();
		var modifier = exprs.shift();
		return createModifierVariant(modifier, exprs);
	}

	public static function hover(...exprs:Expr) {
		return createModifierVariant(macro 'hover', exprs);
	}

	public static function focus(...exprs:Expr) {
		return createModifierVariant(macro 'focus', exprs);
	}

	public static function active(...exprs:Expr) {
		return createModifierVariant(macro 'active', exprs);
	}

	public static function disabled(...exprs:Expr) {
		return createModifierVariant(macro 'disabled', exprs);
	}

	public static function visited(...exprs:Expr) {
		return createModifierVariant(macro 'visited', exprs);
	}

	public static function focusWithin(...exprs:Expr) {
		return createModifierVariant(macro 'focus-within', exprs);
	}

	public static function focusVisible(...exprs:Expr) {
		return createModifierVariant(macro 'focus-visible', exprs);
	}

	public static function target(...exprs:Expr) {
		return createModifierVariant(macro 'target', exprs);
	}
}

private function createModifierVariant(modifier:Null<Expr>, exprs:Array<Expr>) {
	if (modifier == null) {
		expectedArguments(1);
	}

	var name = modifier.extractCssValue([
		Word([
			'hover',
			'focus',
			'active',
			'disabled',
			'visited',
			'focus-within',
			'focus-visible',
			'target'
		])
	]);

	return wrapWithVariant(name, entry -> {
		entry.selector = '$name:${entry.selector}';
		entry.modifiers.push(':$name');
		return entry;
	}, exprs);
}
