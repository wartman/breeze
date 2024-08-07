package breeze.core;

import breeze.core.CssTools.sanitizeClassName;
import haxe.macro.Context;
import breeze.core.Registry;
import haxe.macro.Expr;

using breeze.core.MacroTools;
using breeze.core.ValueTools;
using breeze.core.CssTools;

typedef Rule = {
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
		add pseudo classes. See `breeze.core.RuleBuilder.maybeRegisterVariant`.
	**/
	public final variants:Array<String>;

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

function createRule(rule:Rule):Expr {
	var css = '{${parseProperties(rule.properties)}}';
	var entry:CssEntry = {
		selector: parseClassName(rule),
		modifiers: [],
		specifiers: [],
		wrapper: null,
		css: css,
		priority: rule.priority ?? 1
	};
	if (rule.variants.length > 0) {
		for (name in rule.variants) {
			var variant = getVariant(name);
			entry = variant.parse(entry);
		}
	}
	return registerCss(entry, rule.pos);
}

function createSimpleRule(prefix:String, exprs:Array<Expr>, allowed:Array<CssValueType>, ?options:{?property:String, ?process:(value:String) -> String}):Expr {
	var process = options?.process ?? value->value;
	var property = options?.property ?? prefix;
	var args = prepareArguments(exprs);
	return switch args.args {
		case [valueExpr]:
			var value = valueExpr.extractCssValue(allowed);
			createRule({
				prefix: prefix,
				type: [value],
				variants: args.variants,
				properties: [{name: property, value: process(value)}],
				pos: Context.currentPos()
			});
		default:
			ErrorTools.expectedArguments(1);
	}
}

function parseClassName(rule:Rule) {
	var selector = rule.prefix;
	var type = rule?.type?.filter(f -> f != null)?.map(sanitizeClassName);
	if (type != null && type.length > 0) {
		selector += '-' + type.join('-');
	}
	return selector;
}

function parseRule(rule:Rule) {
	var selector = parseClassName(rule);
	var css = parseProperties(rule.properties);
	return '.$selector { $css }';
}

function parseProperties(properties:Array<RuleProperty>):String {
	return [
		for (property in properties) {
			'${property.name}:${property.value}';
		}
	].join('; ');
}

final VariantCollection:Map<String, Variant> = [];

typedef Variant = {
	public final name:String;
	public final parse:(css:CssEntry) -> CssEntry;
}

function wrapWithVariant(name:String, parser:(entry:CssEntry) -> CssEntry, exprs:Array<Expr>) {
	maybeRegisterVariant(name, parser);

	var args = prepareArguments(exprs);
	var variants = args.variants.map(name -> createVariantIdentifier(macro $v{name}));

	variants.push(createVariantIdentifier(macro $v{name}));

	var out = [
		for (expr in args.args) switch expr.expr {
			case ECall(e, params):
				expr.expr = ECall(e, params.concat(variants));
				expr;
			default:
				expr;
		}
	];
	return macro breeze.ClassName.ofArray([$a{out}]);
}

function variantExists(name:String) {
	return VariantCollection.exists(name);
}

function registerVariant(variant:Variant) {
	VariantCollection.set(variant.name, variant);
}

function maybeRegisterVariant(name:String, parser:(entry:CssEntry) -> CssEntry) {
	if (!variantExists(name)) {
		registerVariant({
			name: name,
			parse: parser
		});
	}
	return name;
}

function getVariant(name:String) {
	if (!variantExists(name)) {
		Context.error('Invalid variant: $name', Context.currentPos());
	}
	return VariantCollection.get(name);
}

function createVariantIdentifier(e) {
	var expr = macro @:pos(e.pos) @:bz.variant $e;
	return expr;
}

function extractVariantIdentifier(e:Expr) {
	return switch e.expr {
		case EMeta({name: ':bz.variant'}, e):
			e.extractString();
		default:
			Context.error('Expected a string with :bz.variant metadata', e.pos);
	}
}

function isVariant(e) {
	return switch e.expr {
		case EMeta({name: ':bz.variant'}, _): true;
		default: false;
	}
}

function prepareArguments(exprs:Array<Expr>):{args:Array<Expr>, variants:Array<String>} {
	var args:Array<Expr> = [];
	var variants = [];

	for (expr in exprs) {
		if (isVariant(expr)) {
			variants.push(extractVariantIdentifier(expr));
		} else {
			args.push(expr);
		}
	}

	return {
		args: args,
		variants: variants
	};
}
