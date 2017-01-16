let project = new Project('Empty');

project.addSources('Sources');
project.addShaders('Shaders');
project.addLibrary('../../iron');
project.addAssets('Assets/**');
project.addDefine('arm_json');

project.addLibrary('haxeui-core');
project.addLibrary('haxeui-kha');
project.addLibrary('hscript');

resolve(project);
