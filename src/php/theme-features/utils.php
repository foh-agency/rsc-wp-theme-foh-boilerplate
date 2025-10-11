<?php
/**
 * Utility functions.
 *
 * @package eltheme
 */

/**
 * Determine whether the current post is at the top level (no ancestors).
 * 
 * @param WP_Post $post WP_Post object.
 * @return bool is_top_level
 */
function eltheme_is_top_level( $post ) {
	$levels_deep = count( get_post_ancestors( $post ) );
	return 0 === $levels_deep;
}
