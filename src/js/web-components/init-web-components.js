import ResponsiveNav from './foh-responsive-nav';
import MainNavContent from './foh-main-nav-content';

export function initWebComponents() {
  customElements.define('foh-responsive-nav', ResponsiveNav);
  customElements.define('foh-main-nav-content', MainNavContent);
}
