package styles;

import breeze.core.RuleFactory;
import breeze.core.ErrorTools;

class Container {
	public static function box(...exprs) {
		return RuleFactory
			.from(exprs)
			.compose(args -> switch args {
				case []:
					// @todo
					[
						macro breeze.rule.Spacing.pad(3),
						macro breeze.rule.Flex.display()
					];
				default:
					expectedArguments(0);
					[];
			})
			.register();
	}
}
