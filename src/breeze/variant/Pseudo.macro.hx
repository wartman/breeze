package breeze.variant;

import haxe.macro.Context;
import haxe.macro.Expr;
import breeze.core.RuleBuilder;

using breeze.core.ValueTools;

function modifier(...exprs:Expr) {
	var exprs = exprs.toArray();
	var modifier = exprs.shift();
	if (modifier == null) {
		Context.error('Expected at least 1 argument', Context.currentPos());
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

function child(...exprs:Expr) {
	var exprs = exprs.toArray();
	var modifier = exprs.shift();
	if (modifier == null) {
		Context.error('Expected at least 1 argument', Context.currentPos());
	}
	var name = modifier.extractCssValue([Word(['first', 'last', 'odd', 'even'])]);

	return wrapWithVariant(name, entry -> {
		entry.selector = '$name:${entry.selector}';
		entry.modifiers.push(':${name}-child');
		return entry;
	}, exprs);
}
