package breeze.core;

import haxe.macro.Context;

function parseColor(name:String, intensity:String) {
	if (!isColorName(name)) {
		Context.error('Invalid color: $name', Context.currentPos());
	}
	if (!isColorIntensity(name, intensity)) {
		var intensities = [for (intensity in getColorConfig().get(name).keys()) intensity].join(', ');
		Context.error('Invalid color intensity: $name $intensity. Allowed intensities for this color are: $intensities.', Context.currentPos());
	}
	return getColorIntensity(name, intensity);
}

final ColorExprHex = ~/([a-f0-9]{3}){1,2}$/i;
final ColorExprFunction = ~/^rgb\(([0-9]{1,3}[ ]*[,]?[ ]*?){3}\)$/g;
final ColorExprWithAlphaFunction = ~/^rgba\(([0-9]{1,3}[ ]*,[ ]*){3}[0-9\.]+\)$/g;

function isColorExpr(value:String) {
	if (ColorExprHex.match(value)) return true;
	if (ColorExprFunction.match(value)) return true;
	if (ColorExprWithAlphaFunction.match(value)) return true;
	return false;
}

function isColorName(name:String) {
	return getColorConfig().exists(name);
}

function isColorIntensity(name:String, intensity:String) {
	if (!isColorName(name)) return false;
	var color = getColorConfig().get(name);
	return color.exists(intensity);
}

function getColorIntensity(name:String, intensity:String) {
	return getColorConfig().get(name) ?.get(intensity);
}

private function getColorConfig() {
	return Config.instance().colors;
}
