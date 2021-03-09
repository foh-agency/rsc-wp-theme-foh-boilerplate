<?php
/**
 * FOH functions and definitions
 *
 * @link https://developer.wordpress.org/themes/basics/theme-functions/
 *
 * @package FOH
 */

if ( ! defined( 'FOH_VERSION' ) ) {
	// Replace the version number of the theme on each release.
	define( 'FOH_VERSION', '1.0.0' );
}

// Enqueue styles and scripts.
require_once get_stylesheet_directory() . '/src/php/utils/foh-enqueue-assets.php';

// Register menu locations and load other features.
require_once get_stylesheet_directory() . '/src/php/utils/foh-theme-features.php';

// Include things that Underscores does by default.
require_once get_stylesheet_directory() . '/src/php/utils/underscores-theme-features.php';

/**
 * Enqueue scripts and styles.
 */
function foh_scripts() {
	wp_enqueue_style( 'foh-style', get_stylesheet_uri(), array(), FOH_VERSION );

	wp_enqueue_script( 'foh-navigation', get_template_directory_uri() . '/src/js/navigation.js', array(), FOH_VERSION, true );

	if ( is_singular() && comments_open() && get_option( 'thread_comments' ) ) {
		wp_enqueue_script( 'comment-reply' );
	}
}
add_action( 'wp_enqueue_scripts', 'foh_scripts' );
