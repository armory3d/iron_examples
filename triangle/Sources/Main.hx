package;

import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.data.*;
import iron.data.SceneFormat;
import iron.object.Object;

class Main {

	static var raw:TSceneFormat;

	public static function main() {
		kha.System.start({ title: "Empty", width: 1280, height: 720 }, function(window:kha.Window) {
			App.init(ready);
		});
	}

	static function ready() {
		var path = new RenderPath();
		path.commands = function() {
			path.setTarget("");
			path.clearTarget(0xff000000, 1.0);
			path.drawMeshes("mesh");
		};
		RenderPath.setActive(path);

		raw = {
			name: "Scene",
			shader_datas: [],
			material_datas: [],
			mesh_datas: [],
			objects: []
		}
		Data.cachedSceneRaws.set(raw.name, raw);
		Scene.create(raw, sceneReady);
	}

	static function sceneReady(scene:Object) {
		var m = Std.int(32767 / 2);
		var vb = new kha.arrays.Int16Array(12);
		vb[0] = -1 * m; vb[1] = -1 * m; vb[2 ] = 0; vb[3 ] = 0;
		vb[4] =  1 * m; vb[5] = -1 * m; vb[6 ] = 0; vb[7 ] = 0;
		vb[8] =  0    ; vb[9] =  1 * m; vb[10] = 0; vb[11] = 0;
		var ib = new kha.arrays.Uint32Array(3);
		ib[0] = 0; ib[1] = 1; ib[2] = 2;

		var mesh:TMeshData = {
			name: "TriangleMesh",
			vertex_arrays: [
				{ attrib: "pos", values: vb }
			],
			index_arrays: [
				{ material: 0, values: ib }
			],
			scale_pos: 1.0
		}
		raw.mesh_datas.push(mesh);

		MeshData.parse(raw.name, mesh.name, function(res:MeshData) {

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
							{ name: "color", type: "vec3" }
						],
						vertex_elements: [
							{ name: "pos", data: "short4norm" }
						]
					}
				]
			}
			raw.shader_datas.push(sh);

			var col = new kha.arrays.Float32Array(3);
			col[0] = 1.0; col[1] = 1.0; col[2] = 0.0;

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
			}
			raw.material_datas.push(md);

			MaterialData.parse(raw.name, md.name, function(res:MaterialData) {
				dataReady();
			});
		});
	}

	static function dataReady() {	
		var tri:TObj = {
			name: "Triangle",
			type: "mesh_object",
			data_ref: "TriangleMesh",
			material_refs: ["MyMaterial"],
			transform: null
		}
		raw.objects.push(tri);

		Scene.active.parseObject(raw.name, tri.name, null, function(o:Object) {
			trace('Triangle ready');
		});
	}
}
