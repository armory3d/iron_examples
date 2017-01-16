package;

import kha.System;

class Main {
	public static function main() {
		System.init({title: "Empty", width: 960, height: 540, samplesPerPixel: 4}, function() {
			iron.App.init(ready);
		});
	}

	static function ready() {
		iron.Scene.setActive("Scene");
	}
}
