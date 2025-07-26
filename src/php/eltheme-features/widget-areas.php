<?php
/**
 * Widget areas.
 *
 * @link https://developer.wordpress.org/themes/functionality/sidebars/#registering-a-sidebar
 *
 * @package eltheme
 */

/**
 * Register widget areas 
 */
function eltheme_widgets_init() {
	// Sidebar 1.
	register_sidebar(
		array(
			'name'          => esc_html__( 'Sidebar', 'eltheme' ),
			'id'            => 'sidebar-1',
			'description'   => esc_html__( 'Add widgets here.', 'eltheme' ),
			'before_widget' => '<section id="%1$s" class="widget %2$s">',
			'after_widget'  => '</section>',
			'before_title'  => '<h2 class="widget-title">',
			'after_title'   => '</h2>',
		)
	);

	// Footer widget area 1.
	register_sidebar(
		array(
			'name'          => esc_html__( 'Footer logo widget area', 'eltheme' ),
			'id'            => 'footer-logo',
			'description'   => esc_html__( 'Add an image widget here.', 'eltheme' ),
			'before_widget' => '<section id="%1$s" class="widget %2$s">',
			'after_widget'  => '</section>',
			'before_title'  => '<h2 class="widget-title">',
			'after_title'   => '</h2>',
		)
	);
}
add_action( 'widgets_init', 'eltheme_widgets_init' );
