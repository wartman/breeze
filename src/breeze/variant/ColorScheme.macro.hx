package breeze.variant;

import breeze.core.RuleBuilder;
import haxe.macro.Expr;

class ColorScheme {
	public static function dark(...exprs:Expr):Expr {
		return wrapWithVariant('color-scheme:dark', entry -> {
			entry.selector = 'dark:${entry.selector}';

			switch Config.instance().darkModeStrategy {
				case SystemStrategy:
					entry.setWrapper('@media screen and (prefers-color-scheme:dark)');
				case ClassNameStrategy(name):
					if (name == null) name = 'dark';
					entry.specifiers.push({selector: '.$name', prefix: true});
			}

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
