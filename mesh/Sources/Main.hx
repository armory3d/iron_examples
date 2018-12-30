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
			App.notifyOnUpdate(update);
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

		raw = {
			name: "Scene",
			shader_datas: [],
			material_datas: [],
			mesh_datas: [],
			camera_datas: [],
			camera_ref: "Camera",
			objects: []
		};
		Data.cachedSceneRaws.set(raw.name, raw);
		Scene.create(raw, sceneReady);
	}

	static function sceneReady(scene:Object) {

		var cd:TCameraData = {
			name: "MyCamera",
			near_plane: 0.1,
			far_plane: 100.0,
			fov: 0.85
		};
		raw.camera_datas.push(cd);
		
		var sh:TShaderData = {
			name: "MyShader",
			contexts: [
				{
					name: "mesh",
					vertex_shader: "mesh.vert",
					fragment_shader: "mesh.frag",
					compare_mode: "less",
					cull_mode: "clockwise",
					depth_write: true,
					constants: [
						{ name: "color", type: "vec3" },
						{ name: "WVP", type: "mat4", link: "_worldViewProjectionMatrix" }
					],
					vertex_elements: [
						{ name: "pos", data: "short4norm" }
					]
				}
			]
		};
		raw.shader_datas.push(sh);

		var col = new kha.arrays.Float32Array(3);
		col[0] = 1.0; col[1] = 0.0; col[2] = 0.0;

		var md:TMaterialData = {
			name: "MyMaterial",
			shader: "MyShader",
			contexts: [
				{
					name: "mesh",
					bind_constants: [
						{ name: "color", vec3: col }
					]
				}
			]
		};
		raw.material_datas.push(md);

		MaterialData.parse(raw.name, md.name, function(res:MaterialData) {
			dataReady();
		});
	}

	static function dataReady() {
		// Camera object
		var co:TObj = {
			name: "Camera",
			type: "camera_object",
			data_ref: "MyCamera",
			transform: null
		};
		raw.objects.push(co);

		// Mesh object
		var o:TObj = {
			name: "Suzanne",
			type: "mesh_object",
			data_ref: "Suzanne.arm/Suzanne",
			material_refs: ["MyMaterial"],
			transform: null
		};
		raw.objects.push(o);

		// Instantiate scene
		Scene.create(raw, function(o:Object) {
			trace('Monkey ready');
			// Set camera
			var t = Scene.active.camera.transform;
			t.loc.set(0, -3, 0);
			t.rot.fromTo(new Vec4(0, 0, 1), new Vec4(0, -1, 0));
			t.buildMatrix();
		});

		// Instantiate single object
		// Scene.active.parseObject(raw.name, o.name, null, function(o:Object) {
		// 	trace('Monkey ready');
		// });
	}
	static function update(){
		var z = new Vec4(0.0, 0.0, 1.0);
		var suzanne = Scene.active.getChild("Suzanne");
		
		//Rotate Suzanne on z axis with 0.02 speed
		suzanne.transform.rotate(z, 0.02);
	}
}
