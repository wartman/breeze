package breeze.variant;

import haxe.macro.Expr;
import haxe.macro.Context;
import breeze.core.RuleBuilder;

function dark(...exprs:Expr):Expr {
	return wrapWithVariant('color-scheme:dark', entry -> {
		if (entry.wrapper != null) {
			Context.error('This rule already has a wrapper -- make sure you haven\'t wrapped it too deeply', Context.currentPos());
		}
		entry.selector = 'dark:${entry.selector}';
		entry.wrapper = '@media screen and (prefers-color-scheme:dark)';
		return entry;
	}, exprs);
}

function light(...exprs:Expr):Expr {
	return wrapWithVariant('color-scheme:light', entry -> {
		if (entry.wrapper != null) {
			Context.error('This rule already has a wrapper -- make sure you haven\'t wrapped it too deeply', Context.currentPos());
		}
		entry.selector = 'light:${entry.selector}';
		entry.wrapper = '@media screen and (prefers-color-scheme:light)';
		return entry;
	}, exprs);
}
