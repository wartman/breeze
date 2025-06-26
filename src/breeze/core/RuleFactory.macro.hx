package breeze.core;

import breeze.core.RuleBuilder;
import haxe.macro.Expr;

enum RuleFactoryType {
	None;
	Composition(factory:(args:Array<Expr>) -> Array<Expr>);
	Definition(factory:(args:Array<Expr>) -> Rule);
}

class RuleFactory {
	public static function from(exprs:Array<Expr>) {
		return new RuleFactory(stripVariants(exprs), onlyVariants(exprs));
	}

	final arguments:Array<Expr>;
	final variants:Array<Expr>;

	var type:RuleFactoryType;

	public function new(arguments, variants) {
		this.type = None;
		this.arguments = arguments;
		this.variants = variants;
	}

	public function compose(factory:(args:Array<Expr>) -> Array<Expr>) {
		this.type = Composition(factory);
		return this;
	}

	public function define(factory:(args:Array<Expr>) -> Rule) {
		this.type = Definition(factory);
		return this;
	}

	public function register():Expr {
		return switch type {
			case None:
				macro null;
			case Composition(factory):
				composeRules(factory(arguments).concat(variants));
			case Definition(factory):
				var rule = factory(arguments);
				var variants = rule.variants.concat(variants.map(extractVariantIdentifier));
				createRule({
					prefix: rule.prefix,
					type: rule.type,
					priority: rule.priority,
					variants: variants,
					properties: rule.properties,
					pos: rule.pos
				});
		}
	}
}
