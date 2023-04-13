const path = require("path");
const CopyPlugin = require("copy-webpack-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
    entry: {
      app:"./js/app.js"
    },
    output: {
      filename: "[name].js",
      path: path.resolve(__dirname, "../priv/static/js"),
      publicPath: "/js/",
      //filename: "[name].js",
      //path: path.resolve(__dirname, "../priv/static"),
    },
    optimization: {
    minimizer: [
      // For webpack@5 you can use the `...` syntax to extend existing minimizers (i.e. `terser-webpack-plugin`), uncomment the next line
      `...`,
      new CssMinimizerPlugin(),
    ],
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
          test: /\.css$/i,
          use: [
            MiniCssExtractPlugin.loader,
            "css-loader",
            "postcss-loader",
          ],
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
    plugins: [
      new MiniCssExtractPlugin({
        filename: "../assets/[name].css"
      }),
    //  new MiniCssExtractPlugin(),
    //  new CopyPlugin({
    //    patterns: [
    //      { 
    //        from: "./node_modules/port/dist/styles.css", 
    //        to: path.resolve(__dirname, "../priv/static/assets"),
    //      },
    //  ],
    //}),
    ],
}
