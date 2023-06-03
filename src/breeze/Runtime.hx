package breeze;

using StringTools;

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

	public function rule(id:String, css:String, ?priority:Int) {
		if (!indices.exists(id)) add(id, css, priority);
		return new ClassName(id);
	}

	public function add(id:String, css:String, priority:Int = 1) {
		// @todo: Not sure how to handle priority yet, if we even can.
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
		for (id => css in preflight) add(id, css);
	}
}
