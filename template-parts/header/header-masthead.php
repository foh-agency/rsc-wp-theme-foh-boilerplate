<?php
/**
 * Displays header bar
 *
 * @package FOH
 * @since 1.0.0
 */
?>
<!-- 
z-index usage:
- grouped by tens (10 and 15 belong together)
- increase in increments of 5, as a starting point.

z-index relating to header and nav:
26: button.js-menu-toggle-button
25: a.js-menu-link--close
20: foh-main-nav-content#main-nav-content.foh-drawer
15: a.js-menu-link--open
10: header.js-masthead
0 (default): page content

(elements with 25 and 26 are not expected to coexist, but a clear winner is defined just in case)
-->

<header class="
	js-masthead
	flex
	justify-between
  z-10
	">
	<div class="js-header-logo hidden md:inline-block">
		<?php
		the_custom_logo();
		if ( is_front_page() && is_home() ) :
			?>
			<h1 class="site-title"><a href="<?php echo esc_url( home_url( '/' ) ); ?>" rel="home"><?php bloginfo( 'name' ); ?></a></h1>
			<?php
		else :
			?>
			<p class="site-title"><a href="<?php echo esc_url( home_url( '/' ) ); ?>" rel="home"><?php bloginfo( 'name' ); ?></a></p>
			<?php
		endif;
		$foh_description = get_bloginfo( 'description', 'display' );
		if ( $foh_description || is_customize_preview() ) :
			?>
			<p class="site-description"><?php echo $foh_description; // phpcs:ignore WordPress.Security.EscapeOutput.OutputNotEscaped ?></p>
		<?php endif; ?>
	</div>

	<!-- NAVIGATION -->
	<?php if ( has_nav_menu( 'header' ) ) : ?>
		<?php get_template_part( 'template-parts/header/header', 'nav' );	?>
	<?php endif; ?>
</header>
