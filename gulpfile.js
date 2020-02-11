const defaultTask = function(onTaskSucceeded) {
  console.log("Hello, world. Gulp is running.");
  onTaskSucceeded();
}

exports.default = defaultTask;
