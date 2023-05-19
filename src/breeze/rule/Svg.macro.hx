package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

function fill(...exprs:Expr):Expr {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [colorExpr]:
			var color = colorExpr.extractCssValue([Word(['none', 'inherit', 'currentColor', 'transparent']), ColorExpr]);
			createRule({
				prefix: 'fill',
				type: [color],
				variants: args.variants,
				properties: [{name: 'fill', value: color}],
				pos: Context.currentPos()
			});
		case [colorExpr, intensityExpr]:
			var color = colorExpr.extractCssValue([ColorName]);
			var intensity = intensityExpr.extractCssValue([Integer]);
			createRule({
				prefix: 'fill',
				type: [color, intensity],
				variants: args.variants,
				properties: [{name: 'fill', value: parseColor(color, intensity)}],
				pos: Context.currentPos()
			});
		default:
			Context.error('Expected 1 or 2 arguments', Context.currentPos());
	}
}

function stroke(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [colorExpr]:
			var color = colorExpr.extractCssValue([Word(['none', 'inherit', 'currentColor', 'transparent']), ColorExpr]);
			createRule({
				prefix: 'stroke',
				type: [color],
				variants: args.variants,
				properties: [{name: 'stroke', value: color}],
				pos: Context.currentPos()
			});
		case [colorExpr, intensityExpr]:
			var color = colorExpr.extractCssValue([ColorName]);
			var intensity = intensityExpr.extractCssValue([Integer]);
			createRule({
				prefix: 'stroke',
				type: [color, intensity],
				variants: args.variants,
				properties: [{name: 'stroke', value: parseColor(color, intensity)}],
				pos: Context.currentPos()
			});
		default:
			Context.error('Expected 1 or 2 arguments', Context.currentPos());
	}
}

function strokeWidth(...exprs:Expr) {
	return createSimpleRule('stroke-width', exprs, [Integer]);
}