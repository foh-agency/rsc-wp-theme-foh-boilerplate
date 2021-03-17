<?php
/**
 * Navigation features
 * 
 * @package foh
 */

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
