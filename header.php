<?php
/**
 * The header for our theme
 *
 * This is the template that displays all of the <head> section and everything up until <div id="content">
 *
 * @link https://developer.wordpress.org/themes/basics/template-files/#template-partials
 *
 * @package FOH
 */

?>
<!doctype html>
<html <?php language_attributes(); ?>>
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- TODO: consider removing this link. Here's what it's for: https://www.usablewp.com/wordpress-xfn-link-tag/ -->
	<link rel="profile" href="https://gmpg.org/xfn/11">

	<?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>
<?php wp_body_open(); ?>
<div id="page" class="site">
	<a class="skip-link screen-reader-text" href="#primary"><?php esc_html_e( 'Skip to content', 'foh' ); ?></a>

	<header class="
		js-masthead
		flex
		justify-between
		">
		<div class="js-header-logo">
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

		<nav id="site-navigation" class="main-navigation">
			<button class="menu-toggle" aria-controls="foh-header-menu" aria-expanded="false"><?php esc_html_e( 'Menu', 'foh' ); ?></button>
			<!-- Header menu location -->
			<?php
			wp_nav_menu(
				array(
					'theme_location' => 'header',
					'menu_id'        => 'foh-header-menu',
					'fallback_cb'    => false,
				)
			);
			?>
		</nav>
	</header>
