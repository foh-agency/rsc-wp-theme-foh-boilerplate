<?php
/**
 * Theme features
 * 
 * @package foh
 */

/* Menu support */
add_theme_support( 'menus' );

/**
 * Add menu support and register menu locations
 */
function foh_nav_menus() {
	add_theme_support( 'menus' );
	
	register_nav_menus(
		array(
			'header' => esc_html__( 'Header', 'foh' ),
			'footer' => esc_html__( 'Footer', 'foh' ),
			'legal'  => esc_html__( 'Legal', 'foh' ),
		)
	);
}
add_action( 'init', 'foh_nav_menus' );

/* Blog area */

/**
 * Replaces the excerpt "Read More" text by a link
 * */
function foh_excerpt_more() {
	global $post;
	return '... <a class="moretag" href="' . get_permalink( $post->ID ) . '"> Read more</a>';
}
add_filter( 'excerpt_more', 'foh_excerpt_more' );
