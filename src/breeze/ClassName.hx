package breeze;

using StringTools;

abstract ClassName(String) to String {
	@:from public inline static function ofString(s:String):ClassName {
		return if (s == null) null else new ClassName(s);
	}

	@:from public inline static function ofMap(parts:Map<String, Bool>) {
		return ofArray([for (name => isValid in parts) if (isValid) ofString(name)]);
	}

	@:from public inline static function ofDynamicAccess(parts:haxe.DynamicAccess<Bool>) {
		return ofArray([for (name => isValid in parts) if (isValid) ofString(name)]);
	}

	@:from public static function ofArray(parts:Array<String>) {
		var name = parts.map(ofString).filter(s -> s != null && s != '').join(' ');
		return new ClassName(name);
	}

	inline public function new(s:String) {
		this = s;
	}

	public function with(other:ClassName) {
		return new ClassName(switch [this, (other : String)] {
			case [null, v] | [v, null]: v;
			case [a, b]: '$a $b';
		});
	}

	public inline function normalize():ClassName {
		return toArray();
	}

	@:to public inline function toArray():Array<String> {
		return this.split(' ').filter(s -> s != null && s != '');
	}
}
