package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.Rule;
import breeze.core.ErrorTools;
import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;
using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Typography {
	public static function font(...exprs:Expr):Expr {
		var fontConfig = Config.instance().fontFamilies;
		var names = [for (name in fontConfig.keys()) name];
		return Rule.simple('font', exprs, [Word(names)], {
			property: 'font-family',
			process: name -> {
				var value = fontConfig.get(name);
				if (value == null) Context.error('Invalid font name: $name', Context.currentPos());
				return value;
			}
		});
	}

	public static function fontSize(...exprs:Expr):Expr {
		var fontSizes = Config.instance().fontSizes;
		var names = [for (name in fontSizes.keys()) name];
		var args:Arguments = exprs;
		return switch args.exprs {
			case [size]:
				var name = size.extractCssValue([Word(names)]);
				var info = fontSizes.get(name);
				if (info == null) {
					Context.error('Invalid font size: $name', Context.currentPos());
				}
				Rule.create({
					prefix: 'font-size',
					type: [name],
					variants: args.variants,
					properties: [
						{name: 'font-size', value: info.size},
						{name: 'line-height', value: info.lineHeight}
					],
					pos: Context.currentPos()
				});
			case [size, lineHeight]:
				var name = size.extractCssValue([Word(names)]);
				var lh = lineHeight.extractCssValue([Unit]);
				var info = fontSizes.get(name);
				if (info == null) {
					Context.error('Invalid font size: $name', Context.currentPos());
				}
				Rule.create({
					prefix: 'font-size',
					type: [name, lh],
					variants: args.variants,
					properties: [{name: 'font-size', value: info.size}, {name: 'line-height', value: lh}],
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1, 2);
		}
	}

	public static function fontSmoothing(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [smoothingExpr]:
				var smoothing = smoothingExpr.extractCssValue([Word(['antialiased', 'subpixel-antialiased'])]);
				return Rule.create({
					prefix: 'font-smoothing',
					type: [smoothing],
					variants: args.variants,
					pos: Context.currentPos(),
					properties: switch smoothing {
						case 'antialiased': [
								{name: '-webkit-font-smoothing', value: 'antialiased'},
								{name: '-moz-osx-font-smoothing', value: 'grayscale'}
							];
						case 'subpixel-antialiased': [
								{name: '-webkit-font-smoothing', value: 'subpixel-antialiased'},
								{name: '-moz-osx-font-smoothing', value: 'auto'}
							];
						default:
							Context.error('Invalid font smoothing: $smoothing', Context.currentPos());
					}
				});
			default:
				expectedArguments(1);
		}
	}

	public static function fontStyle(...exprs:Expr):Expr {
		return Rule.simple('font-style', exprs, [Word(['italic', 'normal'])]);
	}

	public static function fontWeight(...exprs:Expr):Expr {
		var fontWeights = Config.instance().fontWeights;
		var names = [for (name in fontWeights.keys()) name];
		return Rule.simple('font-weight', exprs, [Word(names)], {
			process: name -> {
				var value = fontWeights.get(name);
				if (value == null) {
					Context.error('Invalid font weight: $name', Context.currentPos());
				}
				return value;
			}
		});
	}

	public static function tracking(...exprs:Expr):Expr {
		var tracking = Config.instance().tracking;
		var names = [for (name in tracking.keys()) name];
		return Rule.simple('tracking', exprs, [Word(names)], {
			property: 'letter-spacing',
			process: name -> {
				var value = tracking.get(name);
				if (value == null) {
					Context.error('Invalid tracking: $name', Context.currentPos());
				}
				return value;
			}
		});
	}

	public static function lineClamp(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [linesExpr]:
				var lines = linesExpr.extractCssValue([Integer]);
				Rule.create({
					prefix: 'line-clamp',
					type: [lines],
					variants: args.variants,
					properties: [
						{name: 'overflow', value: 'hidden'},
						{name: 'display', value: '-webkit-box'},
						{name: '-webkit-box-orient', value: 'vertical'},
						{name: '-webkit-line-clamp', value: lines},
						// {name: 'line-clamp', value: lines}
					],
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1);
		}
	}

	public static function leading(...exprs:Expr):Expr {
		var leading = Config.instance().leading;
		var names = [for (name in leading.keys()) name];
		return Rule.simple('leading', exprs, [Word(names)], {
			property: 'line-height',
			process: name -> {
				var value = leading.get(name);
				if (value == null) {
					Context.error('Invalid leading: $name', Context.currentPos());
				}
				return value;
			}
		});
	}

	public static function listStyle(...exprs:Expr):Expr {
		return Rule.simple('list', exprs, [Word(['none', 'disc', 'decimal'])], {
			property: 'list-style-type'
		});
	}

	public static function listPosition(...exprs:Expr):Expr {
		return Rule.simple('list', exprs, [Word(['inside, outside'])], {
			property: 'list-style-position'
		});
	}

	public static function textAlign(...exprs:Expr):Expr {
		return Rule.simple('text', exprs, [Word(['left', 'center', 'right', 'justify', 'start', 'end'])], {
			property: 'text-align'
		});
	}

	public static function textColor(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [colorExpr]:
				var color = colorExpr.extractCssValue([Word(['inherit', 'currentColor', 'transparent']), ColorExpr]);
				Rule.create({
					prefix: 'text-color',
					type: [color.sanitizeClassName()],
					variants: args.variants,
					properties: [{name: 'color', value: color}],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				Rule.create({
					prefix: 'text-color',
					type: [color, intensity],
					variants: args.variants,
					properties: [{name: 'color', value: parseColor(color, intensity)}],
					pos: Context.currentPos()
				});
			default:
				expectedArguments(1, 2);
		}
	}

	public static function textDecoration(...exprs:Expr):Expr {
		return Rule.simple('text-decoration', exprs, [Word(['underline', 'overline', 'line-through', 'none'])]);
	}

	public static function textDecorationColor(...exprs:Expr):Expr {
		return Rule.simple('decoration-color', exprs, [ColorName, ColorExpr, Word(['inherit', 'currentColor', 'transparent'])], {
			property: 'text-decoration-color'
		});
	}

	public static function textDecorationStyle(...exprs:Expr):Expr {
		return Rule.simple('decoration', exprs, [Word(['solid', 'double', 'dotted', 'dashed', 'wavy'])], {
			property: 'text-decoration-style'
		});
	}

	public static function textDecorationThickness(...exprs:Expr):Expr {
		return Rule.simple('decoration', exprs, [Word(['auto', 'form-font']), Integer], {
			property: 'text-decoration-thickness',
			process: value -> switch value {
				case 'auto' | 'from-font': value;
				default: '${value}px';
			}
		});
	}

	public static function textUnderlineOffset(...exprs:Expr):Expr {
		return Rule.simple('underline-offset', exprs, [Word(['auto']), Integer], {
			property: 'text-underline-offset',
			process: value -> switch value {
				case 'auto': value;
				default: '${value}px';
			}
		});
	}

	public static function textTransform(...exprs:Expr):Expr {
		return Rule.simple('transform', exprs, [Word(['uppercase', 'lowercase', 'capitalize', 'none'])], {
			property: 'text-transform'
		});
	}

	public static function textOverflow(...exprs:Expr):Expr {
		return Rule.simple('text-overflow', exprs, [Word(['ellipsis', 'clip'])]);
	}

	public static function textIndent(...exprs:Expr):Expr {
		return Rule.simple('text-indent', exprs, [Unit]);
	}

	public static function textVerticalAlign(...exprs:Expr):Expr {
		return Rule.simple('vertical-align', exprs, [
			Word(['baseline', 'top', 'middle', 'bottom', 'text-top', 'text-bottom', 'sub', 'super'])
		]);
	}

	public static function whitespace(...exprs:Expr):Expr {
		return Rule.simple('whitespace', exprs, [Word(['normal', 'nowrap', 'pre', 'pre-line', 'pre-wrap', 'break-spaces'])], {
			property: 'white-space'
		});
	}

	public static function wordBreak(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case [expr]:
				var type = expr.extractCssValue([Word(['normal', 'words', 'all', 'keep'])]);
				Rule.create({
					prefix: 'beak',
					type: [type],
					variants: args.variants,
					properties: switch type {
						case 'normal': [{name: 'overflow-wrap', value: 'normal'}, {name: 'word-break', value: 'normal'}];
						case other: [
								{
									name: 'word-break',
									value: switch other {
										case 'keep': 'keep-all';
										case 'words': 'break-word';
										case 'all': 'break-all';
										default: Context.error('Invalid value: $type', expr.pos);
									}
								}
							];
					},
					pos: Context.currentPos()
				});
			default:
				Context.error('Expected 1 argument', Context.currentPos());
		}
	}

	public static function hyphens(...exprs:Expr):Expr {
		return Rule.simple('hyphens', exprs, [Word(['none', 'manual', 'auto'])]);
	}

	/**
		Define the content of an element (useful for things like :before).

		This can be any arbitrary value, however be aware that strings will need to be wrapped in quotes.

		For example:

		```haxe
		Typography.content('var(--some-css-var)');
		Typography.content('"Some text"');
		```
	**/
	public static function content(...exprs:Expr):Expr {
		var args:Arguments = exprs;
		return switch args.exprs {
			case []:
				Rule.create({
					prefix: 'content',
					type: ['default'],
					variants: args.variants,
					properties: [
						{name: 'content', value: 'var(--bz-content, "")'}
					],
					pos: Context.currentPos()
				});
			default:
				Rule.simple('content', exprs, [Word(['none']), String]);
		}
	}
}
