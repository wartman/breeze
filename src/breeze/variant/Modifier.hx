package breeze.variant;

class Modifier {
	macro public static function on(...exprs);

	macro public static function hover(...exprs);

	macro public static function focus(...exprs);

	macro public static function active(...exprs);

	macro public static function disabled(...exprs);

	macro public static function visited(...exprs);

	macro public static function focusWithin(...exprs);

	macro public static function focusVisible(...exprs);

	macro public static function target(...exprs);
}
