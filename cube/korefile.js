let fs = require('fs');
let path = require('path');
let project = new Project('Empty', __dirname);
project.targetOptions = {"html5":{},"flash":{},"android":{},"ios":{}};
project.setDebugDir('build/osx');
Promise.all([Project.createProject('build/osx-build', __dirname), Project.createProject('/Users/lubos/Documents/armory/Armory/blender.app/armsdk/Kode Studio.app/Contents/Kha', __dirname), Project.createProject('/Users/lubos/Documents/armory/Armory/blender.app/armsdk/Kode Studio.app/Contents/Kha/Kore', __dirname)]).then((projects) => {
	for (let p of projects) project.addSubProject(p);
	let libs = [];
	if (fs.existsSync(path.join('Libraries/../../iron', 'korefile.js'))) {
		libs.push(Project.createProject('Libraries/../../iron', __dirname));
	}
	Promise.all(libs).then((libprojects) => {
		for (let p of libprojects) project.addSubProject(p);
		resolve(project);
	});
});
