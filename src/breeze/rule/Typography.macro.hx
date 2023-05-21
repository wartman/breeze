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

function font(...exprs:Expr) {
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

function fontSize(...exprs:Expr) {
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

function fontSmoothing(...exprs:Expr) {
	throw 'todo';
}

function fontStyle(...exprs:Expr) {
	return createSimpleRule('font-style', exprs, [Word(['italic', 'normal'])]);
}

function fontWeight(...exprs:Expr) {
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

function tracking(...exprs:Expr) {
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

function lineClamp(...exprs:Expr) {
	// https://tailwindcss.com/docs/line-clamp
	throw 'todo';
}

function leading(...exprs:Expr) {
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

function listStyle(...exprs:Expr) {
	// https://tailwindcss.com/docs/list-style-image
	throw 'todo';
}

function listPosition(...exprs:Expr) {
	return createSimpleRule('list', exprs, [Word(['inside, outside'])], {
		property: 'list-style-position'
	});
}

function textAlign(...exprs:Expr) {
	return createSimpleRule('text', exprs, [Word(['left', 'center', 'right', 'justify', 'start', 'end'])], {
		property: 'text-align'
	});
}

function textColor(...exprs:Expr) {
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

function textDecoration(...exprs:Expr) {
	return createSimpleRule('text-decoration', exprs, [Word(['underline', 'overline', 'line-through', 'none'])]);
}

function textDecorationColor(...exprs:Expr) {
	return createSimpleRule('decoration-color', exprs, [ColorName, ColorExpr, Word(['inherit', 'currentColor', 'transparent'])], {
		property: 'text-decoration-color'
	});
}

function textDecorationStyle(...exprs:Expr) {
	return createSimpleRule('decoration', exprs, [Word(['solid', 'double', 'dotted', 'dashed', 'wavy'])], {
		property: 'text-decoration-style'
	});
}

function textDecorationThickness(...exprs:Expr) {
	return createSimpleRule('decoration', exprs, [Word(['auto', 'form-font']), Integer], {
		property: 'text-decoration-thickness',
		process: value -> switch value {
			case 'auto' | 'from-font': value;
			default: '${value}px';
		}
	});
}

function textUnderlineOffset(...exprs:Expr) {
	return createSimpleRule('underline-offset', exprs, [Word(['auto']), Integer], {
		property: 'text-underline-offset',
		process: value -> switch value {
			case 'auto': value;
			default: '${value}px';
		}
	});
}

function textTransform(...exprs:Expr) {
	return createSimpleRule('transform', exprs, [Word(['uppercase', 'lowercase', 'capitalize', 'none'])], {
		property: 'text-transform'
	});
}

function textOverflow(...exprs:Expr) {
	return createSimpleRule('text-overflow', exprs, [Word(['ellipsis', 'clip'])]);
}

function textIndent(...exprs:Expr) {
	return createSimpleRule('text-indent', exprs, [Unit]);
}

function textVerticalAlign(...exprs:Expr) {
	return createSimpleRule('vertical-align', exprs, [
		Word(['baseline', 'top', 'middle', 'bottom', 'text-top', 'text-bottom', 'sub', 'super'])
	]);
}

function whitespace(...exprs:Expr) {
	return createSimpleRule('whitespace', exprs, [Word(['normal', 'nowrap', 'pre', 'pre-line', 'pre-wrap', 'break-spaces'])]);
}

function wordBreak(...exprs:Expr) {
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

function hyphens(...exprs:Expr) {
	return createSimpleRule('hyphens', exprs, [Word(['none', 'manual', 'auto'])]);
}

function content(...exprs:Expr) {
	// @todo: Maybe allow other content (from the Config)?
	// @see: https://tailwindcss.com/docs/content
	return createSimpleRule('content', exprs, [Word(['none'])]);
}
