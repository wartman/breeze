package breeze.rule;

import breeze.core.RuleBuilder;
import breeze.core.ErrorTools;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.MacroTools;
using breeze.core.CssTools;
using breeze.core.ValueTools;

class Flex {
	public static function display(...exprs:Expr):Expr {
		var exprs = exprs.toArray();
		exprs.unshift(macro 'flex');
		return Layout.display(...exprs);
	}

	public static function basis(...exprs) {
		return createSimpleRule('flex-basis', exprs, [Unit]);
	}

	public static function direction(...exprs) {
		return createSimpleRule('flex-direction', exprs, [Word(['row', 'row-reverse', 'column', 'column-reverse'])]);
	}

	public static function wrap(...exprs) {
		return createSimpleRule('flex-wrap', exprs, [Word(['wrap', 'wrap-reverse', 'nowrap'])]);
	}

	public static function define(...exprs) {
		return createSimpleRule('flex', exprs, [Word(['auto', 'initial', 'none']), Integer], {
			process: value -> switch value {
				case 'auto': '1 1 auto';
				case 'none': 'none';
				case 'initial': '0 1 auto';
				case '1': '1 1 0%';
				case other: '$other $other 0%';
			}
		});
	}

	/**
		Allow a flex item to grow to any space. You can also provide
		an integer that will control how much the flex item will grow.
	**/
	public static function grow(...exprs) {
		var args = prepareArguments(exprs);
		return switch args.args {
			case []:
				return createRule({
					prefix: 'flx-grow',
					variants: args.variants,
					properties: [{name: 'flex-grow', value: '1'}],
					pos: Context.currentPos()
				});
			case [valueExpr]:
				var value = valueExpr.extractCssValue([Integer]);
				return createRule({
					prefix: 'flx-grow',
					type: [value],
					variants: args.variants,
					properties: [{name: 'flex-grow', value: value}],
					pos: valueExpr.pos
				});
			default:
				expectedArguments(0, 1);
		}
	}

	/**
		Allow a flex item to shrink if needed. You can also provide
		an integer that will control how much the flex item will shrink.
	**/
	public static function shrink(...exprs) {
		var args = prepareArguments(exprs);
		return switch args.args {
			case []:
				return createRule({
					prefix: 'flx-shrink',
					variants: args.variants,
					properties: [{name: 'flex-shrink', value: '1'}],
					pos: Context.currentPos()
				});
			case [valueExpr]:
				var value = valueExpr.extractCssValue([Integer]);
				return createRule({
					prefix: 'flx-shrink',
					type: [value],
					variants: args.variants,
					properties: [{name: 'flex-shrink', value: value}],
					pos: valueExpr.pos
				});
			default:
				expectedArguments(0, 1);
		}
	}

	public static function order(...exprs) {
		return createSimpleRule('flex-order', exprs, [Integer], {property: 'order'});
	}

	public static function justify(...exprs:Expr) {
		return createSimpleRule('justify', exprs, [
			Word(['normal', 'start', 'end', 'center', 'between', 'around', 'evenly', 'stretch'])
		], {
			property: 'justify-content',
			process: value -> switch value {
				case 'start' | 'end': 'flex-$value';
				case 'between' | 'around' | 'evenly': 'space-$value';
				case other: other;
			}
		});
	}

	public static function justifyItems(...exprs:Expr) {
		return createSimpleRule('justify-items', exprs, [Word(['start', 'end', 'center', 'stretch'])]);
	}

	public static function justifySelf(...exprs:Expr) {
		return createSimpleRule('justify-self', exprs, [Word(['auto', 'start', 'end', 'center', 'stretch'])]);
	}

	public static function align(...exprs:Expr) {
		return createSimpleRule('align', exprs, [
			Word(['normal', 'start', 'end', 'center', 'between', 'around', 'evenly', 'stretch'])
		], {
			property: 'align-content',
			process: value -> switch value {
				case 'start' | 'end': 'flex-$value';
				case 'between' | 'around' | 'evenly': 'space-$value';
				case other: other;
			}
		});
	}

	public static function alignItems(...exprs:Expr) {
		return createSimpleRule('align-items', exprs, [Word(['start', 'end', 'center', 'baseline', 'stretch'])], {
			process: value -> switch value {
				case 'start' | 'end': 'flex-$value';
				default: value;
			}
		});
	}

	public static function alignSelf(...exprs:Expr) {
		return createSimpleRule('align-self', exprs, [Word(['start', 'end', 'center', 'baseline', 'stretch'])], {
			process: value -> switch value {
				case 'start' | 'end': 'flex-$value';
				default: value;
			}
		});
	}

	public static function gap(...exprs:Expr) {
		return createSimpleRule('gap', exprs, [Unit]);
	}
}
