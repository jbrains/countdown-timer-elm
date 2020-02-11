const defaultTask = async function() {
  console.log("Hello, world. Gulp is running.");
  await Promise.resolve({});
}

exports.default = defaultTask;
