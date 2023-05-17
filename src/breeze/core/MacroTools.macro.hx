package breeze.core;

import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;

function extractString(expr:Expr):String {
	return switch expr.expr {
		case EConst(CString(value, _)):
			value;
		case EConst(CIdent(value)):
			value;
		default:
			Context.error('Expected a string', expr.pos);
			'';
	}
}

function extractInt(expr:Expr):Int {
	return switch expr.expr {
		case EConst(CInt(i)):
			Std.parseInt(i);
		default:
			Context.error('Expected an int', expr.pos);
			0;
	}
}

function extractFloat(expr:Expr):Float {
	return switch expr.expr {
		case EConst(CInt(i)):
			Std.parseFloat(i);
		case EConst(CFloat(f)):
			Std.parseFloat(f);
		default:
			Context.error('Expected a float', expr.pos);
			0;
	}
}
