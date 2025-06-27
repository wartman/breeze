package breeze.rule;

import breeze.core.ErrorTools;
import breeze.core.Rule;
import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;
using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Transform {
	public static function scale(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [scaleExpr]:
				var scale = scaleExpr.extractCssValue([Number]);
				Rule.create({
					prefix: 'scale',
					type: [scale],
					variants: args.variants,
					properties: [{name: 'transform', value: 'scale($scale)'}],
					pos: Context.currentPos()
				});
			case [directionExpr, scaleExpr]:
				var direction = directionExpr.extractCssValue([Word(['x', 'y'])]);
				var scale = scaleExpr.extractCssValue([Number]);
				Rule.create({
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

	public static function rotate(...exprs:Expr):Expr {
		return Rule.simple('rotate', exprs, [Integer], {
			property: 'transform',
			process: value -> 'rotate(${value}deg)'
		});
	}

	public static function translate(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [directionExpr, translateExpr]:
				var direction = directionExpr.extractCssValue([Word(['x', 'y'])]);
				var translate = translateExpr.extractCssValue([Unit]);
				Rule.create({
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

	public static function skew(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [directionExpr, skewExpr]:
				var direction = directionExpr.extractCssValue([Word(['x', 'y'])]);
				var skew = skewExpr.extractCssValue([Unit]);
				Rule.create({
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

	public static function origin(...exprs:Expr):Expr {
		return Rule.simple('origin', exprs, [
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
}
