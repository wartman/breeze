package breeze.core;

import haxe.macro.Context;

function expectedArguments(from:Int, ?to:Int) {
	return switch from {
		case 0:
			Context.error('Expected no arguments', Context.currentPos());
		case num if (to == null):
			Context.error('Expected $num arguments', Context.currentPos());
		default:
			Context.error('Expected between $from and $to arguments', Context.currentPos());
	}
}
