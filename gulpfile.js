const { series, watch, src, dest } = require("gulp");
const elm = require("gulp-elm");
const del = require("del");

const clean = async function() {
  console.log("Clean: remove generated code.");
  del.sync(["elm/target", "jekyll/source/javascripts/countdown-timer-elm.js"]);
  await Promise.resolve({succeeded: true});
}

const runServer = async function() {
  console.log("Run the server on port 4001.");
  await Promise.resolve({succeeded: true});
}

const watchElmCode = async function() {
  console.log("Watch the Elm code, to rebuild it as it changes.");
  // watch("elm/src/**/*.elm", series(buildElmCode));
  await Promise.resolve({succeeded: true});
}

const buildElmCode = async function() {
  console.log("Build the Elm code.");
  src("elm/src/Main.elm")
     .pipe(elm.bundle("countdown-timer-elm.js", { optimize: true, cwd: "elm" }))
     .pipe(dest("jekyll/source/javascripts"));
  await Promise.resolve({succeeded: true});
}

exports.build = buildElmCode;
exports.clean = clean;
exports.default = series(clean, runServer, watchElmCode, buildElmCode);
