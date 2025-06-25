package breeze.rule;

import breeze.core.Registry;
import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Transition {
	public static function transition(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		return switch args.args {
			case []:
				createRule({
					prefix: 'transition',
					type: [],
					variants: args.variants,
					properties: [
						{
							name: 'transition-property',
							value: 'color, background-color, border-color, text-decoration-color, fill, stroke, opacity, box-shadow, transform, filter, backdrop-filter'
						},
						{name: 'transition-timing-function', value: 'cubic-bezier(0.4, 0, 0.2, 1)'},
						{name: 'transition-duration', value: '150ms'}
					],
					pos: Context.currentPos()
				});
			case [expr]:
				var type = expr.extractCssValue([Word(['none', 'all', 'colors', 'opacity', 'shadow', 'transform'])]);
				createRule({
					prefix: 'transition',
					type: [type],
					variants: args.variants,
					properties: switch type {
						case 'none':
							[{name: 'transition-property', value: 'none'}];
						default:
							[
								{
									name: 'transition-property',
									value: switch type {
										case 'colors':
											'color, background-color, border-color, text-decoration-color, fill, stroke';
										case 'shadow':
											'box-shadow';
										case type:
											type;
									}
								},
								{name: 'transition-timing-function', value: 'cubic-bezier(0.4, 0, 0.2, 1)'},
								{name: 'transition-duration', value: '150ms'}
							];
					},
					pos: Context.currentPos()
				});
			default:
				Context.error('Expected 0 or 1 argument', Context.currentPos());
		}
	}

	public static function duration(...exprs:Expr):Expr {
		return createSimpleRule('duration', exprs, [Integer], {
			property: 'transition-duration',
			process: value -> value + 'ms'
		});
	}

	public static function ease(...exprs:Expr):Expr {
		return createSimpleRule('ease', exprs, [Word(['in', 'out', 'linear', 'in-out'])], {
			property: 'transition-timing-function',
			process: value -> switch value {
				case 'linear': 'linear';
				case 'in': 'cubic-bezier(0.4, 0, 1, 1)';
				case 'out': 'cubic-bezier(0, 0, 0.2, 1)';
				default: 'cubic-bezier(0.4, 0, 0.2, 1)'; // in-out
			}
		});
	}

	public static function delay(...exprs:Expr):Expr {
		return createSimpleRule('delay', exprs, [Integer], {
			property: 'transition-delay',
			process: value -> value + 'ms'
		});
	}

	public static function animation(...exprs:Expr):Expr {
		var config = Config.instance();
		var animations = config.animations;
		var keyframes = config.keyframes;
		var animationNames = [for (name in animations.keys()) name];
		var args = prepareArguments(exprs);
		return switch args.args {
			case [nameExpr]:
				var name = nameExpr.extractCssValue([Word(animationNames)]);
				var animation = animations.get(name);
				var frames = keyframes.get(name);
				if (frames == null) {
					Context.error('No keyframes exist for the animation $name', Context.currentPos());
				}
				var exprs = [
					registerKeyframes(name, frames, Context.currentPos()),
					createRule({
						prefix: 'animation',
						type: [name],
						variants: args.variants,
						properties: [{name: 'animation', value: '$name $animation'}],
						pos: Context.currentPos()
					})
				];
				return macro breeze.ClassName.ofArray([$a{exprs}]);
			default:
				Context.error('Expected 1 argument', Context.currentPos());
		}
	}

	public static function registerKeyframes(name:String, keyframes:Map<String, String>, pos:Position):Expr {
		var id = 'keyframe_$name';
		var css = '@keyframes $name { ' + [
			for (key => value in keyframes) {
				'$key { $value }';
			}
		].join(' ') + ' }';
		return registerRawCss(id, css, pos);
	}
}
