<?php
/**
 * Blog features
 * 
 * @package eltheme
 */

/**
 * Replace the excerpt "Read More" text by a link
 * */
function eltheme_excerpt_more() {
	global $post;
	return '... <a class="moretag" href="' . get_permalink( $post->ID ) . '"> Read more</a>';
}
add_filter( 'excerpt_more', 'eltheme_excerpt_more' );
