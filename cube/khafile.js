let project = new Project('Empty');

project.addSources('Sources');
project.addShaders('Shaders');
project.addLibrary('../../iron');
project.addAssets('Assets/**');

resolve(project);
