package;

import kha.System;

class Main {
	public static function main() {
		System.init({title: "Empty", width: 960, height: 540, samplesPerPixel: 4}, function() {
			iron.App.init(ready);
		});
	}

	static function ready() {
		var path = new iron.RenderPath();
		path.commands = function() {
			path.setTarget("");
			path.clearTarget(0xff6495ED, 1.0);
			path.drawMeshes("mesh");
		};
		iron.RenderPath.setActive(path);
		iron.Scene.setActive("Scene.json");
	}
}
