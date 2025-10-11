<?php
/**
 * Navigation features
 * 
 * @package eltheme
 */

/**
 * Add menu support and register menu locations
 */
function eltheme_nav_menus() {
	add_theme_support( 'menus' );
	
	register_nav_menus(
		array(
			'header' => esc_html__( 'Header', 'eltheme' ),
			'footer' => esc_html__( 'Footer', 'eltheme' ),
			'legal'  => esc_html__( 'Legal', 'eltheme' ),
		)
	);
}
add_action( 'init', 'eltheme_nav_menus' );

/**
 * Get breadcrumbs for current post.
 * 
 * @param WP_Post $post WP_Post object.
 * @return string $breadcrumbs div.eltheme-breadcrumbs
 */
function eltheme_get_breadcrumbs( $post ) {
	$breadcrumbs = array();

	// Sort higher-level posts first.
	$ancestors = array_reverse( get_post_ancestors( $post ) );

	// Start the list.
	$breadcrumbs[] = '
		<div class="eltheme-breadcrumbs">
			<ul>
	';

	// Populate the list with links to ancestors.
	foreach ( $ancestors as $ancestor ) {
		$breadcrumbs[] = '<li>'
										. '<a href="'
										. get_permalink( $ancestor )
										. '">'
										. get_the_title( $ancestor )
										. '</a>'
										. '</li>';
	}

	// Add a final list item with the current post title.
	$breadcrumbs[] = '<li>' . get_the_title( $post ) . '</li>';

	// End the list.
	$breadcrumbs[] = '
			</ul>
		</div><!-- .eltheme-breadcrumbs -->
	';

	return join( $breadcrumbs );
}

/**
 * Contextual navigation for subpages (Prev and Next links).
 * 
 * The functions below ensure that pages are sorted according
 * to the 'order' field set for each page, instead of the
 * default reverse-chronological order)
 */

/**
 * 
 * Filter used to modify part of the query in eltheme_get_context_nav_links
 * Applied to WordPress filters:
 * - get_previous_post_sort
 * - get_next_post_sort
 * 
 * Change the ORDER query from something like this:
 * 
 * ORDER BY p.post_date DESC LIMIT 1
 * 
 * to something like this:
 * 
 * ORDER BY menu_order DESC LIMIT 1
 * 
 * These params will be passed in from link-template.php:
 * 
 * @param string $order_by The `ORDER BY` clause in the SQL,
 * expected to be invoked with the value:
 * 'ORDER BY p.post_date DESC LIMIT 1'.
 */
function eltheme_sort_by_menu_order( $order_by ) {
	// Replace 'p.post_date' so we're sorting by 'menu_order' instead.
	$new_order = str_replace( 'p.post_date', 'menu_order', $order_by );
	return $new_order;
}

/**
 * Filter used to modify part of the query in eltheme_get_context_nav_links
 * Applied to WordPress filters:
 * - get_previous_post_where
 * - get_next_post_where
 * 
 * Change the WHERE query from something like this:
 * 
 * WHERE
 * p.post_date < '2020-10-15 16:14:15'
 * AND
 * p.post_type = 'page'
 * AND
 * ( p.post_status = 'publish' OR p.post_status = 'private' )
 * 
 * to something like this:
 * 
 * WHERE
 * menu_order < '10'
 * AND
 * p.post_type = 'page'
 * AND
 * ( p.post_status = 'publish' OR p.post_status = 'private' )
 * AND
 * ( p.post_parent = wp_get_post_parent_id( $post ) )
 * 
 * These params will be passed in from link-template.php:
 * 
 * @param string  $where          The `WHERE` clause in the SQL.
 * @param bool    $in_same_term   Whether post should be in a same taxonomy term.
 * @param array   $excluded_terms Array of excluded term IDs.
 * @param string  $taxonomy       Used to identify the term used when `$in_same_term` is true.
 * @param WP_Post $post           WP_Post object.
 * @return string $new_where Described above.
 */
function eltheme_query_adjacent_sibling_by_menu_order( $where, $in_same_term, $excluded_terms, $taxonomy, $post ) {
	$parent_id = wp_get_post_parent_id( $post );

	// Sort by menu_order.
	$new_where = str_replace( 'p.post_date', 'menu_order', $where );
	// Compare to current post's menu_order.
	$new_where = str_replace( $post->post_date, $post->menu_order, $new_where );
	// Restrict search to siblings under the same parent page.
	$new_where .= " AND ( p.post_parent = {$parent_id} )";

	return $new_where;
}

/**
 * Return a nav element with links to prev and next pages under the same parent.
 * 
 * This func takes the following approach:
 * 
 * 1. Add custom filters (update the order of posts so we get the right links).
 * 2. Call a WP func that uses these filters to generate a <nav>.
 * 3. Undo custom filters so they don't reorder other parts of the site.
 * 4. Return the <nav>.
 * 
 * @param WP_Post $post WP_Post object.
 * @return string <nav>
 */
function eltheme_get_context_nav_links( $post ) {
	$parent = get_post( wp_get_post_parent_id( $post ) );

	// Go by menu order instead of the default chronological order.
	add_filter( 'get_previous_post_sort', 'eltheme_sort_by_menu_order' );
	add_filter( 'get_next_post_sort', 'eltheme_sort_by_menu_order' );

	/**
	 * Only look for prev and next pages under the same parent.
	 * 
	 * The final integer arg here needs to indicate the number of
	 * args accepted by eltheme_query_adjacent_sibling_by_menu_order.
	 */
	add_filter( 'get_previous_post_where', 'eltheme_query_adjacent_sibling_by_menu_order', 10, 5 );
	add_filter( 'get_next_post_where', 'eltheme_query_adjacent_sibling_by_menu_order', 10, 5 );

	$args = array(
		'prev_text'          => '%title',
		'next_text'          => '%title',
		'in_same_term'       => false,
		'excluded_terms'     => '',
		'taxonomy'           => 'category',
		'screen_reader_text' => "{$parent->post_title} navigation",
		'aria_label'         => "{$parent->post_name} navigation",
		'class'              => "{$parent->post_name}-navigation",
	);

	// Query the DB using the filters registered above.
	$nav_html = get_the_post_navigation( $args );

	/**
	 * Remove filters so the post nav works the default way in other areas
	 * (e.g. if it's used to navigate blog posts).
	 */
	remove_filter( 'get_previous_post_where', 'eltheme_query_adjacent_sibling_by_menu_order', 10, 5 );
	remove_filter( 'get_next_post_where', 'eltheme_query_adjacent_sibling_by_menu_order', 10, 5 );
	remove_filter( 'get_previous_post_sort', 'eltheme_sort_by_menu_order' );
	remove_filter( 'get_next_post_sort', 'eltheme_sort_by_menu_order' );

	return $nav_html;
}
add_action( 'wp_enqueue_scripts', 'eltheme_get_context_nav_links' );
