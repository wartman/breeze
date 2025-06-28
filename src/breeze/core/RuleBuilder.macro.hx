package breeze.core;

import haxe.macro.Context;
import breeze.core.Rule;
import haxe.macro.Expr;

typedef RuleBuilderDefinition = {
	public final prefix:String;
	public final ?type:Array<Null<String>>;
	public final ?priority:Int;
	public final properties:Array<RuleProperty>;
}

enum RuleBuilderType {
	None;
	Composition(factory:(args:Array<Expr>) -> Array<Expr>);
	Definition(factory:(args:Array<Expr>) -> RuleBuilderDefinition);
}

class RuleBuilder {
	public static function from(args:Arguments) {
		return new RuleBuilder(args.exprs, args.variants);
	}

	final arguments:Array<Expr>;
	final variants:Array<VariantIdentifier>;

	var type:RuleBuilderType;

	public function new(arguments, variants) {
		this.type = None;
		this.arguments = arguments;
		this.variants = variants;
	}

	public function compose(factory:(args:Array<Expr>) -> Array<Expr>) {
		this.type = Composition(factory);
		return this;
	}

	public function define(factory:(args:Array<Expr>) -> RuleBuilderDefinition) {
		this.type = Definition(factory);
		return this;
	}

	public function register():Expr {
		return switch type {
			case None:
				macro null;
			case Composition(factory):
				ClassNameBuilder
					.fromExprs(factory(arguments))
					.apply(variants.map(variant -> variant.toExpr()));
			case Definition(factory):
				var def = factory(arguments);
				Rule.create({
					prefix: def.prefix,
					type: def.type,
					priority: def.priority ?? 1,
					variants: variants,
					properties: def.properties,
					pos: Context.currentPos()
				});
		}
	}
}
