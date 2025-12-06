/**
 * Handles toggling the navigation menu for small screens.
 * Some of this functionality was included with Underscores in navigation.js
 */
export default class ResponsiveNav extends HTMLElement {
  constructor() {
    super();
    this.siteNavigation = document.querySelector('#site-navigation');
    // Return early if the navigation don't exist.
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

    // bind event handlers
    this.initEventHandlers = this.initEventHandlers.bind(this);
    this.handleToggle = this.handleToggle.bind(this);
    this.handleClickOffMenu = this.handleClickOffMenu.bind(this);

    this.initEventHandlers();
  }

  // Toggle the .js-toggled class and the aria-expanded value each time the button is clicked.
  handleToggle() {
    if (this.toggleButton.getAttribute('aria-expanded') === 'true') {
      this.siteNavigation.classList.toggle('js-toggled');
      this.toggleButton.setAttribute('aria-expanded', 'false');
    } else {
      this.toggleButton.setAttribute('aria-expanded', 'true');
    }
  }

  handleClickOffMenu (event) {
    const isClickInside = this.siteNavigation.contains(event.target);
    if (!isClickInside) {
      this.siteNavigation.classList.remove('js-toggled');
      this.toggleButton.setAttribute('aria-expanded', 'false');
    }
  }

  initEventHandlers() {
    this.toggleButton.addEventListener('click', this.handleToggle );
      
    // Remove the .js-toggled class and set aria-expanded to false when the user clicks outside the navigation.
    document.addEventListener('click', this.handleClickOffMenu);
  }
}
