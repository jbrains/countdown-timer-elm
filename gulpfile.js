const { series, parallel, watch, src, dest } = require("gulp");
const elm = require("gulp-elm");
const del = require("del");
const gulpServerIo = require('gulp-server-io');

const clean = function() {
  return del(["www/javascripts/countdown-timer-elm.js"]);
}

const runServer = function() {
  // Run server
  return src(["www"]).pipe(gulpServerIo({port: 4001}));
}

const watchElmCode = function() {
  return watch("src/**/*.elm", series(buildElmCode));
}

const buildElmCode = function() {
  return src("src/Main.elm")
     .pipe(elm.bundle("countdown-timer-elm.js", { optimize: true, cwd: "." }))
     .pipe(dest("www/javascripts"));
}

exports.build = buildElmCode;
exports.clean = clean;
exports.runServer = runServer;
exports.default = series(clean, buildElmCode, parallel(watchElmCode, runServer));
