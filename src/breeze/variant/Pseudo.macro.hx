package breeze.variant;

import breeze.core.ErrorTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import breeze.core.RuleBuilder;

using breeze.core.ValueTools;

function modifier(...exprs:Expr) {
	var exprs = exprs.toArray();
	var modifier = exprs.shift();
	return createModifierVariant(modifier, exprs);
}

function hover(...exprs:Expr) {
	return createModifierVariant(macro 'hover', exprs);
}

function focus(...exprs:Expr) {
	return createModifierVariant(macro 'focus', exprs);
}

function active(...exprs:Expr) {
	return createModifierVariant(macro 'active', exprs);
}

function disabled(...exprs:Expr) {
	return createModifierVariant(macro 'disabled', exprs);
}

function visited(...exprs:Expr) {
	return createModifierVariant(macro 'visited', exprs);
}

function focusWithin(...exprs:Expr) {
	return createModifierVariant(macro 'focus-within', exprs);
}

function focusVisible(...exprs:Expr) {
	return createModifierVariant(macro 'focus-visible', exprs);
}

function target(...exprs:Expr) {
	return createModifierVariant(macro 'target', exprs);
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
