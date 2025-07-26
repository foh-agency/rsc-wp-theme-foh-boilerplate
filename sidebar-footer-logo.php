<?php
/**
 * The footer widget area
 *
 * @link https://developer.wordpress.org/themes/basics/template-files/#template-partials
 * @link https://developer.wordpress.org/reference/functions/get_sidebar/
 *
 * @package eltheme
 */

if ( ! is_active_sidebar( 'footer-logo' ) ) {
	return;
}
?>

<div id="eltheme-footer-logo" class="widget-area">
	<?php dynamic_sidebar( 'footer-logo' ); ?>
</div><!-- #eltheme-footer-logo -->
