package breeze.core;

import haxe.Rest;
import breeze.core.CssTools;
import haxe.macro.Context;
import breeze.core.Registry;
import haxe.macro.Expr;

using breeze.core.MacroTools;
using breeze.core.ValueTools;
using breeze.core.CssTools;
using haxe.macro.Tools;

typedef RuleObject = {
	/**
		The prefix to apply to this rule.
	**/
	public final prefix:String;

	/**
		Specify this rule a bit more (for example, for a pad rule,
		this might be a pixel value). `null` will be ignored.
	**/
	public final ?type:Array<Null<String>>;

	/**
		Set the priority of the CSS rule. The higher the 
		priority, the lower in the CSS file it will appear
		(and thus the higher prescience it will have when being
		applied).

		If ignored, a default value of `1` will be used.
	**/
	public final ?priority:Int;

	/**
		Variants are basically post-processing hooks used to
		wrap CSS rules in things like media queries or to
		add pseudo classes. See `breeze.core.RuleBuilder.Variant.create`.
	**/
	public final variants:Array<VariantIdentifier>;

	/**
		The CSS Properties this rule should define.
	**/
	public final properties:Array<RuleProperty>;

	/**
		The position this rule was defined at (used for errors).
	**/
	public final pos:Position;
}

typedef RuleProperty = {
	public final name:String;
	public final value:String;
}

@:forward
abstract Rule(RuleObject) {
	public static function create(config) {
		return new Rule(config);
	}

	public static function simple(prefix:String, args:Arguments, allowed:Array<CssValueType>, ?options:{?property:String, ?process:(value:String) -> String}) {
		var process = options?.process ?? (value) -> value;
		var property = options?.property ?? prefix;
		return switch args.exprs {
			case [valueExpr]:
				var value = valueExpr.extractCssValue(allowed);
				new Rule({
					prefix: prefix,
					type: [value],
					variants: args.variants,
					properties: [{name: property, value: process(value)}],
					pos: Context.currentPos()
				});
			default:
				ErrorTools.expectedArguments(1);
				null;
		}
	}

	public function new(config) {
		this = config;
	}

	@:to public function register():Expr {
		var css = '{${parseProperties()}}';
		var entry:CssEntry = {
			selector: parseClassName(),
			modifiers: [],
			specifiers: [],
			wrapper: null,
			css: css,
			priority: this.priority ?? 1
		};
		if (this.variants.length > 0) {
			for (name in this.variants) {
				entry = Variant.fromIdentifier(name).parse(entry);
			}
		}
		return registerCss(entry, this.pos);
	}

	@:to function toString() {
		var selector = parseClassName();
		var css = parseProperties();
		return '.$selector { $css }';
	}

	function parseProperties():String {
		return [
			for (property in this.properties) {
				'${property.name}:${property.value}';
			}
		].join('; ');
	}

	function parseClassName() {
		var selector = this.prefix;
		var type = this.type?.filter(f -> f != null)?.map(sanitizeClassName);
		if (type != null && type.length > 0) {
			selector += '-' + type.join('-');
		}
		return selector;
	}
}

@:forward
abstract ClassNameBuilder(Array<Expr>) {
	@:from public static function fromRules(rules:Array<Rule>) {
		return new ClassNameBuilder(rules.map(rule -> rule.register()));
	}

	@:from public static function fromExprs(exprs) {
		return new ClassNameBuilder(exprs);
	}

	public function new(rules) {
		this = rules;
	}

	@:to public function toExpr():Expr {
		var exprs = this;
		return macro breeze.ClassName.ofArray([$a{exprs}]);
	}

	public function apply(args:Arguments) {
		var exprs = this.concat(args.exprs);
		var variantArgs = args.variants.map(variant -> variant.toExpr());

		function applyVariant(expr:Expr) {
			return switch expr.expr {
				case ECall(e, params):
					{
						expr: ECall(e, params.concat(variantArgs)),
						pos: expr.pos
					};
				default:
					expr;
			}
		}
		return macro breeze.ClassName.ofArray([$a{exprs.map(applyVariant)}]);
	}
}

final VariantCollection:Map<VariantIdentifier, Variant> = [];

typedef VariantObject = {
	public final name:VariantIdentifier;
	public final parse:(css:CssEntry) -> CssEntry;
}

@:forward
abstract Variant(VariantObject) from VariantObject {
	/**
		Create *and register* a Variant. If a Variant already exists it will not be
		registered again.
	**/
	public static function create(name, parse) {
		var variant = new Variant(name, parse);
		variant.register();
		return variant;
	}

	@:from public static function fromIdentifier(name:VariantIdentifier) {
		if (!VariantCollection.exists(name)) {
			Context.error('Invalid variant: $name', Context.currentPos());
		}
		return VariantCollection.get(name);
	}

	public function new(name, parse) {
		this = {
			name: name,
			parse: parse
		}
	}

	@:to public function toIdentifier():VariantIdentifier {
		return this.name;
	}

	public function exists():Bool {
		return VariantCollection.exists(this.name);
	}

	public function register() {
		if (!exists()) VariantCollection.set(this.name, this);
	}

	public function wrap(exprs:Array<Expr>) {
		return ClassNameBuilder.fromExprs(exprs).apply([this.name.toExpr()]);
	}
}

@:forward
abstract VariantIdentifier(String) {
	public static function isIdentifier(e:Expr):Bool {
		return switch e.expr {
			case EMeta({name: ':bz.variant'}, _): true;
			default: false;
		}
	}

	@:from public static function fromString(name:String) {
		return new VariantIdentifier(name);
	}

	@:from public static function fromExpr(e:Expr) {
		return switch e.expr {
			case EMeta({name: ':bz.variant'}, e):
				new VariantIdentifier(e.extractString());
			default:
				Context.error('Expected a string with :bz.variant metadata', e.pos);
		}
	}

	public function new(value) {
		this = value;
	}

	@:to public function toExpr():Expr {
		var expr = macro @:bz.variant $v{this};
		return expr;
	}
}

typedef ArgumentsObject = {
	public final exprs:Array<Expr>;
	public var variants:Array<VariantIdentifier>;
};

@:forward
abstract Arguments(ArgumentsObject) {
	@:from public static function fromExprsRest(exprs:Rest<Expr>) {
		return fromExprsArray(exprs.toArray());
	}

	@:from public static function fromExprsArray(exprs:Array<Expr>) {
		return new Arguments({
			exprs: exprs.filter(expr -> !VariantIdentifier.isIdentifier(expr)),
			variants: exprs.filter(VariantIdentifier.isIdentifier).map(VariantIdentifier.fromExpr)
		});
	}

	public function new(object) {
		this = object;
	}
}
