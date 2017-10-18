module.exports = {
  entry: "./script.js",
  output: {
    filename: "bundle.js"
  }
}

externals: {
  child_process: 'child_process'
}