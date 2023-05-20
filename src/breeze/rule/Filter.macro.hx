package breeze.rule;

import breeze.core.ColorTools;
import breeze.core.RuleBuilder;
import haxe.macro.Context;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

function blur(...exprs:Expr) {
	return createSimpleRule('blur', exprs, [Word(['none', 'sm', 'base', 'md', 'lg', 'xl', 'xxl', '3xl'])], {
		property: 'filter',
		process: value -> 'blur(${switch value {
      case 'none': '0';
      case 'sm': '4px';
      case 'base': '8px';
      case 'md': '12px';
      case 'lg': '16px';
      case 'xl': '24px';
      case 'xxl': '40px';
      case '3xl': '64px';
      default: throw 'assert'; 
    }})'
	});
}

function brightness(...exprs:Expr) {
	return createSimpleRule('brightness', exprs, [Integer], {
		property: 'filter',
		process: value -> 'brightness(${Std.parseInt(value) / 100})'
	});
}

function contrast(...exprs:Expr) {
	return createSimpleRule('contrast', exprs, [Integer], {
		property: 'filter',
		process: value -> 'contrast(${Std.parseInt(value) / 100})'
	});
}

function dropShadow(...exprs:Expr) {
	return createSimpleRule('drop-shadow', exprs, [Word(['none', 'sm', 'base', 'md', 'lg', 'xl', 'xxl'])], {
		property: 'filter',
		process: value -> switch value {
			case 'sm': 'drop-shadow(0 1px 1px rgb(0 0 0 / 0.05))';
			case 'base': 'drop-shadow(0 1px 2px rgb(0 0 0 / 0.1)) drop-shadow(0 1px 1px rgb(0 0 0 / 0.06))';
			case 'md': 'drop-shadow(0 4px 3px rgb(0 0 0 / 0.07)) drop-shadow(0 2px 2px rgb(0 0 0 / 0.06))';
			case 'lg': 'drop-shadow(0 10px 8px rgb(0 0 0 / 0.04)) drop-shadow(0 4px 3px rgb(0 0 0 / 0.1))';
			case 'xl': 'drop-shadow(0 20px 13px rgb(0 0 0 / 0.03)) drop-shadow(0 8px 5px rgb(0 0 0 / 0.08))';
			case 'xxl': 'drop-shadow(0 25px 25px rgb(0 0 0 / 0.15))';
			case 'none': 'drop-shadow(0 0 #0000)';
			default: throw 'assert';
		}
	});
}

function grayscale(...exprs:Expr) {
	return createSimpleRule('grayscale', exprs, [Word(['off', 'on'])], {
		property: 'filter',
		process: value -> 'grayscale(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
	});
}

function hueRotate(...exprs:Expr) {
	return createSimpleRule('hue-rotate', exprs, [Integer], {
		property: 'filter',
		process: value -> 'hue-rotate(${value}deg)'
	});
}

function invert(...exprs:Expr) {
	return createSimpleRule('invert', exprs, [Word(['off', 'on'])], {
		property: 'filter',
		process: value -> 'invert(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
	});
}

function saturate(...exprs:Expr) {
	return createSimpleRule('saturate', exprs, [Integer], {
		property: 'filter',
		process: value -> 'saturate(${Std.parseInt(value) / 100})'
	});
}

function sepia(...exprs:Expr) {
	return createSimpleRule('sepia', exprs, [Word(['off', 'on'])], {
		property: 'filter',
		process: value -> 'sepia(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
	});
}

function backdropBlur(...exprs:Expr) {
	return createSimpleRule('backdrop-blur', exprs, [Word(['none', 'sm', 'base', 'md', 'lg', 'xl', 'xxl', '3xl'])], {
		property: 'backdrop-filter',
		process: value -> 'blur(${switch value {
      case 'none': '0';
      case 'sm': '4px';
      case 'base': '8px';
      case 'md': '12px';
      case 'lg': '16px';
      case 'xl': '24px';
      case 'xxl': '40px';
      case '3xl': '64px';
      default: throw 'assert'; 
    }})'
	});
}

function backdropBrightness(...exprs:Expr) {
	return createSimpleRule('backdrop-brightness', exprs, [Integer], {
		property: 'backdrop-filter',
		process: value -> 'brightness(${Std.parseInt(value) / 100})'
	});
}

function backdropContrast(...exprs:Expr) {
	return createSimpleRule('backdrop-contrast', exprs, [Integer], {
		property: 'backdrop-filter',
		process: value -> 'contrast(${Std.parseInt(value) / 100})'
	});
}

function backdropGrayscale(...exprs:Expr) {
	return createSimpleRule('backdrop-grayscale', exprs, [Word(['off', 'on'])], {
		property: 'backdrop-filter',
		process: value -> 'grayscale(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
	});
}

function backdropHueRotate(...exprs:Expr) {
	return createSimpleRule('backdrop-hue-rotate', exprs, [Integer], {
		property: 'backdrop-filter',
		process: value -> 'hue-rotate(${value}deg)'
	});
}

function backdropInvert(...exprs:Expr) {
	return createSimpleRule('backdrop-invert', exprs, [Word(['off', 'on'])], {
		property: 'backdrop-filter',
		process: value -> 'invert(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
	});
}

function backdropOpacity(...exprs:Expr) {
	return createSimpleRule('backdrop-opacity', exprs, [Integer], {
		property: 'backdrop-filter',
		process: value -> 'opacity(${Std.parseInt(value) / 100})'
	});
}

function backdropSaturate(...exprs:Expr) {
	return createSimpleRule('backdrop-saturate', exprs, [Integer], {
		property: 'backdrop-filter',
		process: value -> 'saturate(${Std.parseInt(value) / 100})'
	});
}

function backdropSepia(...exprs:Expr) {
	return createSimpleRule('backdrop-sepia', exprs, [Word(['off', 'on'])], {
		property: 'backdrop-filter',
		process: value -> 'sepia(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
	});
}
