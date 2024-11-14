package breeze.variant;

import breeze.core.ErrorTools.expectedArguments;
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
	public static function viewport(size:Expr, ...exprs:Expr):Expr {
		var breakpoints = Config.instance().breakpoints;
		var words = [for (name in breakpoints.keys()) name].concat(['full']);
		var breakpoint = size.extractCssValue([Word(words), Unit]);
		var constraint = switch breakpoint {
			case 'full': 'width: 100%';
			case name if (breakpoints.exists(name)): 'min-width: ${breakpoints.get(name)}';
			case unit: 'min-width: $unit';
		}
		var name = 'break-$breakpoint';
		return wrapWithVariant('breakpoint:$name', entry -> {
			entry.selector = '$name:${entry.selector}';
			entry.setWrapper('@media screen and ($constraint)');
			entry.increasePriority();
			switch breakpoint {
				case 'md': entry.priority += 1;
				case 'lg': entry.priority += 2;
				case 'xl': entry.priority += 3;
				case 'xxl': entry.priority += 4;
				default:
			}
			return entry;
		}, exprs.toArray());
	}

	/**
		The `container` function works similarly to the `breakpoint` function,
		but it uses the new `@container` query rather than a `@media` query. You
		can learn more about it [here](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Container_Queries).

		Valid breakpoints (by default):
		- sm: width > 640px
		- md: width > 768px
		- lg: width > 1024px
		- xl: width > 1280px
		- xxl: width > 1536px

		You can also provide your own arbitrary units (can be pixels or bare floats, 
		which will be converted to `rem` units).

		Note that container classes will *only* work inside an element with a 
		`container-type`. Use `Breakpoint.markContainer` to handle this.

		You can target a specific container using a `containerName`, or target
		the nearest element with a `container-type` by passing `"any"`.
	**/
	public static function container(containerName:Expr, size:Expr, ...exprs:Expr):Expr {
		var breakpoints = Config.instance().breakpoints;
		var words = [for (name in breakpoints.keys()) name].concat(['full']);
		var name = containerName.extractCssValue([String, Word(['any'])]);
		var breakpoint = size.extractCssValue([Word(words), Unit]);
		var constraint = switch breakpoint {
			case 'full': 'width: 100%';
			case name if (breakpoints.exists(name)): 'width > ${breakpoints.get(name)}';
			case unit: 'width > $unit';
		}
		var selector = 'container-$name-$breakpoint';
		return wrapWithVariant('breakpoint:$selector', entry -> {
			entry.selector = '$selector:${entry.selector}';
			entry.setWrapper((switch name {
				case 'any': '@container';
				case name: '@container $name';
			}) + ' ($constraint)');
			entry.increasePriority();
			switch breakpoint {
				case 'md': entry.priority += 1;
				case 'lg': entry.priority += 2;
				case 'xl': entry.priority += 3;
				case 'xxl': entry.priority += 4;
				default:
			}
			return entry;
		}, exprs);
	}

	/**
		Mark an element as a target for `@container` queries. You can optionally
		give the container element a name, which can then be used in `Breakpoint.container(...)`
		queries.

		```haxe
		var container = Breakpoint.markContainer('sidebar', 'inline-size');
		var insideSidebar = Breakpoint.container('sidebar', '700px', ...);
		```
	**/
	public static function markContainer(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		return switch args.args {
			case [expr]:
				var value = expr.extractCssValue([Word(['size', 'inline-size', 'normal'])]);
				createRule({
					prefix: 'mark-container',
					type: [value],
					variants: args.variants,
					properties: [{name: 'container-type', value: value}],
					pos: Context.currentPos()
				});
			case [nameExpr, typeExpr]:
				var name = nameExpr.extractCssValue([String]);
				var type = typeExpr.extractCssValue([Word(['size', 'inline-size', 'normal'])]);

				if (name == 'any') {
					Context.error('`any` is not a valid name for containment contexts', nameExpr.pos);
				}

				createRule({
					prefix: 'mark-container',
					type: [name, type],
					variants: args.variants,
					properties: [{name: 'container-type', value: type}, {name: 'container-name', value: name}],
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1, 2);
		}
	}
}
