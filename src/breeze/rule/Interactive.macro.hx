package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.RuleBuilder;
import breeze.core.ErrorTools;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

function accentColor(...exprs:Expr):Expr {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [expr]:
			var value = expr.extractCssValue([Word(['inherit', 'currentColor', 'transparent'])]);
			createRule({
				prefix: 'accent',
				type: [value],
				variants: args.variants,
				properties: [{name: 'accent-color', value: value}],
				pos: Context.currentPos()
			});
		case [colorExpr, intensityExpr]:
			var color = colorExpr.extractCssValue([ColorName]);
			var intensity = intensityExpr.extractCssValue([Integer]);
			createRule({
				prefix: 'accent',
				type: [color, intensity],
				variants: args.variants,
				properties: [{name: 'accent-color', value: parseColor(color, intensity)}],
				pos: Context.currentPos()
			});
		default:
			expectedArguments(1, 2);
	}
}

function appearance(...exprs:Expr) {
	return createSimpleRule('appearance', exprs, [Word(['none'])]);
}

function cursor(...exprs:Expr) {
	return createSimpleRule('cursor', exprs, [
		Word([
			'auto', 'default', 'pointer', 'wait', 'text', 'move', 'help', 'not-allowed', 'none', 'context-menu', 'progress', 'cell', 'crosshair',
			'vertical-text',
			'alias', 'copy', 'no-drop', 'grab', 'grabbing', 'alt-scroll', 'col-resize', 'n-resize', 'e-resize', 's-resize', 'w-resize', 'ne-resize',
			'nw-resize',
			'se-resize', 'sw-resize', 'ew-resize', 'ns-resize', 'nwse-resize', 'zoom-in', 'zoom-out'
		])
	]);
}

function caretColor(...exprs:Expr) {
	var args = prepareArguments(exprs);
	return switch args.args {
		case [expr]:
			var value = expr.extractCssValue([Word(['inherit', 'currentColor', 'transparent'])]);
			createRule({
				prefix: 'caret',
				type: [value],
				variants: args.variants,
				properties: [{name: 'caret-color', value: value}],
				pos: Context.currentPos()
			});
		case [colorExpr, intensityExpr]:
			var color = colorExpr.extractCssValue([ColorName]);
			var intensity = intensityExpr.extractCssValue([Integer]);
			createRule({
				prefix: 'caret',
				type: [color, intensity],
				variants: args.variants,
				properties: [{name: 'caret-color', value: parseColor(color, intensity)}],
				pos: Context.currentPos()
			});
		default:
			expectedArguments(1, 2);
	}
}

function pointerEvents(...exprs:Expr) {
	return createSimpleRule('pointer-events', exprs, [Word(['none', 'auto'])]);
}

function resize(...exprs:Expr) {
	return createSimpleRule('resize', exprs, [Word(['none', 'vertical', 'horizontal', 'both'])]);
}

function scrollBehavior(...exprs:Expr) {
	return createSimpleRule('scroll-behavior', exprs, [Word(['smooth', 'auto'])]);
}

function scrollMargin(...exprs:Expr) {
	// @todo: https://tailwindcss.com/docs/scroll-margin
	throw 'todo';
}

function scrollPadding(...exprs:Expr) {
	// @todo https://tailwindcss.com/docs/scroll-padding
	throw 'todo';
}

function scrollSnapAlign(...exprs:Expr) {
	return createSimpleRule('scroll-snap-align', exprs, [Word(['none', 'start', 'end', 'center'])]);
}

function scrollSnapStop(...exprs:Expr) {
	return createSimpleRule('scroll-snap-stop', exprs, [Word(['normal', 'always'])]);
}

function scrollSnapType(...exprs:Expr) {
	// @todo: https://tailwindcss.com/docs/scroll-snap-type
	throw 'todo';
}

function touch(...exprs:Expr) {
	return createSimpleRule('touch-action', exprs, [
		Word([
			'auto', 'none', 'pan-x', 'pan-left', 'pan-right', 'pan-y', 'pan-up', 'pan-down', 'pinch-zoom', 'manipulation'
		])
	]);
}

function userSelect(...exprs:Expr) {
	return createSimpleRule('user-select', exprs, [Word(['none', 'text', 'all', 'auto'])]);
}

function willChange(...exprs:Expr) {
	return createSimpleRule('will-change', exprs, [Word(['auto', 'scroll-position', 'contents', 'transform'])]);
}
