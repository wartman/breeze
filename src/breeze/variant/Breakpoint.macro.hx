package breeze.variant;

import haxe.macro.Expr;
import haxe.macro.Context;
import breeze.core.RuleBuilder;

using breeze.core.ValueTools;

class Breakpoint {
	/**
		The `Breakpoint.viewport` function will wrap the rules you give it in the given
		breakpoint.

		Valid breakpoints (by default):
		- sm: min-width: 640px
		- md: min-width: 768px
		- lg: min-width: 1024px
		- xl: min-width: 1280px
		- xxl: min-width: 1536px

		You can also provide your own arbitrary units (can be pixels or bare floats, 
		which will be converted to `rem` units).
	**/
	public static function viewport(size:Expr, ...exprs:Expr) {
		var breakpoints = Config.instance().breakpoints;
		var words = [for (name in breakpoints.keys()) name].concat(['full']);
		var breakpoint = size.extractCssValue([Word(words), Unit]);
		var constraint = switch breakpoint {
			case 'full': 'width: 100%';
			case name if (breakpoints.exists(name)): 'min-width: ${breakpoints.get(name)}';
			case unit: 'min-width: $unit';
		}
		var name = 'break-$breakpoint';
		return wrapWithVariant(name, entry -> {
			if (entry.wrapper != null) {
				Context.error('This rule already has a wrapper -- make sure you haven\'t wrapped it too deeply', Context.currentPos());
			}
			entry.selector = '$name:${entry.selector}';
			entry.wrapper = '@media screen and ($constraint)';
			return entry;
		}, exprs.toArray());
	}

	/**
		The `container` function works similarly to the `breakpoint` function,
		but it uses the new `@container` query rather than a `@media` query. You
		can learn more about it [here](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Container_Queries).

		Valid breakpoints (by default):
		- sm: min-width: 640px
		- md: min-width: 768px
		- lg: min-width: 1024px
		- xl: min-width: 1280px
		- xxl: min-width: 1536px

		You can also provide your own arbitrary units (can be pixels or bare floats, 
		which will be converted to `rem` units).
	**/
	public static function container(size:Expr, ...exprs:Expr) {
		// @todo: Do we need to add a `name` arg here? For `container-name`?
		var breakpoints = Config.instance().breakpoints;
		var words = [for (name in breakpoints.keys()) name].concat(['full']);
		var breakpoint = size.extractCssValue([Word(words), Unit]);
		var constraint = switch breakpoint {
			case 'full': 'min-width: 100%';
			case name if (breakpoints.exists(name)): 'min-width: ${breakpoints.get(name)}';
			case unit: 'min-width: $unit';
		}
		var name = 'container-$breakpoint';
		return wrapWithVariant(name, entry -> {
			if (entry.wrapper != null) {
				Context.error('This rule already has a wrapper -- make sure you haven\'t wrapped it too deeply', Context.currentPos());
			}
			entry.selector = '$name:${entry.selector}';
			entry.wrapper = '@container ($constraint)';
			return entry;
		}, exprs);
	}
}
