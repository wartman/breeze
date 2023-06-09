package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.RuleBuilder;
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
		return createSimpleRule('font', exprs, [Word(names)], {
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
		var args = prepareArguments(exprs);
		return switch args.args {
			case [size]:
				var name = size.extractCssValue([Word(names)]);
				var info = fontSizes.get(name);
				if (info == null) {
					Context.error('Invalid font size: $name', Context.currentPos());
				}
				createRule({
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
				createRule({
					prefix: 'font-size',
					type: [name, lh],
					variants: args.variants,
					properties: [{name: 'font-size', value: info.size}, {name: 'line-height', value: lh}],
					pos: Context.currentPos()
				});
			default:
				Context.error('Expected 1 or 2 arguments', Context.currentPos());
		}
	}

	public static function fontSmoothing(...exprs:Expr):Expr {
		throw 'todo';
	}

	public static function fontStyle(...exprs:Expr):Expr {
		return createSimpleRule('font-style', exprs, [Word(['italic', 'normal'])]);
	}

	public static function fontWeight(...exprs:Expr):Expr {
		var fontWeights = Config.instance().fontWeights;
		var names = [for (name in fontWeights.keys()) name];
		return createSimpleRule('font-weight', exprs, [Word(names)], {
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
		return createSimpleRule('tracking', exprs, [Word(names)], {
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
		// https://tailwindcss.com/docs/line-clamp
		throw 'todo';
	}

	public static function leading(...exprs:Expr):Expr {
		var leading = Config.instance().leading;
		var names = [for (name in leading.keys()) name];
		return createSimpleRule('leading', exprs, [Word(names)], {
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
		// https://tailwindcss.com/docs/list-style-image
		throw 'todo';
	}

	public static function listPosition(...exprs:Expr):Expr {
		return createSimpleRule('list', exprs, [Word(['inside, outside'])], {
			property: 'list-style-position'
		});
	}

	public static function textAlign(...exprs:Expr):Expr {
		return createSimpleRule('text', exprs, [Word(['left', 'center', 'right', 'justify', 'start', 'end'])], {
			property: 'text-align'
		});
	}

	public static function textColor(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		return switch args.args {
			case [colorExpr]:
				var color = colorExpr.extractCssValue([Word(['inherit', 'currentColor', 'transparent']), ColorExpr]);
				createRule({
					prefix: 'text-color',
					type: [color.sanitizeClassName()],
					variants: args.variants,
					properties: [{name: 'color', value: color}],
					pos: Context.currentPos()
				});
			case [colorExpr, intensityExpr]:
				var color = colorExpr.extractCssValue([ColorName]);
				var intensity = intensityExpr.extractCssValue([Integer]);
				createRule({
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
		return createSimpleRule('text-decoration', exprs, [Word(['underline', 'overline', 'line-through', 'none'])]);
	}

	public static function textDecorationColor(...exprs:Expr):Expr {
		return createSimpleRule('decoration-color', exprs, [ColorName, ColorExpr, Word(['inherit', 'currentColor', 'transparent'])], {
			property: 'text-decoration-color'
		});
	}

	public static function textDecorationStyle(...exprs:Expr):Expr {
		return createSimpleRule('decoration', exprs, [Word(['solid', 'double', 'dotted', 'dashed', 'wavy'])], {
			property: 'text-decoration-style'
		});
	}

	public static function textDecorationThickness(...exprs:Expr):Expr {
		return createSimpleRule('decoration', exprs, [Word(['auto', 'form-font']), Integer], {
			property: 'text-decoration-thickness',
			process: value -> switch value {
				case 'auto' | 'from-font': value;
				default: '${value}px';
			}
		});
	}

	public static function textUnderlineOffset(...exprs:Expr):Expr {
		return createSimpleRule('underline-offset', exprs, [Word(['auto']), Integer], {
			property: 'text-underline-offset',
			process: value -> switch value {
				case 'auto': value;
				default: '${value}px';
			}
		});
	}

	public static function textTransform(...exprs:Expr):Expr {
		return createSimpleRule('transform', exprs, [Word(['uppercase', 'lowercase', 'capitalize', 'none'])], {
			property: 'text-transform'
		});
	}

	public static function textOverflow(...exprs:Expr):Expr {
		return createSimpleRule('text-overflow', exprs, [Word(['ellipsis', 'clip'])]);
	}

	public static function textIndent(...exprs:Expr):Expr {
		return createSimpleRule('text-indent', exprs, [Unit]);
	}

	public static function textVerticalAlign(...exprs:Expr):Expr {
		return createSimpleRule('vertical-align', exprs, [
			Word(['baseline', 'top', 'middle', 'bottom', 'text-top', 'text-bottom', 'sub', 'super'])
		]);
	}

	public static function whitespace(...exprs:Expr):Expr {
		return createSimpleRule('whitespace', exprs, [Word(['normal', 'nowrap', 'pre', 'pre-line', 'pre-wrap', 'break-spaces'])], {
			property: 'white-space'
		});
	}

	public static function wordBreak(...exprs:Expr):Expr {
		var args = prepareArguments(exprs);
		return switch args.args {
			case [expr]:
				var type = expr.extractCssValue([Word(['normal', 'words', 'all', 'keep'])]);
				createRule({
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
		return createSimpleRule('hyphens', exprs, [Word(['none', 'manual', 'auto'])]);
	}

	public static function content(...exprs:Expr):Expr {
		// @todo: Maybe allow other content (from the Config)?
		// @see: https://tailwindcss.com/docs/content
		return createSimpleRule('content', exprs, [Word(['none'])]);
	}
}
