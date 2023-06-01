package breeze.rule;

import breeze.core.RuleBuilder;
import haxe.macro.Expr;

using breeze.core.CssTools;
using breeze.core.MacroTools;
using breeze.core.ValueTools;

class Filter {
	public static function blur(...exprs:Expr):Expr {
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

	public static function brightness(...exprs:Expr):Expr {
		return createSimpleRule('brightness', exprs, [Integer], {
			property: 'filter',
			process: value -> 'brightness(${Std.parseInt(value) / 100})'
		});
	}

	public static function contrast(...exprs:Expr):Expr {
		return createSimpleRule('contrast', exprs, [Integer], {
			property: 'filter',
			process: value -> 'contrast(${Std.parseInt(value) / 100})'
		});
	}

	public static function dropShadow(...exprs:Expr):Expr {
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

	public static function grayscale(...exprs:Expr):Expr {
		return createSimpleRule('grayscale', exprs, [Word(['off', 'on'])], {
			property: 'filter',
			process: value -> 'grayscale(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
		});
	}

	public static function hueRotate(...exprs:Expr):Expr {
		return createSimpleRule('hue-rotate', exprs, [Integer], {
			property: 'filter',
			process: value -> 'hue-rotate(${value}deg)'
		});
	}

	public static function invert(...exprs:Expr):Expr {
		return createSimpleRule('invert', exprs, [Word(['off', 'on'])], {
			property: 'filter',
			process: value -> 'invert(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
		});
	}

	public static function saturate(...exprs:Expr):Expr {
		return createSimpleRule('saturate', exprs, [Integer], {
			property: 'filter',
			process: value -> 'saturate(${Std.parseInt(value) / 100})'
		});
	}

	public static function sepia(...exprs:Expr):Expr {
		return createSimpleRule('sepia', exprs, [Word(['off', 'on'])], {
			property: 'filter',
			process: value -> 'sepia(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
		});
	}

	public static function backdropBlur(...exprs:Expr):Expr {
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

	public static function backdropBrightness(...exprs:Expr):Expr {
		return createSimpleRule('backdrop-brightness', exprs, [Integer], {
			property: 'backdrop-filter',
			process: value -> 'brightness(${Std.parseInt(value) / 100})'
		});
	}

	public static function backdropContrast(...exprs:Expr):Expr {
		return createSimpleRule('backdrop-contrast', exprs, [Integer], {
			property: 'backdrop-filter',
			process: value -> 'contrast(${Std.parseInt(value) / 100})'
		});
	}

	public static function backdropGrayscale(...exprs:Expr):Expr {
		return createSimpleRule('backdrop-grayscale', exprs, [Word(['off', 'on'])], {
			property: 'backdrop-filter',
			process: value -> 'grayscale(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
		});
	}

	public static function backdropHueRotate(...exprs:Expr):Expr {
		return createSimpleRule('backdrop-hue-rotate', exprs, [Integer], {
			property: 'backdrop-filter',
			process: value -> 'hue-rotate(${value}deg)'
		});
	}

	public static function backdropInvert(...exprs:Expr):Expr {
		return createSimpleRule('backdrop-invert', exprs, [Word(['off', 'on'])], {
			property: 'backdrop-filter',
			process: value -> 'invert(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
		});
	}

	public static function backdropOpacity(...exprs:Expr):Expr {
		return createSimpleRule('backdrop-opacity', exprs, [Integer], {
			property: 'backdrop-filter',
			process: value -> 'opacity(${Std.parseInt(value) / 100})'
		});
	}

	public static function backdropSaturate(...exprs:Expr):Expr {
		return createSimpleRule('backdrop-saturate', exprs, [Integer], {
			property: 'backdrop-filter',
			process: value -> 'saturate(${Std.parseInt(value) / 100})'
		});
	}

	public static function backdropSepia(...exprs:Expr):Expr {
		return createSimpleRule('backdrop-sepia', exprs, [Word(['off', 'on'])], {
			property: 'backdrop-filter',
			process: value -> 'sepia(${switch value {
      case 'off': '0';
      default: '100%';
    }})'
		});
	}
}
