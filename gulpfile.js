const { series } = require("gulp");

const clean = async function() {
  console.log("Clean: remove generated code.");
  await Promise.resolve({succeeded: true});
}

const runServer = async function() {
  console.log("Run the server on port 4001.");
  await Promise.resolve({succeeded: true});
}

const watchElmCode = async function() {
  console.log("Watch the Elm code, to rebuild it as it changes.");
  await Promise.resolve({succeeded: true});
}

const buildElmCode = async function() {
  console.log("Build the Elm code.");
  await Promise.resolve({succeeded: true});
}

exports.default = series(clean, runServer, watchElmCode, buildElmCode);
