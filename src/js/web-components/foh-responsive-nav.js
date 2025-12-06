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

    // Bind event handlers
    this.handleToggle = this.handleToggle.bind(this);
    this.handleClickOffMenu = this.handleClickOffMenu.bind(this);
  }

  // Show the JS-enabled toggleButton, instead of the no-JS open/close links
  initMenuToggle() {
    const openLink = this.querySelector('.js-menu-link--open');
    const closeLink = this.querySelector('.js-menu-link--close');

    if (openLink) { openLink.classList.add('hidden'); }
    if (closeLink) { closeLink.classList.add('hidden'); }
    this.toggleButton.classList.remove('hidden');
  }

  // Toggle aria-expanded value each time the button is clicked.
  handleToggle() {
    if (this.toggleButton.getAttribute('aria-expanded') === 'true') {
      this.toggleButton.setAttribute('aria-expanded', 'false');
    } else {
      this.toggleButton.setAttribute('aria-expanded', 'true');
    }
  }

  handleClickOffMenu (event) {
    const isClickInside = this.siteNavigation.contains(event.target);
    if (!isClickInside) {
      this.toggleButton.setAttribute('aria-expanded', 'false');
    }
  }

  // TODO: check these things are running
  connectedCallback() {
    this.initMenuToggle();

    this.toggleButton.addEventListener('click', this.handleToggle );
      
    // Close the menu when the user clicks outside the navigation.
    document.addEventListener('click', this.handleClickOffMenu);
  }

  // TODO: disconnected callback to remove listeners
}
