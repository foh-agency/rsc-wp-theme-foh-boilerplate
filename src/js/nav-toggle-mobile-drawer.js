/**
 * Handles toggling the navigation menu for small screens.
 * Some of this functionality was included with Underscores in navigation.js
 */
(function () {
  const siteNavigation = document.getElementById('site-navigation');
  // Return early if the navigation don't exist.
  if (!siteNavigation) {
    return;
  }
  const button = siteNavigation.querySelector('.js-menu-toggle')[0];
  // Return early if the button doesn't exist.
  if ('undefined' === typeof button) {
    return;
  }
  const menu = siteNavigation.getElementsByTagName('ul')[0];
  // Hide menu toggle button if menu is empty and return early.
  if ('undefined' === typeof menu) {
    button.style.display = 'none';
    return;
  }
  // Toggle the .js-toggled class and the aria-expanded value each time the button is clicked.
  button.addEventListener('click', function () {
    siteNavigation.classList.toggle('js-toggled');
    if (button.getAttribute('aria-expanded') === 'true') {
      button.setAttribute('aria-expanded', 'false');
    } else {
      button.setAttribute('aria-expanded', 'true');
    }
  });
  // Remove the .js-toggled class and set aria-expanded to false when the user clicks outside the navigation.
  document.addEventListener('click', function (event) {
    const isClickInside = siteNavigation.contains(event.target);
    if (!isClickInside) {
      siteNavigation.classList.remove('js-toggled');
      button.setAttribute('aria-expanded', 'false');
    }
  });
})();
