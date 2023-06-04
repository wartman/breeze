package breeze.core;

import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;
using breeze.core.ColorTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

enum CssValueType {
	All;
	Word(?allowed:Array<String>);
	ColorExpr;
	ColorName;
	String;
	Integer;
	Number;
	Unit;
}

function extractCssValue(e:Expr, allowed:Array<CssValueType>) {
	if (allowed.contains(Integer) && allowed.contains(Unit)) {
		Context.error('Cannot have both Integer and Unit', e.pos);
	}

	return switch e.expr {
		case EBinop(opExpr, e1, e2) if (allowed.contains(Unit)):
			var op = switch opExpr {
				case OpAdd: '+';
				case OpSub: '-';
				case OpMult: '*';
				case OpDiv: '/';
				default: Context.error('Invalid operator', e.pos);
			}
			var left = switch e1.expr {
				case EParenthesis(e): 'calc(${extractCssValue(e1, allowed)})';
				default: extractCssValue(e1, allowed);
			}
			var right = switch e2.expr {
				case EParenthesis(e): 'calc(${extractCssValue(e2, allowed)})';
				default: extractCssValue(e2, allowed);
			}
			return 'calc(${left} ${op} ${right})';
		case EConst(CString(s, _)) if (allowed.contains(String)):
			s;
		case EConst(CString(value, _)) if (isCssUnit(value)):
			if (!allowed.contains(Unit) && !allowed.contains(All)) {
				e.pos.createError(allowed);
			}
			var unit = parseCssUnit(value, e.pos);
			return '${unit.num}${unit.unit}';
		case EConst(CString(value, _)) if (allowed.contains(ColorName) && value.isColorName()):
			return value;
		case EConst(CString(value, _)):
			for (item in allowed) switch item {
				case All:
					return value;
				case Word(allowed) if (allowed == null || allowed.length == 0):
					return value;
				case Word(allowed):
					for (word in allowed) if (value == word) return value;
				case ColorExpr if (value.isColorExpr()):
					return value;
				default:
			}
			e.pos.createError(allowed);
			'';
		case EConst(CInt(i)) if (allowed.contains(Integer) || allowed.contains(Number)):
			return Std.string(i);
		case EConst(CFloat(i)) if (allowed.contains(Number)):
			return Std.string(i);
		case EConst(CInt(i)) | EConst(CFloat(i)):
			if (!allowed.contains(Unit) && !allowed.contains(All)) {
				e.pos.createError(allowed);
			}
			var num = Std.parseFloat(i);
			if (num == 0) return '0px';
			return (num / 4) + 'rem';
		default:
			e.pos.createError(allowed);
			'';
	}
}

function createError(pos:Position, allowed:Array<CssValueType>) {
	var expected = allowed.map(type -> switch type {
		case All: 'any expression';
		case Integer: 'an integer';
		case Number: 'an integer or a float';
		case String: 'a string';
		case Word(allowed): '[' + allowed.map(value -> '"$value"').join('|') + ']';
		case ColorExpr: 'an arbitrary color (using a hex like #ccc or an RGB/A function)';
		case ColorName: 'a pre-defined color (like `black` or `slate`)';
		case Unit: 'a css unit (like "10px") or a float';
	}).join(' or ');
	Context.error('Invalid expression. Expected: $expected', pos);
}

final CssUnits = [
	'%', 'px', 'rem', 'em', 'vw', 'vh', 'vmin', 'vmax', 'vb', 'vi', 'svw', 'svh', 'lvw', 'lvh', 'dvw', 'dvh'
];

function isCssUnit(value:String) {
	for (unit in CssUnits) if (value.endsWith(unit)) return true;
	return false;
}

function parseCssUnit(value:String, pos:Position):{num:Float, unit:String} {
	for (unit in CssUnits) if (value.endsWith(unit)) {
		var num = value.substring(-(unit.length + 1));
		try {
			return {
				num: Std.parseFloat(num),
				unit: unit
			};
		} catch (e) {
			Context.error('Not a valid number', pos);
		}
	}
	Context.error('Invalid css unit', pos);
	return null;
}
