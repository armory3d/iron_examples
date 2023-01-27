
let project = new Project("Example");
project.addSources("Sources");
project.addShaders("Shaders/*.glsl");
project.addShaders("../armorcore/Shaders/*.glsl");
project.addAssets("Assets/**", { destination: "data/{name}" });
project.addLibrary("../iron");
project.addDefine("arm_noembed");
project.addDefine("arm_data_dir");
project.addDefine("arm_use_k_images");
resolve(project);
