package breeze.variant;

import breeze.core.RuleBuilder;
import haxe.macro.Expr;

// @todo: allow this to be configured to use a class selector
// instead of the media query?
//
// @todo: This does not seem to always have the right priority.
// We may need to go in and figure out how to enforce that.
class ColorScheme {
	public static function dark(...exprs:Expr):Expr {
		return wrapWithVariant('color-scheme:dark', entry -> {
			entry.selector = 'dark:${entry.selector}';
			entry.setWrapper('@media screen and (prefers-color-scheme:dark)');
			entry.increasePriority();
			return entry;
		}, exprs);
	}

	public static function light(...exprs:Expr):Expr {
		return wrapWithVariant('color-scheme:light', entry -> {
			entry.selector = 'light:${entry.selector}';
			entry.setWrapper('@media screen and (prefers-color-scheme:light)');
			entry.increasePriority();
			return entry;
		}, exprs);
	}
}
