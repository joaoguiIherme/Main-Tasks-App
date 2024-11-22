const path = require("path");

module.exports = {
  entry: "./app/javascript/application.js",
  output: {
    path: path.resolve(__dirname, "..", "..", "public", "packs"),
    filename: "bundle.js",
    publicPath: "/packs/"
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      }
    ]
  },
  resolve: {
    extensions: [".js", ".jsx"]
  }
};
