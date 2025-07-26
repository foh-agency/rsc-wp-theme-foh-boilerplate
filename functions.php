<?php
/**
 * Functions and definitions for FOH starter theme
 *
 * @link https://developer.wordpress.org/themes/basics/theme-functions/
 *
 * @package FOH
 */

if ( ! defined( 'ELTHEME_VERSION' ) ) {
	// Replace the version number of the theme on each release.
	define( 'ELTHEME_VERSION', '1.0.0' );
}

/**
 * Housekeeping
 */

// Enqueue eltheme scripts and styles from dist/ (Webpack).
require_once get_stylesheet_directory() . '/src/php/eltheme-features/enqueue-assets.php';

/**
 * Enqueue Underscores scripts and styles.
 */
function eltheme_scripts() {
	wp_enqueue_style( 'eltheme-style', get_stylesheet_uri(), array(), ELTHEME_VERSION );

	wp_enqueue_script( 'eltheme-navigation', get_template_directory_uri() . '/src/js/navigation.js', array(), ELTHEME_VERSION, true );

	if ( is_singular() && comments_open() && get_option( 'thread_comments' ) ) {
		wp_enqueue_script( 'comment-reply' );
	}
}
add_action( 'wp_enqueue_scripts', 'eltheme_scripts' );

// Load utility functions.
require_once get_stylesheet_directory() . '/src/php/eltheme-features/utils.php';

/**
 * Features
 */

// Load blog features.
require_once get_stylesheet_directory() . '/src/php/eltheme-features/blog.php';

// Load navigation features.
require_once get_stylesheet_directory() . '/src/php/eltheme-features/navigation.php';

// Load widget areas (also called sidebars).
require_once get_stylesheet_directory() . '/src/php/eltheme-features/widget-areas.php';

// Include things that Underscores does by default.
require_once get_stylesheet_directory() . '/src/php/underscores-features/functions.php';
