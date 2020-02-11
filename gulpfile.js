const { series, parallel, watch, src, dest } = require("gulp");
const elm = require("gulp-elm");
const del = require("del");
const gulpServerIo = require('gulp-server-io');

const clean = function() {
  del.sync(["elm/target", "jekyll/source/javascripts/countdown-timer-elm.js"]);
  return Promise.resolve({succeeded: true});
}

const runServer = function() {
  // Deploy
  src("jekyll/source").pipe(dest("jekyll/www"));
  // Run server
  return src(["jekyll/www"]).pipe(gulpServerIo({port: 4001}));
}

const watchElmCode = function() {
  watch("elm/src/**/*.elm", series(buildElmCode));
  return Promise.resolve({succeeded: true});
}

const buildElmCode = function() {
  src("elm/src/Main.elm")
     .pipe(elm.bundle("countdown-timer-elm.js", { optimize: true, cwd: "elm" }))
     .pipe(dest("jekyll/source/javascripts"));
  return Promise.resolve({succeeded: true});
}

exports.build = buildElmCode;
exports.clean = clean;
exports.runServer = runServer;
exports.default = series(clean, buildElmCode, parallel(watchElmCode, runServer));
