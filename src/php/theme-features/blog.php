<?php
/**
 * Blog features
 * 
 * @package foh
 */

/**
 * Replace the excerpt "Read More" text by a link
 * */
function foh_excerpt_more() {
	global $post;
	return '... <a class="moretag" href="' . get_permalink( $post->ID ) . '"> Read more</a>';
}
add_filter( 'excerpt_more', 'foh_excerpt_more' );
