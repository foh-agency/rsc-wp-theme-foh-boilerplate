<?php
/**
 * Theme features
 * 
 * @package foh
 */

/* Menu support */
add_theme_support( 'menus' );

register_nav_menus(
	array(
		'header-menu' => __( 'Header Menu', 'foh' ),
		'footer-menu' => __( 'Footer Menu', 'foh' ),
	)
);

/* Blog area */

/**
 * Replaces the excerpt "Read More" text by a link
 * */
function foh_excerpt_more() {
	global $post;
	return '... <a class="moretag" href="' . get_permalink( $post->ID ) . '"> Read more</a>';
}
add_filter( 'excerpt_more', 'foh_excerpt_more' );
