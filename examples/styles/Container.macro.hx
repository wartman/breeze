package styles;

import breeze.core.RuleBuilder;
import breeze.core.ErrorTools;
import haxe.macro.Expr;

class Container {
	public static function box(...exprs):Expr {
		return RuleBuilder.from(exprs).compose(args -> switch args {
			case [padding]:
				[
					macro breeze.rule.Spacing.pad($padding),
					macro breeze.rule.Flex.display(),
					macro breeze.rule.Border.radius(2),
					macro breeze.rule.Border.width(.5),
					macro breeze.rule.Border.style('solid')
				];
			default:
				expectedArguments(1);
				[];
		}).register();
	}
}
