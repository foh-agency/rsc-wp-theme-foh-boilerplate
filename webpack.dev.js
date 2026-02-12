const path = require('path');
const { merge } = require('webpack-merge');
const common = require('./webpack.common');

module.exports = merge(common, {
	mode: 'development',
	devtool: 'inline-source-map',
	devServer: {
		static: {
			directory: path.join(__dirname, 'dist'),
		},
		hot: true,
		devMiddleware: {
			writeToDisk: true,
		},
	},
	optimization: {
		// outputs comments to non-minified dev bundle indicating dead code as "unused harmony export"
		usedExports: true,
	},
});
