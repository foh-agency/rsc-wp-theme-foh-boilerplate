<?php
/**
 * The template for displaying the footer
 *
 * Contains the closing of the #content div and all content after.
 *
 * @link https://developer.wordpress.org/themes/basics/template-files/#template-partials
 *
 * @package FOH
 */

?>

	<footer id="colophon" class="site-footer">
		<!-- Footer menu location -->
		<nav id="foh-footer-navigation">
			<?php
			wp_nav_menu(
				array(
					'theme_location' => 'footer',
					'menu_id'        => 'foh-footer-menu',
					'depth'          => 1,
					'fallback_cb'    => false,
				)
			);
			?>
		</nav><!-- #foh-footer-navigation -->

		<!-- Legal menu location -->
		<nav id="foh-legal-navigation">
			<?php
			wp_nav_menu(
				array(
					'theme_location' => 'legal',
					'menu_id'        => 'foh-legal-menu',
					'fallback_cb'    => false,
				)
			);
			?>
		</nav><!-- #foh-legal-navigation -->

		<div class="site-info">
			<a href="<?php echo esc_url( __( 'https://wordpress.org/', 'foh' ) ); ?>">
				<?php
				/* translators: %s: CMS name, i.e. WordPress. */
				printf( esc_html__( 'Proudly powered by %s', 'foh' ), 'WordPress' );
				?>
			</a>
			<span class="sep"> | </span>
				<?php
				/* translators: 1: Theme name, 2: Theme author. */
				printf( esc_html__( 'Theme: %1$s by %2$s.', 'foh' ), 'foh', '<a href="https://www.foh-agency.com/">FOH Agency</a>' );
				?>
		</div><!-- .site-info -->
	</footer><!-- #colophon -->
</div><!-- #page -->

<?php wp_footer(); ?>

</body>
</html>
