package breeze.rule;

import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Sizing {
	public static function width(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		var allowedWords = ['full', 'screen', 'min', 'max', 'fit', 'auto'];
		var process = value -> switch value {
			case 'min' | 'max' | 'fit': '$value-content';
			case 'screen': '100vw';
			case 'full': '100%';
			default: value;
		}
		return switch args.args {
			case [value]:
				createSizingRule('width', null, value, args.variants, allowedWords, process);
			case [constraint, value]:
				createSizingRule('width', constraint, value, args.variants, allowedWords, process);
			default:
				Context.error('Expected 1 or 2 arguments', Context.currentPos());
		}
	}

	public static function height(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		var allowedWords = ['full', 'screen', 'min', 'max', 'fit', 'auto'];
		var process = value -> switch value {
			case 'min' | 'max' | 'fit': '$value-content';
			case 'screen': '100vh';
			case 'full': '100%';
			default: value;
		}
		return switch args.args {
			case [value]:
				createSizingRule('height', null, value, args.variants, allowedWords, process);
			case [constraint, value]:
				createSizingRule('height', constraint, value, args.variants, allowedWords, process);
			default:
				Context.error('Expected 1 or 2 arguments', Context.currentPos());
		}
	}
}

private function createSizingRule(direction:String, constraintExpr:Null<Expr>, valueExpr:Expr, variants:Array<String>, allowedWords:Array<String>,
		processValue:(value:String) -> String) {
	var constraint = constraintExpr?.extractCssValue([Word(['min', 'max'])]);
	var value = valueExpr.extractCssValue([Unit, Word(allowedWords)]);
	return createRule({
		prefix: direction,
		type: [constraint, value].filter(v -> v != null),
		variants: variants,
		properties: [
			{
				name: switch constraint {
					case null: direction;
					default: '$constraint-$direction';
				},
				value: processValue(value)
			}
		],
		pos: Context.currentPos()
	});
}
