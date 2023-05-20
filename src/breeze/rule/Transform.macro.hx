package breeze.rule;

import breeze.core.ErrorTools;
import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;
using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

function scale(...exprs:Expr):Expr {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [scaleExpr]:
			var scale = scaleExpr.extractCssValue([Number]);
			createRule({
				prefix: 'scale',
				type: [scale],
				variants: args.variants,
				properties: [{name: 'transform', value: 'scale($scale)'}],
				pos: Context.currentPos()
			});
		case [directionExpr, scaleExpr]:
			var direction = directionExpr.extractCssValue([Word(['x', 'y'])]);
			var scale = scaleExpr.extractCssValue([Number]);
			createRule({
				prefix: 'scale',
				type: [direction, scale],
				variants: args.variants,
				properties: [{name: 'transform', value: 'scale${direction.toUpperCase()}($scale)'}],
				pos: Context.currentPos()
			});
		default:
			expectedArguments(1, 2);
	}
}

function rotate(...exprs:Expr) {
	return createSimpleRule('rotate', exprs, [Integer], {
		property: 'transform',
		process: value -> 'rotate(${value}deg)'
	});
}

function translate(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [directionExpr, translateExpr]:
			var direction = directionExpr.extractCssValue([Word(['x', 'y'])]);
			var translate = translateExpr.extractCssValue([Unit]);
			createRule({
				prefix: 'translate',
				type: [direction, translate],
				variants: args.variants,
				properties: [{name: 'transform', value: 'translate${direction.toUpperCase()}($translate)'}],
				pos: Context.currentPos()
			});
		default:
			expectedArguments(2);
	}
}

function skew(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [directionExpr, skewExpr]:
			var direction = directionExpr.extractCssValue([Word(['x', 'y'])]);
			var skew = skewExpr.extractCssValue([Unit]);
			createRule({
				prefix: 'skew',
				type: [direction, skew],
				variants: args.variants,
				properties: [{name: 'transform', value: 'skew${direction.toUpperCase()}($translate)'}],
				pos: Context.currentPos()
			});
		default:
			expectedArguments(2);
	}
}

function origin(...exprs:Expr) {
	return createSimpleRule('origin', exprs, [
		Word([
			'center',
			'top',
			'right',
			'bottom',
			'bottom right',
			'top right',
			'bottom left',
			'top left'
		])
	], {
		property: 'transform-origin'
	});
}
