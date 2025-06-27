package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.Rule;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Effect {
	public static function shadow(...exprs:Expr):Expr {
		var shadows = Config.instance().shadows;
		var keys = [for (key => _ in shadows) key];
		return Rule.simple('shadow', exprs, [Word(keys)], {
			property: 'box-shadow',
			process: key -> {
				if (!shadows.exists(key)) {
					Context.error('Unknown shadow value: $key', Context.currentPos());
				}
				shadows.get(key);
			}
		});
	}

	public static function shadowColor(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [colorExpr]:
				var color = colorExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
				Rule.create({
					prefix: 'shadow-color',
					type: [color],
					variants: args.variants,
					properties: [{name: '--bz-shadow-color', value: color}],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				Rule.create({
					prefix: 'shadow-color',
					type: [color, intensity],
					variants: args.variants,
					properties: [{name: '--bz-shadow-color', value: parseColor(color, intensity)}],
					pos: Context.currentPos()
				});
			default:
				Context.error('Expected 1 to 2 arguments', Context.currentPos());
		}
	}

	public static function opacity(...exprs:Expr):Expr {
		return Rule.simple('opacity', exprs, [Integer], {
			process: value -> {
				var int = Std.parseInt(value);
				var float:Float = int == 1 ? 1 : int / 100;
				return Std.string(float);
			}
		});
	}

	public static function mixBlend(...exprs:Expr):Expr {
		return Rule.simple('mix-blend', exprs, [
			Word([
				'normal',
				'multiply',
				'screen',
				'overlay',
				'darken',
				'lighten',
				'color-dodge',
				'color-burn',
				'hard-light',
				'soft-light',
				'difference',
				'exclusion',
				'hue',
				'saturation',
				'color',
				'luminosity'
			])
		], {
			property: 'mix-blend-mode'
		});
	}

	public static function bgBlend(...exprs:Expr):Expr {
		return Rule.simple('bg-blend', exprs, [
			Word([
				'normal',
				'multiply',
				'screen',
				'overlay',
				'darken',
				'lighten',
				'color-dodge',
				'color-burn',
				'hard-light',
				'soft-light',
				'difference',
				'exclusion',
				'hue',
				'saturation',
				'color',
				'luminosity'
			])
		], {
			property: 'background-blend-mode'
		});
	}
}
