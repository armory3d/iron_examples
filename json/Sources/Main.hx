package;

import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.data.*;
import iron.data.SceneFormat;
import iron.object.Object;
import iron.math.Vec4;

class Main {

	static var raw:TSceneFormat;

	public static function main() {
		kha.System.start({title: "Empty", width: 1280, height: 720}, function(window:kha.Window) {
			App.init(ready);
		});
	}

	static function ready() {
		var path = new RenderPath();
		path.commands = function() {
			path.setTarget("");
			path.clearTarget(0xff6495ED, 1.0);
			path.drawMeshes("mesh");
		};
		RenderPath.setActive(path);

		// Create scene from "Scene.json" file
		iron.Scene.setActive("Scene.json", function(object:iron.object.Object) {
			sceneReady();
		});
	}

	static function sceneReady() {
		// Get cube object
		var cube = Scene.active.getChild("Cube");
		
		App.notifyOnUpdate(function() {
			// Rotate on Z axis
			cube.transform.rotate(new Vec4(0, 0, 1), 0.02);
		});
	}
}
