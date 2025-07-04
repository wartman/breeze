package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.Rule;
import breeze.core.ErrorTools;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Interactive {
	public static function accentColor(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [expr]:
				var value = expr.extractCssValue([Word(['inherit', 'currentColor', 'transparent'])]);
				Rule.create({
					prefix: 'accent',
					type: [value],
					variants: args.variants,
					properties: [{name: 'accent-color', value: value}],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				Rule.create({
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

	public static function appearance(...exprs:Expr):Expr {
		return Rule.simple('appearance', exprs, [Word(['none'])]);
	}

	public static function cursor(...exprs:Expr):Expr {
		return Rule.simple('cursor', exprs, [
			Word([
				'auto', 'default', 'pointer', 'wait', 'text', 'move', 'help', 'not-allowed', 'none', 'context-menu', 'progress', 'cell', 'crosshair',
				'vertical-text', 'alias', 'copy', 'no-drop', 'grab', 'grabbing', 'alt-scroll', 'col-resize', 'n-resize', 'e-resize', 's-resize', 'w-resize',
				'ne-resize', 'nw-resize', 'se-resize', 'sw-resize', 'ew-resize', 'ns-resize', 'nwse-resize', 'zoom-in', 'zoom-out'
			])
		]);
	}

	public static function caretColor(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [expr]:
				var value = expr.extractCssValue([Word(['inherit', 'currentColor', 'transparent'])]);
				Rule.create({
					prefix: 'caret',
					type: [value],
					variants: args.variants,
					properties: [{name: 'caret-color', value: value}],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				Rule.create({
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

	public static function pointerEvents(...exprs:Expr):Expr {
		return Rule.simple('pointer-events', exprs, [Word(['none', 'auto'])]);
	}

	public static function resize(...exprs:Expr):Expr {
		return Rule.simple('resize', exprs, [Word(['none', 'vertical', 'horizontal', 'both'])]);
	}

	public static function scrollBehavior(...exprs:Expr):Expr {
		return Rule.simple('scroll-behavior', exprs, [Word(['smooth', 'auto'])]);
	}

	public static function scrollMargin(...exprs:Expr):Expr {
		// @todo: https://tailwindcss.com/docs/scroll-margin
		throw 'todo';
	}

	public static function scrollPadding(...exprs:Expr):Expr {
		// @todo https://tailwindcss.com/docs/scroll-padding
		throw 'todo';
	}

	public static function scrollSnapAlign(...exprs:Expr):Expr {
		return Rule.simple('scroll-snap-align', exprs, [Word(['none', 'start', 'end', 'center'])]);
	}

	public static function scrollSnapStop(...exprs:Expr):Expr {
		return Rule.simple('scroll-snap-stop', exprs, [Word(['normal', 'always'])]);
	}

	public static function scrollSnapType(...exprs:Expr):Expr {
		// @todo: https://tailwindcss.com/docs/scroll-snap-type
		throw 'todo';
	}

	public static function touch(...exprs:Expr):Expr {
		return Rule.simple('touch-action', exprs, [
			Word([
				'auto', 'none', 'pan-x', 'pan-left', 'pan-right', 'pan-y', 'pan-up', 'pan-down', 'pinch-zoom', 'manipulation'
			])
		]);
	}

	public static function userSelect(...exprs:Expr):Expr {
		return Rule.simple('user-select', exprs, [Word(['none', 'text', 'all', 'auto'])]);
	}

	public static function willChange(...exprs:Expr):Expr {
		return Rule.simple('will-change', exprs, [Word(['auto', 'scroll-position', 'contents', 'transform'])]);
	}
}
