package breeze.rule;

import breeze.core.Rule;
import breeze.core.ErrorTools;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Grid {
	public static function display(...exprs:Expr):Expr {
		var exprs = exprs.toArray();
		exprs.unshift(macro 'grid');
		return Layout.display(...exprs);
	}

	macro public static function gap(...exprs:Expr):Expr {
		return Flex.gap(...exprs);
	}

	public static function columns(...exprs:Expr):Expr {
		return Rule.simple('grid-cols', exprs, [Word(['none']), Integer], {
			property: 'grid-template-columns',
			process: value -> switch value {
				case 'none': 'none';
				case value: 'repeat($value, minmax(0, 1fr))';
			}
		});
	}

	public static function column(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [valueExpr]:
				var value = valueExpr.extractCssValue([Word(['auto', 'full']), Integer]);
				return Rule.create({
					prefix: 'grid-col',
					type: [value],
					variants: args.variants,
					properties: [
						{
							name: 'grid-column',
							value: switch value {
								case 'auto': 'auto';
								case 'full': '1 / -1';
								case other: 'span $other / span $other';
							}
						}
					],
					pos: valueExpr.pos
				});
			case [sideExpr, valueExpr]:
				var side = sideExpr.extractCssValue([Word(['start', 'end'])]);
				var value = valueExpr.extractCssValue([Word(['auto']), Integer]);
				return Rule.create({
					prefix: 'grid-col',
					type: [side, value],
					variants: args.variants,
					properties: [{name: 'grid-column-$side', value: value}],
					pos: valueExpr.pos
				});
			default:
				expectedArguments(1, 2);
		}
	}

	public static function rows(...exprs:Expr):Expr {
		return Rule.simple('grid-rows', exprs, [Word(['none']), Integer], {
			property: 'grid-template-rows',
			process: value -> switch value {
				case 'none': 'none';
				case value: 'repeat($value, minmax(0, 1fr))';
			}
		});
	}

	public static function row(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [valueExpr]:
				var value = valueExpr.extractCssValue([Word(['auto', 'full']), Integer]);
				return Rule.create({
					prefix: 'grid-row',
					type: [value],
					variants: args.variants,
					properties: [
						{
							name: 'grid-row',
							value: switch value {
								case 'auto': 'auto';
								case 'full': '1 / -1';
								case other: 'span $other / span $other';
							}
						}
					],
					pos: valueExpr.pos
				});
			case [sideExpr, valueExpr]:
				var side = sideExpr.extractCssValue([Word(['start', 'end'])]);
				var value = valueExpr.extractCssValue([Word(['auto']), Integer]);
				return Rule.create({
					prefix: 'grid-row',
					type: [side, value],
					variants: args.variants,
					properties: [{name: 'grid-row-$side', value: value}],
					pos: valueExpr.pos
				});
			default:
				expectedArguments(1, 2);
		}
	}

	public static function flow(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [valueExpr]:
				var value = valueExpr.extractCssValue([Word(['row', 'column', 'dense'])]);
				return Rule.create({
					prefix: 'grid-flow',
					type: [value],
					variants: args.variants,
					properties: [{name: 'grid-auto-flow', value: value}],
					pos: valueExpr.pos
				});
			case [targetExpr, valueExpr]:
				var target = targetExpr.extractCssValue([Word(['row', 'column'])]);
				var value = valueExpr.extractCssValue([Word(['dense'])]);
				return Rule.create({
					prefix: 'grid-flow',
					type: [target, value],
					variants: args.variants,
					properties: [{name: 'grid-auto-flow', value: '$target $value'}],
					pos: valueExpr.pos
				});
			default:
				expectedArguments(1, 2);
		}
	}

	public static function autoColumns(...exprs:Expr):Expr {
		return Rule.simple('grid-auto-columns', exprs, [Word(['auto', 'min', 'max']), Integer], {
			process: value -> switch value {
				case 'min': 'min-content';
				case 'max': 'max-content';
				case 'auto': 'auto';
				case fr: 'minmax(0, ${fr}fr)';
			}
		});
	}

	public static function autoRows(...exprs:Expr):Expr {
		return Rule.simple('grid-auto-rows', exprs, [Word(['auto', 'min', 'max']), Integer], {
			process: value -> switch value {
				case 'min': 'min-content';
				case 'max': 'max-content';
				case 'auto': 'auto';
				case fr: 'minmax(0, ${fr}fr)';
			}
		});
	}
}
