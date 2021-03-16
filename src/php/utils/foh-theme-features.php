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

/**
 * Register widget areas.
 *
 * @link https://developer.wordpress.org/themes/functionality/sidebars/#registering-a-sidebar
 */
function foh_widgets_init() {
	// Sidebar 1.
	register_sidebar(
		array(
			'name'          => esc_html__( 'Sidebar', 'foh' ),
			'id'            => 'sidebar-1',
			'description'   => esc_html__( 'Add widgets here.', 'foh' ),
			'before_widget' => '<section id="%1$s" class="widget %2$s">',
			'after_widget'  => '</section>',
			'before_title'  => '<h2 class="widget-title">',
			'after_title'   => '</h2>',
		)
	);

	// Footer widget area 1.
	register_sidebar(
		array(
			'name'          => esc_html__( 'Footer widget area 1', 'foh' ),
			'id'            => 'footer-widgets-1',
			'description'   => esc_html__( 'Add widgets here.', 'foh' ),
			'before_widget' => '<section id="%1$s" class="widget %2$s">',
			'after_widget'  => '</section>',
			'before_title'  => '<h2 class="widget-title">',
			'after_title'   => '</h2>',
		)
	);
}
add_action( 'widgets_init', 'foh_widgets_init' );

/* Blog area */

/**
 * Replaces the excerpt "Read More" text by a link
 * */
function foh_excerpt_more() {
	global $post;
	return '... <a class="moretag" href="' . get_permalink( $post->ID ) . '"> Read more</a>';
}
add_filter( 'excerpt_more', 'foh_excerpt_more' );
