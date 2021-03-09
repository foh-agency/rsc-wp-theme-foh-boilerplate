const path = require('path');
const { merge } = require('webpack-merge');
const common = require('./webpack.common');

module.exports = merge(common, {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    contentBase: path.join(__dirname, 'dist'),
    writeToDisk: true,
    hot: true,
  },
  optimization: {
    // outputs comments to non-minified dev bundle indicating dead code as "unused harmony export"
    usedExports: true
  },
});
