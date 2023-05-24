package breeze;

using StringTools;

// @todo: This isn't used yet! It's here for when I figure out
// a good runtime solution.
class Runtime {
	public static function instance() {
		static var runtime:Null<Runtime> = null;
		if (runtime == null) runtime = new Runtime();
		return runtime;
	}

	final indices:Map<String, Int> = [];
	final sheet:js.html.CSSStyleSheet;

	public function new() {
		this.sheet = createSheet();
		setupPreflight();
	}

	public function add(id:String, css:String) {
		if (css.charAt(0) != '@') {
			css = '@media all { $css }';
		}
		sheet.insertRule(css, switch indices[id] {
			case null: indices[id] = sheet.cssRules.length;
			case index: index;
		});
	}

	function createSheet():js.html.CSSStyleSheet {
		js.Browser.document.querySelector('head style#__breeze') ?.remove();

		var el = js.Browser.document.createStyleElement();
		el.id = '__breeze';

		js.Browser.document.head.appendChild(el);

		return cast el.sheet;
	}

	function setupPreflight() {
		var preflight = breeze.core.Preflight.getPreflight();
		if (preflight.length > 0) {
			add('bz-preflight', preflight);
		}
	}
}
