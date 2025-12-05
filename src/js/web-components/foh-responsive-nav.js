/**
 * Handles toggling the navigation menu for small screens.
 * Some of this functionality was included with Underscores in navigation.js
 */
export default class ResponsiveNav extends HTMLElement {
  
  constructor() {
    super();
    // Return early if the navigation don't exist.
    this.siteNavigation = this.querySelector('#site-navigation'); // private property
    if (!this.siteNavigation) {
      return;
    }
    // Return early if the button doesn't exist.
    this.toggleButton = this.siteNavigation.querySelector('.js-menu-toggle-button');
    if ('undefined' === typeof this.toggleButton) {
      return;
    }
    // Hide menu toggle button if menu is empty and return early.
    this.menu = this.siteNavigation.getElementsByTagName('ul')[0];
    if ('undefined' === typeof this.menu) {
      this.toggleButton.style.display = 'none';
      return;
    }

    this.initEventHandlers = this.initEventHandlers.bind(this);
    this.initEventHandlers(this.siteNavigation);
  }

  initEventHandlers(siteNavigation) {
    // Toggle the .js-toggled class and the aria-expanded value each time the button is clicked.
    this.toggleButton.addEventListener('click', function () {
      if (this.toggleButton.getAttribute('aria-expanded') === 'true') {
        siteNavigation.classList.toggle('js-toggled');
        this.toggleButton.setAttribute('aria-expanded', 'false');
      } else {
        this.toggleButton.setAttribute('aria-expanded', 'true');
      }
    });
    // Remove the .js-toggled class and set aria-expanded to false when the user clicks outside the navigation.
    document.addEventListener('click', function (event) {
      const isClickInside = siteNavigation.contains(event.target);
      if (!isClickInside) {
        siteNavigation.classList.remove('js-toggled');
        this.toggleButton.setAttribute('aria-expanded', 'false');
      }
    });
  }
}
