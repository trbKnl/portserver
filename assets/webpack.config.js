const path = require("path");

module.exports = {
    entry: {
      app: "./js/app.js",
    },
    output: {
      filename: "[name].js",
      path: path.resolve(__dirname, "../priv/static/js"),
      publicPath: "/js/",
      //filename: "[name].js",
      //path: path.resolve(__dirname, "../priv/static"),
    },
    module: {
      rules: [
        {
          test: /\.m?js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: [
                ['@babel/preset-env', { targets: "defaults" }],
              ]
            }
          }
        },
        {
          test: /\.css$/,
          use: ['style-loader', 'css-loader'],
        },
        {
          test: /\.whl$/,
          type: 'asset/resource',
          generator: {
            filename: '[name][ext]',
            publicPath: '/',
            outputPath: '..',
          }
        },
        {
          test: /\.(woff(2)?|ttf|otf|woff|woff2|eot|svg)(\?v=\d+\.\d+\.\d+)?$/,
          type: 'asset/resource',
        },
      ],
    },
}
