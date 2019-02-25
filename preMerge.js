const fs = require('fs');
const packageJsonLocation = './package.json';
const pjson = require(packageJsonLocation);
let pjsonSplit = pjson.version.split('.');
let newPackageJson = Object.assign({}, pjson, {
  version: `${pjsonSplit[0]}.${pjsonSplit[1]}.${parseInt(pjsonSplit[2]) + 1}`
});

fs.writeFileSync(packageJsonLocation, JSON.stringify(newPackageJson, null, '\t'), 'utf8', function (err) {
   if (err) return console.log(err);
});
