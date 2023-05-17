package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

function shadow(...exprs:Expr) {
	createSimpleRule('shadow', exprs, [Word(['sm', 'md', 'lg', 'xl', 'xxl', 'inner', 'none'])], {
		property: 'box-shadow',
		// The following is stolen directly from the TW site:
		process: value -> switch value {
			case 'sm': '0 1px 2px 0 var(--bz-shadow-color, rgb(0 0 0 / 0.05))';
			case 'md': '0 1px 3px 0 var(--bz-shadow-color, rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1))';
			case 'lg': '0 4px 6px -1px var(--bz-shadow-color, rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1))';
			case 'xl': '0 10px 15px -3px var(--bz-shadow-color, rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1))';
			case 'xxl': '0 20px 25px -5px var(--bz-shadow-color, rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1))';
			case 'inner': 'inset 0 2px 4px 0 var(--bz-shadow-color, rgb(0 0 0 / 0.05))';
			case 'none': '0 0 #0000';
			case other: throw 'assert';
		}
	});
}

function shadowColor(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [colorExpr]:
			var color = colorExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
			createRule({
				prefix: 'shadow-color',
				type: [color],
				variants: args.variants,
				properties: [{name: '--bz-shadow-color', value: color}],
				pos: Context.currentPos()
			});
		case [colorExpr, intensityExpr]:
			var color = colorExpr.extractCssValue([ColorName]);
			var intensity = intensityExpr.extractCssValue([Integer]);
			createRule({
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

function opacity(...exprs:Expr) {
	createSimpleRule('opacity', exprs, [Integer], {
		process: value -> {
			var int = Std.parseInt(value);
			var float:Float = int == 1 ? 1 : int / 100;
			return Std.string(float);
		}
	});
}

function mixBlend(...exprs:Expr) {
	throw 'todo';
}

function bgBlend(...exprs:Expr) {
	throw 'todo';
}
