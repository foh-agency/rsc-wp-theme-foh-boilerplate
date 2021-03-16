<?php
/**
 * The footer widget area
 *
 * @link https://developer.wordpress.org/themes/basics/template-files/#template-partials
 * @link https://developer.wordpress.org/reference/functions/get_sidebar/
 *
 * @package foh
 */

if ( ! is_active_sidebar( 'footer-widgets-1' ) ) {
	return;
}
?>

<div id="foh-footer-widgets-1" class="widget-area">
	<?php dynamic_sidebar( 'footer-widgets-1' ); ?>
</div><!-- #foh-footer-widgets-1 -->
