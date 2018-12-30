package;

import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.data.*;
import iron.data.SceneFormat;
import iron.object.Object;

class Main {

	// Raw data used to create the scene
	static var raw:TSceneFormat;

	public static function main() {
		// Init and create window
		kha.System.start({ title: "Empty", width: 1280, height: 720 }, function(window:kha.Window) {
			App.init(ready);
		});
	}

	static function ready() {
		// Define active render path
		var path = new RenderPath();
		// Commands to execute each frame
		path.commands = function() {
			// Draw to framebuffer
			path.setTarget("");
			// Clear color and depth
			path.clearTarget(0xff000000, 1.0);
			// Loop through visible meshes and draw "mesh" context
			// "mesh" context is retrieved from materials attached to mesh
			// If material with such context exists, mesh is drawn using this material
			path.drawMeshes("mesh");
		};
		RenderPath.setActive(path);

		// Create empty scene
		raw = {
			name: "Scene",
			shader_datas: [],
			material_datas: [],
			mesh_datas: [],
			objects: []
		};
		Data.cachedSceneRaws.set(raw.name, raw);
		Scene.create(raw, sceneReady);
	}

	static function sceneReady(scene:Object) {
		// Create triangle mesh

		// Build vertex buffer
		// Using Short4Norm vertex data to save memory
		// Short = 2 byte values ranging from -32768 to 32767
		// Short4 = 4 components per vertex (1 component is padding here for 32bit alignment)
		// Short4Norm = values are normalized to <-1, 1> range in the shader
		var range = 32767;
		var half = Std.int(range / 2);
		var vb = new kha.arrays.Int16Array(12);
		vb[0] = -half; vb[1] = -half; vb[2 ] = 0; vb[3 ] = 0; // Vertex 0 xyzw
		vb[4] =  half; vb[5] = -half; vb[6 ] = 0; vb[7 ] = 0; // Vertex 1 xyzw
		vb[8] =  0;    vb[9] =  half; vb[10] = 0; vb[11] = 0; // Vertex 2 xyzw
		
		// Build triangle index buffer
		var ib = new kha.arrays.Uint32Array(3);
		ib[0] = 0; // Point to vertex 0
		ib[1] = 1; // Point to vertex 1
		ib[2] = 2; // Point to vertex 2

		// Raw data used to create the mesh
		var mesh:TMeshData = {
			name: "TriangleMesh",
			vertex_arrays: [
				{ attrib: "pos", values: vb }
			],
			index_arrays: [
				{ material: 0, values: ib }
			],
			// Apply scale to world matrix when drawing this mesh
			scale_pos: 1.0
		};
		raw.mesh_datas.push(mesh);

		MeshData.parse(raw.name, mesh.name, function(res:MeshData) {

			// Create shader for our triangle mesh
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
			};
			raw.shader_datas.push(sh);

			// Pass as color uniform to the material
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
			};
			raw.material_datas.push(md);

			MaterialData.parse(raw.name, md.name, function(res:MaterialData) {
				dataReady();
			});
		});
	}

	static function dataReady() {
		// Create new mesh object
		var tri:TObj = {
			name: "Triangle",
			type: "mesh_object",
			data_ref: "TriangleMesh",
			material_refs: ["MyMaterial"],
			transform: null
		};
		raw.objects.push(tri);

		Scene.active.parseObject(raw.name, tri.name, null, function(o:Object) {
			trace('Triangle ready');
		});
	}
}
