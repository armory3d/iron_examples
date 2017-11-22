package;

import haxe.ui.Toolkit;
import haxe.ui.components.*;
import haxe.ui.core.Component;
import haxe.ui.core.Screen;
import haxe.ui.macros.ComponentMacros;
import haxe.ui.core.UIEvent;
import kha.System;
import iron.data.SceneFormat;

class Main {

	static var _main:Component;

	public static function main() {
		System.init({title: "Empty", width: 960, height: 540, samplesPerPixel: 4}, function() {
			kha.Assets.loadFont("arial", function(font:kha.Font) {
				iron.App.init(ready);
			});
		});
	}

	static function getConstant(mat:TMaterialContext, name:String):TBindConstant {
		for (c in mat.bind_constants) if (c.name == name) return c;
		return null;
	}

	static function ready() {
		var path = new iron.RenderPath();
		path.commands = function() {
			path.setTarget("");
			path.clearTarget(0xff222222, 1.0);
			path.drawMeshes("mesh");
		};
		iron.RenderPath.setActive(path);

        iron.Scene.setActive("Scene", function(o:iron.object.Object) {

			var cube:iron.object.MeshObject = cast o.getChild("Cube");
			var tr = cube.transform;
			var mat = cube.materials[0].getContext("mesh").raw;
			var matcol = getConstant(mat, "color").vec3;
			var matnorm = getConstant(mat, "norm");
			var mattwist = getConstant(mat, "twist");

			Toolkit.init();
			_main = ComponentMacros.buildComponent("../Assets/ui/main.xml");
			Screen.instance.addComponent(_main);

			var scaleX:HSlider = _main.findComponent("scaleX", null, true);
			scaleX.onChange = function(e:UIEvent) {
				tr.scale.x = scaleX.pos / 50;
				tr.dirty = true;
			}
			var scaleY:HSlider = _main.findComponent("scaleY", null, true);
			scaleY.onChange = function(e:UIEvent) {
				tr.scale.y = scaleY.pos / 50;
				tr.dirty = true;
			}
			var scaleZ:HSlider = _main.findComponent("scaleZ", null, true);
			scaleZ.onChange = function(e:UIEvent) {
				tr.scale.z = scaleZ.pos / 50;
				tr.dirty = true;
			}

			var colorR:HSlider = _main.findComponent("colorR", null, true);
			colorR.onChange = function(e:UIEvent) { matcol[0] = colorR.pos / 100; }
			var colorG:HSlider = _main.findComponent("colorG", null, true);
			colorG.onChange = function(e:UIEvent) { matcol[1] = colorG.pos / 100; }
			var colorB:HSlider = _main.findComponent("colorB", null, true);
			colorB.onChange = function(e:UIEvent) { matcol[2] = colorB.pos / 100; }

			var norm:HSlider = _main.findComponent("norm", null, true);
			norm.onChange = function(e:UIEvent) { matnorm.float = norm.pos / 100; }
			var twist:HSlider = _main.findComponent("twist", null, true);
			twist.onChange = function(e:UIEvent) { mattwist.float = twist.pos / 100; }

			var rotX:CheckBox = _main.findComponent("rotX", null, true);
			var rotY:CheckBox = _main.findComponent("rotY", null, true);
			var rotZ:CheckBox = _main.findComponent("rotZ", null, true);
			iron.App.notifyOnUpdate(function() {
				if (rotX.selected) cube.transform.rotate(iron.math.Vec4.xAxis(), 0.01);
				if (rotY.selected) cube.transform.rotate(iron.math.Vec4.yAxis(), 0.01);
				if (rotZ.selected) cube.transform.rotate(iron.math.Vec4.zAxis(), 0.01);
			});

			iron.App.notifyOnRender2D(function(g:kha.graphics2.Graphics) {
				Screen.instance.renderTo(g);
			});
		});
	}
}
