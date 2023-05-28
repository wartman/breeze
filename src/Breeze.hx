@:noUsing typedef ClassName = breeze.ClassName;
@:noUsing typedef Css = breeze.Css;
@:noUsing typedef Background = breeze.rule.Background;
@:noUsing typedef Border = breeze.rule.Border;
@:noUsing typedef Effect = breeze.rule.Effect;
@:noUsing typedef Filter = breeze.rule.Filter;
@:noUsing typedef Flex = breeze.rule.Flex;
@:noUsing typedef Grid = breeze.rule.Grid;
@:noUsing typedef Interactive = breeze.rule.Interactive;
@:noUsing typedef Layout = breeze.rule.Layout;
@:noUsing typedef Sizing = breeze.rule.Sizing;
@:noUsing typedef Spacing = breeze.rule.Spacing;
@:noUsing typedef Transform = breeze.rule.Transform;
@:noUsing typedef Transition = breeze.rule.Transition;
@:noUsing typedef Typography = breeze.rule.Typography;
@:noUsing typedef Svg = breeze.rule.Svg;
@:noUsing typedef Modifier = breeze.variant.Modifier;
@:noUsing typedef Breakpoint = breeze.variant.Breakpoint;
@:noUsing typedef Select = breeze.variant.Select;
@:noUsing typedef ColorScheme = breeze.variant.ColorScheme;

class Breeze {
	@:noUsing
	inline public static function compose(...classes:ClassName) {
		return ClassName.ofArray(classes);
	}
}
