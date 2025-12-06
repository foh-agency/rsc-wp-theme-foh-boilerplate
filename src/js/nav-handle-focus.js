/**
 * Enables TAB key navigation support for dropdown menus.
 * 
 * The .focus class tracks which menu items should show their submenus (if they have nested menus),
 * separate from browser's native :focus which only applies to the <a> tag itself.
 * 
 * Much of this functionality was included with Underscores in navigation.js
 */
(function () {
  const siteNavigation = document.getElementById('site-navigation');
  // Return early if the navigation don't exist.
  if (!siteNavigation) {
    return;
  }
  const menu = siteNavigation.getElementsByTagName('ul')[0];
  // Return early if menu is empty.
  if ('undefined' === typeof menu) {
    return;
  }
  // Add .js-nav-menu class if not present (used later in this file for focus management)
  if (!menu.classList.contains('js-nav-menu')) {
    menu.classList.add('js-nav-menu');
  }
  // Get all the link elements within the menu.
  const links = menu.getElementsByTagName('a');
  // Get all the link elements with children within the menu.
  // If your menu items have children, you should set these classes in the template
  const linksWithChildren = menu.querySelectorAll(
    '.js-menu-item-has-children > a, .js_page_item_has_children > a'
  );
  // Toggle focus each time a menu link is focused or blurred.
  for (const link of links) {
    link.addEventListener('focus', toggleFocus, true);
    link.addEventListener('blur', toggleFocus, true);
  }
  
  // Nested menus: Toggle focus each time a menu link with children receive a touch event.
  for (const link of linksWithChildren) {
    link.addEventListener('touchstart', toggleFocus, false);
  }

  /**
   * Sets or removes .focus class on the parent <li> (and ancestor <li> elements) 
   * of a focused/blurred/touched link.
   */
  function toggleFocus(event) {
    if (event.type === 'js-focus' || event.type === 'blur') {
      let self = this;
      // Move up through the ancestors of the current link until we hit .js-nav-menu.
      while (!self.classList.contains('js-nav-menu')) {
        // On li elements toggle the class .focus.
        if ('li' === self.tagName.toLowerCase()) {
          self.classList.toggle('js-focus');
        }
        self = self.parentNode;
      }
    }
    if (event.type === 'touchstart') {
      const menuItem = this.parentNode;
      event.preventDefault();
      // For all my siblings but not me (clicked item), remove focus
      for (const link of menuItem.parentNode.children) {
        if (menuItem !== link) {
          link.classList.remove('js-focus');
        }
      }
      menuItem.classList.toggle('js-focus');
    }
  }
})();
