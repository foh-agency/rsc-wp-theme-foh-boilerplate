/**
 * Handles toggling the navigation menu for small screens.
 * Some of this functionality was included with Underscores in navigation.js
 */
import { handleFocusOnDropdownEnabledNav } from './foh-responsive-nav-handle-focus';

export default class ResponsiveNav extends HTMLElement {
  
  constructor() {
    super();
    this.siteNavigation = this.querySelector('#site-navigation'); // private property
    this.button = this.siteNavigation.querySelector('.js-menu-toggle-button');
    this.menu = this.siteNavigation.getElementsByTagName('ul')[0];

    // Return early if the navigation don't exist.
    if (!this.siteNavigation) {
      return;
    }
    // Return early if the button doesn't exist.
    if ('undefined' === typeof this.button) {
      return;
    }
    // Hide menu toggle button if menu is empty and return early.
    if ('undefined' === typeof this.menu) {
      this.button.style.display = 'none';
      return;
    }

    this.initEventHandlers = this.initEventHandlers.bind(this);
    this.initEventHandlers(this.siteNavigation);

    handleFocusOnDropdownEnabledNav();
  }

  initEventHandlers(siteNavigation) {
    // Toggle the .js-toggled class and the aria-expanded value each time the button is clicked.
    this.button.addEventListener('click', function () {
      if (this.button.getAttribute('aria-expanded') === 'true') {
        siteNavigation.classList.toggle('js-toggled');
        this.button.setAttribute('aria-expanded', 'false');
      } else {
        this.button.setAttribute('aria-expanded', 'true');
      }
    });
    // Remove the .js-toggled class and set aria-expanded to false when the user clicks outside the navigation.
    document.addEventListener('click', function (event) {
      const isClickInside = siteNavigation.contains(event.target);
      if (!isClickInside) {
        siteNavigation.classList.remove('js-toggled');
        this.button.setAttribute('aria-expanded', 'false');
      }
    });
  }
}
