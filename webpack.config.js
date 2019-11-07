const path = require('path');
// const glob = require('glob');
const webpack = require('webpack');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const ManifestPlugin = require('webpack-manifest-plugin');

// glob.sync('./front/javascripts/**/*.js').map(function(file) {
//   let name = file.split('/')[4].split('.')[0];
//   entries[name] = file;
// });

module.exports = (env, argv) => {
  const IS_DEV = argv.mode === 'development';

  return {
    entry: {
      application: './front/javascripts/index.js' ,
      simulation: './front/javascripts/simulation.js' 
    },

    // devtool: IS_DEV ? 'source-map' : 'none',
    output: {
      filename: 'javascripts/[name]-[hash].js',
      path: path.resolve(__dirname, 'public/assets')
    },
    plugins: [
      new MiniCssExtractPlugin({
        filename: 'stylesheets/[name]-[hash].css'
      }),
      new webpack.HotModuleReplacementPlugin(),
      new ManifestPlugin({
        writeToFileEmit: true
      })
    ],
    module: {
      rules: [
        {
          test: /\.(c|sc)ss$/,
          use: [
            {
              loader: MiniCssExtractPlugin.loader,
              options: {
                publicPath: path.resolve(__dirname, 'public/assets/stylesheets')
              }
            },
            'css-loader',
            'sass-loader'
          ]
        },
        {
          test: /\.(jpg|png|gif)$/,
          loader: 'file-loader',
          options: {
            name: '[name]-[hash].[ext]',
            outputPath: 'images',
            publicPath: function(path) {
              return 'images/' + path
            }
          }
        }
      ]
    }
  }
};
