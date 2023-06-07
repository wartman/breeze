package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.ErrorTools;
import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Border {
	public static function radius(...exprs:Expr):Expr {
		return createSimpleRule('border-radius', exprs, [Unit]);
	}

	public static function width(...exprs:Expr):Expr {
		// @todo: DRY up directions stuff
		var directions = ['top', 'right', 'bottom', 'left', 'x', 'y'];
		var args = prepareArguments(exprs);

		return switch args.args {
			case [expr]:
				var width = expr.extractCssValue([Unit]);
				createRule({
					prefix: 'border',
					type: [width],
					priority: 2,
					variants: args.variants,
					properties: [{name: 'border-width', value: width}],
					pos: Context.currentPos()
				});
			case [directionExpr, widthExpr]:
				var direction = directionExpr.extractCssValue([Word(directions)]);
				var width = widthExpr.extractCssValue([Unit]);
				createRule({
					prefix: 'border',
					type: [direction, width],
					priority: 1,
					variants: args.variants,
					properties: switch direction {
						case 'x':
							[
								{name: 'border-left-width', value: width},
								{name: 'border-right-width', value: width}
							];
						case 'y':
							[
								{name: 'border-top-width', value: width},
								{name: 'border-bottom-width', value: width}
							];
						default:
							[{name: 'border-${direction}-width', value: width}];
					},
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1, 2);
		}
	}

	public static function style(...exprs:Expr):Expr {
		// @todo: DRY up directions stuff
		var directions = ['top', 'right', 'bottom', 'left', 'x', 'y'];
		var styles = ['solid', 'dashed', 'dotted', 'double', 'hidden', 'none'];
		var args = prepareArguments(exprs);

		return switch args.args {
			case [styleExpr]:
				var style = styleExpr.extractCssValue([Word(styles)]);
				createRule({
					prefix: 'border',
					type: [style],
					priority: 2,
					variants: args.variants,
					properties: [{name: 'border-style', value: style}],
					pos: Context.currentPos()
				});
			case [directionExpr, styleExpr]:
				var direction = directionExpr.extractCssValue([Word(directions)]);
				var style = styleExpr.extractCssValue([Word(styles)]);
				createRule({
					prefix: 'border',
					type: [direction, style],
					priority: 1,
					variants: args.variants,
					properties: switch direction {
						case 'x':
							[
								{name: 'border-left-style', value: style},
								{name: 'border-right-style', value: style}
							];
						case 'y':
							[
								{name: 'border-top-style', value: style},
								{name: 'border-bottom-style', value: style}
							];
						default:
							[{name: 'border-${direction}-style', value: style}];
					},
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1, 2);
		}
	}

	public static function color(...exprs:Expr):Expr {
		// @todo: DRY up directions stuff
		var directions = ['top', 'right', 'bottom', 'left', 'x', 'y'];
		var args = prepareArguments(exprs);

		return switch args.args {
			case [colorExpr]:
				var color = colorExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
				createRule({
					prefix: 'border',
					type: [color],
					priority: 2,
					variants: args.variants,
					properties: [
						{
							name: 'border-color',
							value: switch color {
								case 'current': 'currentColor';
								default: color;
							}
						}
					],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName, Word(directions)]);

				if (directions.contains(color)) {
					var direction = color;
					var color = intensityExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
					return createRule({
						prefix: 'border',
						type: [direction, color],
						priority: 1,
						variants: args.variants,
						properties: switch direction {
							case 'x':
								[
									{name: 'border-left-color', value: color},
									{name: 'border-right-color', value: color}
								];
							case 'y':
								[
									{name: 'border-top-color', value: color},
									{name: 'border-bottom-color', value: color}
								];
							default:
								[{name: 'border-${direction}-color', value: color}];
						},
						pos: Context.currentPos()
					});
				}

				var intensity = intensityExpr.extractCssValue([Integer]);
				createRule({
					prefix: 'border',
					type: [color, intensity],
					priority: 2,
					variants: args.variants,
					properties: [{name: 'border-color', value: parseColor(color, intensity)}],
					pos: Context.currentPos()
				});
			case [directionExpr, colorExpr, intensityExpr]:
				var direction = directionExpr.extractCssValue([Word(directions)]);
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				var value = parseColor(color, intensity);
				return createRule({
					prefix: 'border',
					type: [direction, color, intensity],
					priority: 2,
					variants: args.variants,
					properties: switch direction {
						case 'x':
							[
								{name: 'border-left-color', value: value},
								{name: 'border-right-color', value: value}
							];
						case 'y':
							[
								{name: 'border-top-color', value: value},
								{name: 'border-bottom-color', value: value}
							];
						default:
							[{name: 'border-${direction}-color', value: value}];
					},
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1, 3);
		}
	}

	public static function outlineWidth(...exprs:Expr):Expr {
		return createSimpleRule('outline-width', exprs, [Unit]);
	}

	public static function outlineStyle(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		return switch args.args {
			case [expr]:
				var value = expr.extractCssValue([Word(['none', 'solid', 'dashed', 'dotted', 'double'])]);
				createRule({
					prefix: 'outline',
					type: [value],
					variants: args.variants,
					properties: switch value {
						case 'none': [
								{name: 'outline', value: '2px solid transparent'},
								{name: 'outline-offset', value: '2px'}
							];
						default: [{name: 'outline-style', value: value}];
					},
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1);
		}
	}

	public static function outlineColor(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		return switch args.args {
			case [colorExpr]:
				var color = colorExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
				createRule({
					prefix: 'outline',
					type: [color],
					variants: args.variants,
					properties: [
						{
							name: 'outline-color',
							value: switch color {
								case 'current': 'currentColor';
								default: color;
							}
						}
					],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				createRule({
					prefix: 'outline',
					type: [color, intensity],
					variants: args.variants,
					properties: [{name: 'outline-color', value: parseColor(color, intensity)}],
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1, 2);
		}
	}

	public static function outlineOffset(...exprs:Expr):Expr {
		return createSimpleRule('outline-offset', exprs, [Unit]);
	}

	public static function divideWidth(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		return switch args.args {
			case [directionExpr, sizeExpr]:
				var direction = directionExpr.extractCssValue([Word(['x', 'y'])]);
				var size = sizeExpr.extractCssValue([Unit]);
				createRule({
					prefix: 'divide',
					type: [direction, size],
					variants: args.variants.concat([divideSuffix()]),
					properties: switch direction {
						case 'x': [
								{name: 'border-right-width', value: '0'},
								{name: 'border-left-width', value: size}
							];
						default: [
								{name: 'border-bottom-width', value: '0'},
								{name: 'border-top-width', value: size}
							];
					},
					pos: Context.currentPos()
				});
			default:
				expectedArguments(2);
		}
	}

	public static function divideStyle(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		return switch args.args {
			case [expr]:
				var style = expr.extractCssValue([Word(['none', 'solid', 'dotted', 'dashed', 'double'])]);
				createRule({
					prefix: 'divide',
					type: [style],
					variants: args.variants.concat([divideSuffix()]),
					properties: [{name: 'border-style', value: style}],
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1);
		}
	}

	public static function divideColor(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		return switch args.args {
			case [colorExpr]:
				var color = colorExpr.extractCssValue([Word(['inherit', 'current', 'transparent']), ColorExpr]);
				createRule({
					prefix: 'divide',
					type: [color],
					variants: args.variants.concat([divideSuffix()]),
					properties: [
						{
							name: 'border-color',
							value: switch color {
								case 'current': 'currentColor';
								default: color;
							}
						}
					],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				createRule({
					prefix: 'divide',
					type: [color, intensity],
					variants: args.variants.concat([divideSuffix()]),
					properties: [{name: 'border-color', value: parseColor(color, intensity)}],
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1, 2);
		}
	}

	// public static function ringWidth(...exprs:Expr):Expr {}
	// public static function ringColor(...exprs:Expr):Expr {}
	// public static function ringOffsetWidth(...exprs:Expr):Expr {}
	// public static function ringOffsetColor(...exprs:Expr):Expr {}
}

private function divideSuffix() {
	return maybeRegisterVariant('divide-suffix', entry -> {
		entry.specifiers.push({
			selector: ' > * + *',
			prefix: false
		});
		entry;
	});
}
