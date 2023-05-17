package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;
using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

function bgAttachment(...exprs:Expr) {
	return createSimpleRule('bg', exprs, [Word(['fixed', 'local', 'scroll'])], {
		property: 'background-attachment'
	});
}

function bgClip(...exprs:Expr) {
	return createSimpleRule('bg-clip', exprs, [Word(['border', 'padding', 'content', 'text'])], {
		property: 'background-clip',
		process: value -> switch value {
			case 'text': 'text';
			default: '$value-box';
		}
	});
}

function bgColor(...exprs:Expr):Expr {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [colorExpr]:
			var color = colorExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
			createRule({
				prefix: 'bg',
				type: [color],
				variants: args.variants,
				properties: [{name: 'background-color', value: color}],
				pos: Context.currentPos()
			});
		case [colorExpr, intensityExpr]:
			var color = colorExpr.extractCssValue([ColorName]);
			var intensity = intensityExpr.extractCssValue([Integer]);
			createRule({
				prefix: 'bg',
				type: [color, intensity],
				variants: args.variants,
				properties: [{name: 'background-color', value: parseColor(color, intensity)}],
				pos: Context.currentPos()
			});
		default:
			Context.error('Expected 1 to 2 arguments', Context.currentPos());
	}
}

function bgOrigin(...exprs:Expr) {
	return createSimpleRule('bg-origin', exprs, [Word(['border', 'padding', 'context'])], {
		property: 'background-origin',
		process: value -> '$value-box'
	});
}

function bgPosition(...exprs:Expr) {
	return createSimpleRule('bg', exprs, [
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

function bgRepeat(...exprs:Expr) {
	return createSimpleRule('bg-repeat', exprs, [Word(['repeat', 'no-repeat', 'repeat-x', 'repeat-y', 'round', 'space'])], {
		property: 'background-repeat'
	});
}

function bgSize(...exprs:Expr) {
	return createSimpleRule('bg', exprs, [Word(['auto', 'cover', 'contain'])], {property: 'background-size'});
}

function bgImage(...exprs:Expr) {
	throw 'not yet';
}
