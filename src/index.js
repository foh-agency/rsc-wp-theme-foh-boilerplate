// Styles
import './scss/main.scss';

// Local scripts
import { initWebComponents } from './js/web-components/init-web-components.js';
import { initScrollableHeader } from './js/foh-scroll-features.js';

// TODO: Consider better ways to import these files:

import './js/web-components/init-web-components.js';
// import './js/customizer.js'; // This depends on jQuery and it's not a priority to include it right now, so let's not.

(() => {
	function main() {
		initWebComponents();
		initScrollableHeader();
    const body = document.querySelector('body');
    body.classList.remove('foh-no-js');
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
