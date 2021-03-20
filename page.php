<?php
/**
 * The template for displaying all pages
 *
 * This is the template that displays all pages by default.
 * Please note that this is the WordPress construct of pages
 * and that other 'pages' on your WordPress site may use a
 * different template.
 *
 * @link https://developer.wordpress.org/themes/basics/template-hierarchy/
 *
 * @package FOH
 */

get_header();
?>

	<main id="primary" class="site-main">

		<?php
		while ( have_posts() ) :
			the_post();

			get_template_part( 'template-parts/content', 'page' );

		endwhile; // End of the loop.
		
		if ( ! foh_is_top_level( $post ) ) {
			// Link to Prev and Next pages under the same parent, if available.
			echo wp_kses( foh_get_context_nav_links( $post ), 'post' );

			// Display breadcrumbs.
			echo wp_kses( foh_get_breadcrumbs( $post ), 'post' );
		}
		?>

	</main><!-- #main -->

<?php
get_sidebar();
get_footer();
