package breeze.rule;

import breeze.core.Rule;
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

	public static function basis(...exprs:Expr):Expr {
		return Rule.simple('flex-basis', exprs, [Unit]);
	}

	public static function direction(...exprs:Expr):Expr {
		return Rule.simple('flex-direction', exprs, [Word(['row', 'row-reverse', 'column', 'column-reverse'])]);
	}

	public static function wrap(...exprs:Expr):Expr {
		return Rule.simple('flex-wrap', exprs, [Word(['wrap', 'wrap-reverse', 'nowrap'])]);
	}

	public static function define(...exprs:Expr):Expr {
		return Rule.simple('flex', exprs, [Word(['auto', 'initial', 'none']), Integer], {
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
	public static function grow(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case []:
				return Rule.create({
					prefix: 'flx-grow',
					variants: args.variants,
					properties: [{name: 'flex-grow', value: '1'}],
					pos: Context.currentPos()
				});
			case [valueExpr]:
				var value = valueExpr.extractCssValue([Integer]);
				return Rule.create({
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
	public static function shrink(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case []:
				return Rule.create({
					prefix: 'flx-shrink',
					variants: args.variants,
					properties: [{name: 'flex-shrink', value: '1'}],
					pos: Context.currentPos()
				});
			case [valueExpr]:
				var value = valueExpr.extractCssValue([Integer]);
				return Rule.create({
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

	public static function order(...exprs:Expr):Expr {
		return Rule.simple('flex-order', exprs, [Integer], {property: 'order'});
	}

	public static function justify(...exprs:Expr):Expr {
		return Rule.simple('justify', exprs, [
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

	public static function justifyItems(...exprs:Expr):Expr {
		return Rule.simple('justify-items', exprs, [Word(['start', 'end', 'center', 'stretch'])]);
	}

	public static function justifySelf(...exprs:Expr):Expr {
		return Rule.simple('justify-self', exprs, [Word(['auto', 'start', 'end', 'center', 'stretch'])]);
	}

	public static function align(...exprs:Expr):Expr {
		return Rule.simple('align', exprs, [
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

	public static function alignItems(...exprs:Expr):Expr {
		return Rule.simple('align-items', exprs, [Word(['start', 'end', 'center', 'baseline', 'stretch'])], {
			process: value -> switch value {
				case 'start' | 'end': 'flex-$value';
				default: value;
			}
		});
	}

	public static function alignSelf(...exprs:Expr):Expr {
		return Rule.simple('align-self', exprs, [Word(['start', 'end', 'center', 'baseline', 'stretch'])], {
			process: value -> switch value {
				case 'start' | 'end': 'flex-$value';
				default: value;
			}
		});
	}

	public static function gap(...exprs:Expr):Expr {
		return Rule.simple('gap', exprs, [Unit]);
	}
}
