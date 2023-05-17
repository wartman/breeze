package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

function borderRadius(...exprs:Expr) {
	return createSimpleRule('border-radius', exprs, [Unit]);
}

function borderWidth(...exprs:Expr) {
	return createSimpleRule('border-width', exprs, [Unit]);
}

function borderStyle(...exprs:Expr) {
	return createSimpleRule('border-style', exprs, [Word(['solid', 'dashed', 'dotted', 'double', 'hidden', 'none'])]);
}

function borderColor(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [colorExpr]:
			var color = colorExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
			createRule({
				prefix: 'border-color',
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
				prefix: 'border-color',
				type: [color, intensity],
				variants: args.variants,
				properties: [{name: 'border-color', value: parseColor(color, intensity)}],
				pos: Context.currentPos()
			});
		default:
			Context.error('Expected 1 to 2 arguments', Context.currentPos());
	}
}

// function divideWidth(...exprs:Expr) {}
// function divideStyle(...exprs:Expr) {}
// function divideColor(...exprs:Expr) {}
// function ringWidth(...exprs:Expr) {}
// function ringColor(...exprs:Expr) {}
// function ringOffsetWidth(...exprs:Expr) {}
// function ringOffsetColor(...exprs:Expr) {}
