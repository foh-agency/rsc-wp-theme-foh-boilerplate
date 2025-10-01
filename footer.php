<?php
/**
 * The template for displaying the footer
 *
 * Contains the closing of the #content div and all content after.
 *
 * @link https://developer.wordpress.org/themes/basics/template-files/#template-partials
 *
 * @package ELTHEME
 */

?>

	<footer id="colophon" class="site-footer">
		<!-- Footer menu location -->
		<nav id="eltheme-footer-navigation">
			<?php
			wp_nav_menu(
				array(
					'theme_location' => 'footer',
					'menu_id'        => 'eltheme-footer-menu',
					'depth'          => 1,
					'fallback_cb'    => false,
				)
			);
			?>
		</nav><!-- #eltheme-footer-navigation -->

		<!-- Footer widget area 1 -->
		<?php get_sidebar( 'footer-1' ); ?>

		<!-- Legal menu location -->
		<nav id="eltheme-legal-navigation">
			<?php
			wp_nav_menu(
				array(
					'theme_location' => 'legal',
					'menu_id'        => 'eltheme-legal-menu',
					'fallback_cb'    => false,
				)
			);
			?>
		</nav><!-- #eltheme-legal-navigation -->

		<div class="site-info">
			<?php $eltheme_blog_info = get_bloginfo( 'name' ); ?>
			<?php if ( ! empty( $eltheme_blog_info ) ) : ?>
				<?php echo esc_html( sprintf( '&copy; %s %s', $eltheme_blog_info, date_format( date_create(), 'o' ) ) ); ?>
			<?php endif; ?>
		</div><!-- .site-info -->
	</footer><!-- #colophon -->
</div><!-- #page -->

<?php wp_footer(); ?>

</body>
</html>
