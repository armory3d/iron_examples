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
						{ name: "WVP", type: "mat4", link: "_worldViewProjectionMatrix" }
					],
					texture_units: [
						{ name: "myTexture" }
					],
					vertex_elements: [
						{ name: "pos", data: "short4norm" },
						{ name: "tex", data: "short2norm" }
					]
				}
			]
		};
		raw.shader_datas.push(sh);

		var md:TMaterialData = {
			name: "MyMaterial",
			shader: "MyShader",
			contexts: [
				{
					name: "mesh",
					bind_textures: [
						{ name: "myTexture", file: "texture.png" }
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
			name: "Cube",
			type: "mesh_object",
			data_ref: "Cube.arm/Cube",
			material_refs: ["MyMaterial"],
			transform: null
		};
		raw.objects.push(o);

		// Instantiate scene
		Scene.create(raw, function(o:Object) {
			trace('Cube ready');
			sceneReady();
		});
	}

	static function sceneReady() {
		// Set camera
		var t = Scene.active.camera.transform;
		t.loc.set(0, -6, 0);
		t.rot.fromTo(new Vec4(0, 0, 1), new Vec4(0, -1, 0));
		t.buildMatrix();
			
		// Rotate cube
		var cube = Scene.active.getChild("Cube");
		App.notifyOnUpdate(function() {
			cube.transform.rotate(new Vec4(0, 0, 1), 0.02);
		});
	}
}
