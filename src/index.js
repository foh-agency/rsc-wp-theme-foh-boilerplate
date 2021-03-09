// Styles
import './scss/main.scss';

// TODO: Consider better ways to import these default Underscores files:
import './js/navigation.js';
// import './js/customizer.js'; // This depends on jQuery and it's not a priority to include it right now, so let's not.

(() => {
	function main() {
		console.log(`Hello world!`);
	}

	try {
		main();
		if (module.hot) {
			module.hot.accept();
		}
	} catch (error) {
		// eslint-disable-next-line no-console
		console.log(error.message, 'A problem occurred (caught at top level)');
	}
})();
