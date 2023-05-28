package breeze.variant;

import haxe.macro.Expr;
import haxe.macro.Context;
import breeze.core.RuleBuilder;

// @todo: allow this to be configured to use a class selector
// instead of the media query?
//
// @todo: This does not seem to always have the right priority.
// We may need to go in and figure out how to enforce that.
class ColorScheme {
	public static function dark(...exprs:Expr):Expr {
		return wrapWithVariant('color-scheme:dark', entry -> {
			if (entry.wrapper != null) {
				Context.error('This rule already has a wrapper -- make sure you haven\'t wrapped it too deeply', Context.currentPos());
			}
			entry.selector = 'dark:${entry.selector}';
			entry.wrapper = '@media screen and (prefers-color-scheme:dark)';
			return entry;
		}, exprs);
	}

	public static function light(...exprs:Expr):Expr {
		return wrapWithVariant('color-scheme:light', entry -> {
			if (entry.wrapper != null) {
				Context.error('This rule already has a wrapper -- make sure you haven\'t wrapped it too deeply', Context.currentPos());
			}
			entry.selector = 'light:${entry.selector}';
			entry.wrapper = '@media screen and (prefers-color-scheme:light)';
			return entry;
		}, exprs);
	}
}
