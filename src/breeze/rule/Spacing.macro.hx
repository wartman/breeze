package breeze.rule;

import haxe.macro.Context;
import haxe.macro.Expr;
import breeze.core.Rule;
import breeze.core.ErrorTools;

using breeze.core.ValueTools;
using breeze.core.MacroTools;
using breeze.core.CssTools;

class Spacing {
	public static function pad(...expr:Expr):Expr {
		var args:Arguments = expr;
		return switch args.exprs {
			case [sizeExpr]:
				createSpacingRule('p', 'padding', null, sizeExpr, args.variants);
			case [typeExpr, sizeExpr]:
				createSpacingRule('p', 'padding', typeExpr, sizeExpr, args.variants);
			default:
				expectedArguments(1, 2);
		}
	}

	public static function margin(...expr:Expr):Expr {
		var args:Arguments = expr;
		return switch args.exprs {
			case [sizeExpr]:
				createSpacingRule('m', 'margin', null, sizeExpr, args.variants);
			case [typeExpr, sizeExpr]:
				createSpacingRule('m', 'margin', typeExpr, sizeExpr, args.variants);
			default:
				expectedArguments(1, 2);
		}
	}

	public static function between(...expr:Expr):Expr {
		var args:Arguments = expr;
		return switch args.exprs {
			case [directionExpr, valueExpr]:
				var direction = directionExpr.extractCssValue([Word(['x', 'y'])]);
				var value = valueExpr.extractCssValue([Unit]);
				return Rule.create({
					prefix: 'between',
					type: [direction, value],
					variants: args.variants.concat([
						Variant.create('between-wrapper', css -> {
							css.modifiers.push(' > :not([hidden]) ~ :not([hidden])');
							return css;
						})
					]),
					properties: switch direction {
						case 'x': [{name: 'margin-left', value: value}];
						default: [{name: 'margin-top', value: value}];
					},
					pos: valueExpr.pos
				});
			default:
				expectedArguments(2);
		}
	}
}

private function createSpacingRule(prefix:String, property:String, typeExpr:Null<Expr>, sizeExpr:Expr, variants:Array<VariantIdentifier>) {
	var type = typeExpr?.extractCssValue([Word(['top', 'left', 'bottom', 'right', 'x', 'y'])]);
	var size = sizeExpr.extractCssValue([Word(['auto']), Unit]);
	return Rule.create({
		prefix: prefix,
		type: [type, size],
		priority: type == null ? 1 : 2,
		variants: variants,
		properties: switch type {
			case null: [{name: property, value: size}];
			case 'x': [{name: '$property-left', value: size}, {name: '$property-right', value: size}];
			case 'y': [{name: '$property-top', value: size}, {name: '$property-bottom', value: size}];
			case other: [{name: '$property-$other', value: size}];
		},
		pos: sizeExpr.pos
	});
}
