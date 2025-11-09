<?php
/**
 * Displays responsive header nav
 *
 * @package FOH
 * @since 1.0.0
 */
?>

<nav id="site-navigation" class="main-navigation">
	<button class="js-menu-toggle" aria-controls="foh-header-menu" aria-expanded="false"><?php esc_html_e( 'Menu', 'foh' ); ?></button>
	<!-- Header menu location -->
	<?php
	wp_nav_menu(
		array(
			'theme_location'  => 'header',
			'menu_id'			  	=> 'foh-header-menu',
			'fallback_cb'		  => false,
		)
	);
	?>
</nav>
