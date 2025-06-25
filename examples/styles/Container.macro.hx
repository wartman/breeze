package styles;

import breeze.core.ErrorTools;

using breeze.core.RuleBuilder;

class Container {
	public static function box(...exprs) {
		return switch exprs.toArray().withoutVariants() {
			case []:
				// @todo
				[
					macro breeze.rule.Spacing.pad(3),
					macro breeze.rule.Flex.display()
				].composeWithVariants(exprs);
			default:
				expectedArguments(0);
		}
	}
}
