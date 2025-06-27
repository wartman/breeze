package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.Rule;
import breeze.core.ErrorTools;
import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;
using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Background {
	public static function attachment(...exprs:Expr):Expr {
		return Rule.simple('bg', exprs, [Word(['fixed', 'local', 'scroll'])], {
			property: 'background-attachment'
		});
	}

	public static function clip(...exprs:Expr):Expr {
		return Rule.simple('bg-clip', exprs, [Word(['border', 'padding', 'content', 'text'])], {
			property: 'background-clip',
			process: value -> switch value {
				case 'text': 'text';
				default: '$value-box';
			}
		});
	}

	public static function color(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [colorExpr]:
				var color = colorExpr.extractCssValue([Word(['inherit', 'currentColor', 'transparent']), ColorExpr]);
				Rule.create({
					prefix: 'bg',
					type: [color.sanitizeClassName()],
					variants: args.variants,
					properties: [{name: 'background-color', value: color}],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				Rule.create({
					prefix: 'bg',
					type: [color, intensity],
					variants: args.variants,
					properties: [{name: 'background-color', value: parseColor(color, intensity)}],
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1, 2);
		}
	}

	public static function origin(...exprs:Expr):Expr {
		return Rule.simple('bg-origin', exprs, [Word(['border', 'padding', 'context'])], {
			property: 'background-origin',
			process: value -> '$value-box'
		});
	}

	public static function position(...exprs:Expr):Expr {
		return Rule.simple('bg', exprs, [
			Word([
				'bottom',
				'top',
				'center',
				'left',
				'left-bottom',
				'left-top',
				'right',
				'right-bottom',
				'right-top'
			])
		], {
			property: 'background-position',
			process: value -> value.replace('-', ' ')
		});
	}

	public static function repeat(...exprs:Expr):Expr {
		return Rule.simple('bg-repeat', exprs, [Word(['repeat', 'no-repeat', 'repeat-x', 'repeat-y', 'round', 'space'])], {
			property: 'background-repeat'
		});
	}

	public static function size(...exprs:Expr):Expr {
		return Rule.simple('bg', exprs, [Word(['auto', 'cover', 'contain'])], {property: 'background-size'});
	}

	public static function image(...exprs:Expr):Expr {
		return Rule.simple('bg-img', exprs, [All], {
			property: 'background-image',
			process: value -> 'url($value)'
		});
	}
}
