package breeze.rule;

import breeze.core.Rule;
import haxe.macro.Expr;

class Table {
	public static function borderCollapse(...exprs:Expr):Expr {
		return Rule.simple('border', exprs, [Word(['collapse', 'separate'])], {property: 'border-collapse'});
	}

	public static function borderSpacing(...exprs:Expr):Expr {
		// @todo: https://tailwindcss.com/docs/border-spacing
		throw 'todo';
	}

	public static function layout(...exprs:Expr):Expr {
		return Rule.simple('table', exprs, [Word(['auto', 'fixed'])], {property: 'table-layout'});
	}

	public static function captionSide(...exprs:Expr):Expr {
		return Rule.simple('caption', exprs, [Word(['top', 'bottom'])], {property: 'caption-side'});
	}
}
