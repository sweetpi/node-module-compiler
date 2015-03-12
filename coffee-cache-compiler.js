/*
node-coffee-cache
from: https://github.com/FogCreek/node-coffee-cache

The MIT License

Copyright (c) Fog Creek Software Inc. 2013

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
var fs     = require('fs.extra');
var path   = require('path');
var colors = require('colors');
// We don't want to include our own version of CoffeeScript since we don't know
// what version the parent relies on
var coffee;
try {
  coffee = require('coffee-script');
} catch (e) {
  // No coffee-script installed in the project; warn them and stop
  process.stderr.write("coffee-cache: No coffee-script package found.\n");
  return;
}


// Directory to store compiled source
var cacheDir = process.env['COFFEE_CACHE_DIR'] || '.js';


function getCachPaths(filename) {
  // First, convert the filename to something more digestible and use our cache
  // folder
  var rootDir = "";
  var insideCache = "";
  var match = filename.match(/^(.*\/node_modules\/[^\/]+)\/(.*)$/);
  if(match) {
    rootDir = match[1];
    insideCache = match[2];
  } else {
    rootDir = __dirname;
    insideCache = path.relative(rootDir, filename);
  }

  var cachePath = path.resolve(rootDir, cacheDir, insideCache).replace(/\.coffee$/, '.js');
  var mapPath = path.resolve(cachePath.replace(/\.js$/, '.map'));
  return {
    cache: cachePath,
    map: mapPath,
    root: rootDir
  };
}

var compile = function(filename) {
  var paths = getCachPaths(filename);
  var cachePath = paths.cache;
  var mapPath = paths.map;
  var rootDir = paths.root;
  var content;

  try {
    // Read from disk and then compile
    process.stdout.write(colors.italic(
      "coffee-cache: compiling coffee-script file \""+path.relative(rootDir, filename)+"\"..."
    ));
    var compiled = coffee.compile(fs.readFileSync(filename, 'utf8'), {
      filename: filename,
      sourceMap: true,
      bare: true,
      generatedFile: path.basename(cachePath),
      sourceFiles: [path.basename(filename)]
    });
    process.stdout.write(colors.italic('Done\n'));
    content = compiled.js;

    // Try writing to cache
    fs.mkdirsSync(path.dirname(cachePath));

    fs.writeFileSync(cachePath, content, 'utf8');
    if (mapPath)
      fs.writeFileSync(mapPath, compiled.v3SourceMap, 'utf8');
  } catch (err) {
    console.log(err);
  }

};

var walk = function(dir) {
  fs.readdir(dir, function(err, list) {
    var pending = list.length;
    list.forEach(function(file) {
      file = path.resolve(dir, file);
      fs.stat(file, function(err, stat) {
        if (stat && stat.isDirectory()) {
          if(!file.match(/.*node_modules$/) && !file.match(/.*\.git$/)) {
            walk(file);
          }
        } else {
          if(file.match(/.+\.coffee$/)) {
            compile(file);
          }
        }
      });
    });
  });
};

walk(process.argv[2] || '.');