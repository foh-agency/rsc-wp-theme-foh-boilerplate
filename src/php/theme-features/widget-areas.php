<?php
/**
 * Widget areas.
 *
 * @link https://developer.wordpress.org/themes/functionality/sidebars/#registering-a-sidebar
 *
 * @package FOH
 */

/**
 * Register widget areas 
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
			'name'          => esc_html__( 'Footer logo widget area', 'foh' ),
			'id'            => 'footer-logo',
			'description'   => esc_html__( 'Add an image widget here.', 'foh' ),
			'before_widget' => '<section id="%1$s" class="widget %2$s">',
			'after_widget'  => '</section>',
			'before_title'  => '<h2 class="widget-title">',
			'after_title'   => '</h2>',
		)
	);
}
add_action( 'widgets_init', 'foh_widgets_init' );
