const path = require('path');
const { WebpackManifestPlugin } = require('webpack-manifest-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const BrowserSyncPlugin = require('browser-sync-webpack-plugin');

// Prepare project paths
// For local development, we need to specify the name of dir that holds wp-config.php
const siteRoot =
	process.env.NODE_ENV === 'development' ? 'foh-starter-theme-test/' : '';
// And the theme dir
const themeFragment = 'wp-content/themes/foh/';

module.exports = {
	context: path.resolve(__dirname), // Look in project root for all paths. Docs recommend including a context.
	entry: {
		main: path.resolve(__dirname, 'src', './index.js'),
	},
	module: {
		rules: [
			{
				// test for any filetypes required within CSS
				test: /\.(woff|woff2|ttf|eot|svg|webp|png|jpg|gif|ico)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
				type: 'asset/resource',
				use: [
					{
						loader: 'url-loader',
					},
				],
			},
			{
				test: /\.scss$/,
				use: [
					MiniCssExtractPlugin.loader,
					{
						loader: 'css-loader',
						options: { importLoaders: 1, sourceMap: true },
					},
					{
						loader: 'postcss-loader',
						options: {
							postcssOptions: {
								plugins: [
									[
										'postcss-preset-env',
										'cssnano',
										{
											ident: 'postcss',
											sourceMap: true,
										},
									],
								],
							},
						},
					},
					{ loader: 'sass-loader', options: { sourceMap: true } }, // users 'fibers' dependency for faster compile
				],
			},
		],
	},
	plugins: [
		// BrowserSync only runs with webpack-dev-server (npm run start).
		// TODO: Consider moving to the dev config
		new BrowserSyncPlugin({
			// browse to http://localhost:3000/ during development,
			// ./public directory is being served
			host: 'localhost',
			port: 3000,
			proxy: `http://localhost:8888/${siteRoot}`, // BrowserSync acts as a proxy that makes requests to the PHP server (e.g. MAMP)
		}),
		new WebpackManifestPlugin({
			// this publicPath is used by php to load css and js files
			// (./php/enqueue_assets.php gets it from ./dist/manifest.json,
			// which is output by WebpackManifestPlugin which uses this path)
			publicPath: '/',
		}),
		new MiniCssExtractPlugin({
			filename: '[name].[contenthash].css',
		}),
		new CleanWebpackPlugin(),
	],
	// SplitChunksPlugin
	// Split everything real small for better caching (HTTP requests are ok on HTTP/2 these days, esp on small sites under a few hundred requests)
	// Thanks to this blogger: https://medium.com/hackernoon/the-100-correct-way-to-split-your-chunks-with-webpack-f8a9df5b7758
	optimization: {
		moduleIds: 'deterministic',
		runtimeChunk: 'single',
		splitChunks: {
			chunks: 'all',
			maxInitialRequests: Infinity,
			minSize: 0,
			cacheGroups: {
				defaultVendors: {
					test: /[\\/]node_modules[\\/]/,
					// make one file per package
					name(module) {
						// get the name. E.g. node_modules/packageName/not/this/part.js
						// or node_modules/packageName
						const packageName = module.context.match(
							/[\\/]node_modules[\\/](.*?)([\\/]|$)/
						)[1];

						// npm package names are URL-safe, but some servers don't like @ symbols
						// Note: Edited code from linked blog post to avoid adding a dot to the filename
						// because the dot is used as a delimiter for naming scripts to be enqueued
						// in custom PHP func load_scripts
						return `npm-${packageName.replace('@', '')}`;
					},
				},
			},
		},
	},
	// TODO: Webpack 5 migration guide says i shouldn't have errors if i run these, but i do. https://webpack.js.org/migrate/5/
	// TODO: after testing successful migration, remove this node obj
	// node: {
	//   Buffer: false,
	//   process: false
	// },
	output: {
		// publicPath tells runtime.js where to look for dependencies
		// (e.g. dynamically imported scripts)
		publicPath: `/${siteRoot}${themeFragment}dist/`,
		filename: '[name].[contenthash].js',
		path: path.resolve(__dirname, 'dist'),
		assetModuleFilename: '[name].[contenthash][ext]',
	},
};
