package breeze.rule;

import breeze.core.Rule;
import breeze.core.ErrorTools;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.MacroTools;
using breeze.core.CssTools;
using breeze.core.ValueTools;

class Layout {
	public static function container(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case []:
				return Rule.create({
					prefix: 'container',
					variants: args.variants,
					properties: [{name: 'width', value: '100%'}],
					pos: Context.currentPos()
				});
			case [size]:
				var config:Map<String, String> = Config.instance().containerSizes;
				var names = [for (name in config.keys()) name];
				names.push('full');
				var breakpoint = size.extractCssValue([Word(names), Unit]);
				return Rule.create({
					prefix: 'container',
					type: [breakpoint],
					variants: args.variants,
					properties: [
						switch breakpoint {
							case 'full':
								{name: 'width', value: '100%'};
							case name if (config.exists(name)):
								{name: 'max-width', value: config.get(name)};
							case unit:
								{name: 'max-width', value: unit};
						}
					],
					pos: size.pos
				});
			default:
				expectedArguments(0, 1);
		}
	}

	public static function columns(...exprs:Expr):Expr {
		return Rule.simple('columns', exprs, [Integer]);
	}

	public static function boxSizing(...exprs) {
		return Rule.simple('box-sizing', exprs, [Word(['border', 'content'])], {
			process: value -> switch value {
				case 'border': 'border-box';
				default: 'content-box';
			}
		});
	}

	public static function display(...exprs) {
		return Rule.simple('display', exprs, [
			Word([
				'block', 'inline-block', 'inline', 'flex', 'inline-flex', 'table', 'inline-table', 'table-caption', 'table-cell', 'table-column',
				'table-column-group', 'table-footer-group', 'table-header-group', 'table-row-group', 'table-row', 'flow-root', 'grid', 'inline-grid',
				'contents',
				'list-item', 'none'
			])
		]);
	}

	public static function float(...exprs) {
		return Rule.simple('float', exprs, [Word(['left', 'right', 'none'])]);
	}

	public static function clear(...exprs) {
		return Rule.simple('clear', exprs, [Word(['left', 'right', 'both', 'none'])]);
	}

	public static function isolate(...exprs) {
		return Rule.simple('isolation', exprs, [Word(['isolate', 'auto'])]);
	}

	/**
		Use `overflow('visible')` to prevent an element inside another from being
		clipped, and `overflow('hidden')` to do the opposite.

		Use `overflow('auto')` to add a scrollbar *only if needed* and `overflow('scroll')`
		to always show the scrollbar, even if it's not required.

		Use `overflow('x', ...)` or  `overflow('y', ...)` to only apply these settings
		horizontally (x) or vertically (y).
	**/
	public static function overflow(...exprs):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [overflowExpr]:
				var overflow = overflowExpr.extractCssValue([Word(['auto', 'hidden', 'clip', 'visible', 'scroll'])]);
				return Rule.create({
					prefix: 'overflow',
					type: [overflow],
					variants: args.variants,
					properties: [{name: 'overflow', value: overflow}],
					pos: overflowExpr.pos
				});
			case [sideExpr, overflowExpr]:
				var side = sideExpr.extractCssValue([Word(['x', 'y'])]);
				var overflow = overflowExpr.extractCssValue([Word(['auto', 'hidden', 'clip', 'visible', 'scroll'])]);
				return Rule.create({
					prefix: 'overflow',
					type: [side, overflow],
					variants: args.variants,
					properties: [{name: 'overflow-$side', value: overflow}],
					pos: overflowExpr.pos
				});
			default:
				expectedArguments(1, 2);
		}
	}

	/**
		Use `overscroll` to define scroll behavior when scrolling beyond the
		bounds of an element.

		Use `overscroll('contain')` to prevent scrolling in the target area 
		from triggering scrolling in the parent element, but preserve 
		“bounce” effects when scrolling past the end of the container in 
		operating systems that support it.

		Use `overscroll('none')` to prevent scrolling in the target area from 
		triggering scrolling in the parent element, and also prevent 
		“bounce” effects when scrolling past the end of the container.

		Use `overscroll('auto')` to make it possible for the user to continue 
		scrolling a parent scroll area when they reach the boundary of the 
		primary scroll area.
	**/
	public static function overscroll(...exprs):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [overscrollExpr]:
				var overscroll = overscrollExpr.extractCssValue([Word(['auto', 'contain', 'none'])]);
				return Rule.create({
					prefix: 'overscroll',
					type: [overscroll],
					variants: args.variants,
					properties: [{name: 'overscroll-behavior', value: overscroll}],
					pos: overscrollExpr.pos
				});
			case [sideExpr, overscrollExpr]:
				var side = sideExpr.extractCssValue([Word(['x', 'y'])]);
				var overscroll = overscrollExpr.extractCssValue([Word(['auto', 'contain', 'none'])]);
				return Rule.create({
					prefix: 'overscroll',
					type: [side, overscroll],
					variants: args.variants,
					properties: [{name: 'overscroll-behavior-$side', value: overscroll}],
					pos: overscrollExpr.pos
				});
			default:
				expectedArguments(1, 2);
		}
	}

	public static function position(...exprs:Expr):Expr {
		return Rule.simple('position', exprs, [Word(['static', 'fixed', 'absolute', 'relative', 'sticky'])]);
	}

	public static function attach(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [sideExpr, distanceExpr]:
				var side = sideExpr.extractCssValue([Word(['top', 'right', 'bottom', 'left', 'inset', 'inset-x', 'inset-y'])]);
				var distance = distanceExpr.extractCssValue([Unit]);
				return Rule.create({
					prefix: 'attach',
					type: [side, distance],
					variants: args.variants,
					properties: switch side {
						case 'inset-x': [{name: 'left', value: distance}, {name: 'right', value: distance}];
						case 'inset-y': [{name: 'top', value: distance}, {name: 'bottom', value: distance}];
						case prop: [{name: prop, value: distance}];
					},
					pos: sideExpr.pos
				});
			default:
				expectedArguments(1);
		}
	}

	public static function visibility(...exprs:Expr):Expr {
		return Rule.simple('visibility', exprs, [Word(['visible', 'hidden', 'collapse'])]);
	}

	/**
		Sets the z-index in a consistent way.
	**/
	public static function layer(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [layerExpr]:
				var layer = layerExpr.extractCssValue([Word(['auto']), Integer]);
				Rule.create({
					prefix: 'layer',
					type: [layer],
					variants: args.variants,
					properties: [{name: 'z-index', value: layer}],
					pos: layerExpr.pos
				});
			case [directionExpr, layerExpr]:
				var direction = directionExpr.extractCssValue([Word(['+', '-'])]);
				var layer = layerExpr.extractCssValue([Integer]);
				Rule.create({
					prefix: 'layer',
					type: [direction == '-' ? 'neg' : null, layer].filter(s -> s != null),
					variants: args.variants,
					properties: [
						{
							name: 'z-index',
							value: switch direction {
								case '-': '-${layer}';
								default: layer;
							}
						}
					],
					pos: layerExpr.pos
				});
			default:
				expectedArguments(1, 2);
		}
	}
}
