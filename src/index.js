// Styles
import './scss/main.scss';

// Local scripts
import { initScrollableHeader } from './js/foh-scroll-features.js';

// TODO: Consider better ways to import these default Underscores files:
import './js/nav-handle-focus.js';
import './js/nav-toggle-mobile-drawer.js';
// import './js/customizer.js'; // This depends on jQuery and it's not a priority to include it right now, so let's not.

(() => {
	function main() {
		initScrollableHeader();
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
