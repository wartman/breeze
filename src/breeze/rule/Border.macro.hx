package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.ErrorTools;
import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

function radius(...exprs:Expr) {
	return createSimpleRule('border-radius', exprs, [Unit]);
}

function width(...exprs:Expr) {
	return createSimpleRule('border', exprs, [Unit], {property: 'border-width'});
}

function style(...exprs:Expr) {
	return createSimpleRule('border', exprs, [Word(['solid', 'dashed', 'dotted', 'double', 'hidden', 'none'])], {property: 'border-style'});
}

function color(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [colorExpr]:
			var color = colorExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
			createRule({
				prefix: 'border',
				type: [color],
				variants: args.variants,
				properties: [
					{
						name: 'border-color',
						value: switch color {
							case 'current': 'currentColor';
							default: color;
						}
					}
				],
				pos: Context.currentPos()
			});
		case [colorExpr, intensityExpr]:
			var color = colorExpr.extractCssValue([ColorName]);
			var intensity = intensityExpr.extractCssValue([Integer]);
			createRule({
				prefix: 'border',
				type: [color, intensity],
				variants: args.variants,
				properties: [{name: 'border-color', value: parseColor(color, intensity)}],
				pos: Context.currentPos()
			});
		default:
			expectedArguments(1, 2);
	}
}

function outlineWidth(...exprs:Expr) {
	return createSimpleRule('outline-width', exprs, [Unit]);
}

function outlineStyle(...exprs:Expr):Expr {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [expr]:
			var value = expr.extractCssValue([Word(['none', 'solid', 'dashed', 'dotted', 'double'])]);
			createRule({
				prefix: 'outline',
				type: [value],
				variants: args.variants,
				properties: switch value {
					case 'none': [
							{name: 'outline', value: '2px solid transparent'},
							{name: 'outline-offset', value: '2px'}
						];
					default: [{name: 'outline-style', value: value}];
				},
				pos: Context.currentPos()
			});
		default:
			expectedArguments(1);
	}
}

function outlineColor(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [colorExpr]:
			var color = colorExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
			createRule({
				prefix: 'outline',
				type: [color],
				variants: args.variants,
				properties: [
					{
						name: 'outline-color',
						value: switch color {
							case 'current': 'currentColor';
							default: color;
						}
					}
				],
				pos: Context.currentPos()
			});
		case [colorExpr, intensityExpr]:
			var color = colorExpr.extractCssValue([ColorName]);
			var intensity = intensityExpr.extractCssValue([Integer]);
			createRule({
				prefix: 'outline',
				type: [color, intensity],
				variants: args.variants,
				properties: [{name: 'outline-color', value: parseColor(color, intensity)}],
				pos: Context.currentPos()
			});
		default:
			expectedArguments(1, 2);
	}
}

function outlineOffset(...exprs:Expr) {
	return createSimpleRule('outline-offset', exprs, [Unit]);
}

function divideWidth(...exprs:Expr):Expr {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [directionExpr, sizeExpr]:
			var direction = directionExpr.extractCssValue([Word(['x', 'y'])]);
			var size = sizeExpr.extractCssValue([Unit]);
			createRule({
				prefix: 'divide',
				type: [direction, size],
				variants: args.variants.concat([divideSuffix()]),
				properties: switch direction {
					case 'x': [
							{name: 'border-right-width', value: '0'},
							{name: 'border-left-width', value: size}
						];
					default: [
							{name: 'border-bottom-width', value: '0'},
							{name: 'border-top-width', value: size}
						];
				},
				pos: Context.currentPos()
			});
		default:
			expectedArguments(2);
	}
}

function divideStyle(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [expr]:
			var style = expr.extractCssValue([Word(['none', 'solid', 'dotted', 'dashed', 'double'])]);
			createRule({
				prefix: 'divide',
				type: [style],
				variants: args.variants.concat([divideSuffix()]),
				properties: [{name: 'border-style', value: style}],
				pos: Context.currentPos()
			});
		default:
			expectedArguments(1);
	}
}

function divideColor(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [colorExpr]:
			var color = colorExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
			createRule({
				prefix: 'divide',
				type: [color],
				variants: args.variants.concat([divideSuffix()]),
				properties: [
					{
						name: 'border-color',
						value: switch color {
							case 'current': 'currentColor';
							default: color;
						}
					}
				],
				pos: Context.currentPos()
			});
		case [colorExpr, intensityExpr]:
			var color = colorExpr.extractCssValue([ColorName]);
			var intensity = intensityExpr.extractCssValue([Integer]);
			createRule({
				prefix: 'divide',
				type: [color, intensity],
				variants: args.variants.concat([divideSuffix()]),
				properties: [{name: 'border-color', value: parseColor(color, intensity)}],
				pos: Context.currentPos()
			});
		default:
			expectedArguments(1, 2);
	}
}

// function ringWidth(...exprs:Expr) {}
// function ringColor(...exprs:Expr) {}
// function ringOffsetWidth(...exprs:Expr) {}
// function ringOffsetColor(...exprs:Expr) {}

private function divideSuffix() {
	return maybeRegisterVariant('divide-suffix', entry -> {
		entry.selector += ' > * + *';
		entry;
	});
}
