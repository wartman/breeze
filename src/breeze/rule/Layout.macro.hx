package breeze.rule;

import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.MacroTools;
using breeze.core.CssTools;
using breeze.core.ValueTools;

function container(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case []:
			return createRule({
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
			return createRule({
				prefix: 'container',
				type: [breakpoint.sanitizeClassName()],
				variants: args.variants,
				properties: [
					switch breakpoint {
						case 'full':
							{name: 'width', value: '100%'};
						case name if (config.exists(name)):
							{name: 'max-width', value: config.get(name)};
						// case 'sm': {name: 'max-width', value: '640px'};
						// case 'md': {name: 'max-width', value: '768px'};
						// case 'lg': {name: 'max-width', value: '1024px'};
						// case 'xl': {name: 'max-width', value: '1280px'};
						// case 'xxl': {name: 'max-width', value: '1536px'};
						case unit:
							{name: 'max-width', value: unit};
					}
				],
				pos: size.pos
			});
		default:
			Context.error('Expected 0 or 1 argument', Context.currentPos());
	}
}

function columns(...exprs:Expr) {
	return createSimpleRule('columns', exprs, [Integer]);
}

function boxSizing(...exprs) {
	return createSimpleRule('box-sizing', exprs, [Word(['border', 'content'])], {
		process: value -> switch value {
			case 'border': 'border-box';
			default: 'content-box';
		}
	});
}

function display(...exprs) {
	return createSimpleRule('display', exprs, [
		Word([
			'block', 'inline-block', 'inline', 'flex', 'inline-flex', 'table', 'inline-table', 'table-caption', 'table-cell', 'table-column',
			'table-column-group', 'table-footer-group', 'table-header-group', 'table-row-group', 'table-row', 'flow-root', 'grid', 'inline-grid', 'contents',
			'list-item', 'none'
		])
	]);
}

function float(...exprs) {
	return createSimpleRule('float', exprs, [Word(['left', 'right', 'none'])]);
}

function clear(...exprs) {
	return createSimpleRule('clear', exprs, [Word(['left', 'right', 'both', 'none'])]);
}

function isolate(...exprs) {
	return createSimpleRule('isolation', exprs, [Word(['isolate', 'auto'])]);
}

/**
	Use `overflow('visible')` to prevent an element inside another from being
	clipped, and `overflow('hidden')` to do the opposite.

	Use `overflow('auto')` to add a scrollbar *only if needed* and `overflow('scroll')`
	to always show the scrollbar, even if it's not required.

	Use `overflow('x', ...)` or  `overflow('y', ...)` to only apply these settings
	horizontally (x) or vertically (y).
**/
function overflow(...exprs) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [overflowExpr]:
			var overflow = overflowExpr.extractCssValue([Word(['auto', 'hidden', 'clip', 'visible', 'scroll'])]);
			return createRule({
				prefix: 'overflow',
				type: [overflow],
				variants: args.variants,
				properties: [{name: 'overflow', value: overflow}],
				pos: overflowExpr.pos
			});
		case [sideExpr, overflowExpr]:
			var side = sideExpr.extractCssValue([Word(['x', 'y'])]);
			var overflow = overflowExpr.extractCssValue([Word(['auto', 'hidden', 'clip', 'visible', 'scroll'])]);
			return createRule({
				prefix: 'overflow',
				type: [side, overflow],
				variants: args.variants,
				properties: [{name: 'overflow-$side', value: overflow}],
				pos: overflowExpr.pos
			});
		default:
			Context.error('Expected 1 to 2 arguments', Context.currentPos());
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
function overscroll(...exprs) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [overscrollExpr]:
			var overscroll = overscrollExpr.extractCssValue([Word(['auto', 'contain', 'none'])]);
			return createRule({
				prefix: 'overscroll',
				type: [overscroll],
				variants: args.variants,
				properties: [{name: 'overscroll-behavior', value: overscroll}],
				pos: overscrollExpr.pos
			});
		case [sideExpr, overscrollExpr]:
			var side = sideExpr.extractCssValue([Word(['x', 'y'])]);
			var overscroll = overscrollExpr.extractCssValue([Word(['auto', 'contain', 'none'])]);
			return createRule({
				prefix: 'overscroll',
				type: [side, overscroll],
				variants: args.variants,
				properties: [{name: 'overscroll-behavior-$side', value: overscroll}],
				pos: overscrollExpr.pos
			});
		default:
			Context.error('Expected 1 to 2 arguments', Context.currentPos());
	}
}

function position(...exprs:Expr) {
	return createSimpleRule('position', exprs, [Word(['static', 'fixed', 'absolute', 'relative', 'sticky'])]);
}

function attach(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [sideExpr, distanceExpr]:
			var side = sideExpr.extractCssValue([Word(['top', 'right', 'bottom', 'left', 'inset', 'inset-x', 'inset-y'])]);
			var distance = distanceExpr.extractCssValue([Unit]);
			return createRule({
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
			Context.error('Expected 1 argument', Context.currentPos());
	}
}

function visibility(...exprs:Expr) {
	return createSimpleRule('visibility', exprs, [Word(['visible', 'hidden', 'collapse'])]);
}

/**
	Sets the z-index in a consistent way.
**/
function layer(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [layerExpr]:
			var layer = layerExpr.extractCssValue([Word(['auto']), Integer]);
			return createRule({
				prefix: 'layer',
				type: [layer],
				variants: args.variants,
				properties: [{name: 'z-index', value: layer}],
				pos: layerExpr.pos
			});
		case [directionExpr, layerExpr]:
			var direction = directionExpr.extractCssValue([Word(['+', '-'])]);
			var layer = layerExpr.extractCssValue([Integer]);
			return createRule({
				prefix: 'layer',
				type: [direction == '-' ? 'neg' : null, layer].filter(s -> s != null),
				variants: args.variants,
				properties: [
					{
						name: 'z-index',
						value: switch direction {
							case '-': '-${direction}';
							default: direction;
						}
					}
				],
				pos: layerExpr.pos
			});
		default:
			Context.error('Expected 1 or two arguments', Context.currentPos());
	}
}
