package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.Rule;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Svg {
	public static function fill(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [colorExpr]:
				var color = colorExpr.extractCssValue([Word(['none', 'inherit', 'currentColor', 'transparent']), ColorExpr]);
				Rule.create({
					prefix: 'fill',
					type: [color],
					variants: args.variants,
					properties: [{name: 'fill', value: color}],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				Rule.create({
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

	public static function stroke(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [colorExpr]:
				var color = colorExpr.extractCssValue([Word(['none', 'inherit', 'currentColor', 'transparent']), ColorExpr]);
				Rule.create({
					prefix: 'stroke',
					type: [color],
					variants: args.variants,
					properties: [{name: 'stroke', value: color}],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				Rule.create({
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

	public static function strokeWidth(...exprs:Expr):Expr {
		return Rule.simple('stroke-width', exprs, [Integer]);
	}
}
