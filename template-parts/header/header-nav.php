<?php
/**
 * Displays responsive header nav
 *
 * @package FOH
 * @since 1.0.0
 */
?>

<nav id="site-navigation" class="main-navigation">
	<a class="js-menu-link--open md:hidden"href="#main-nav-content"><?php esc_html_e( 'Open menu', 'foh' ); ?></a>
	<button class="js-menu-toggle-button hidden" aria-controls="foh-header-menu" aria-expanded="false"><?php esc_html_e( 'Menu', 'foh' ); ?></button>
	<!-- Header menu location -->
  <div id="main-nav-content" class="foh-drawer">
    <a class="js-menu-link--close md:hidden"href="#primary"><?php esc_html_e( 'Close menu', 'foh' ); ?></a>
    <?php
    wp_nav_menu(
      array(
        'theme_location'  => 'header',
        'menu_id'			  	=> 'foh-header-menu',
        'fallback_cb'		  => false,
      )
    );
    ?>
  </div>
</nav>
