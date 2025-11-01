import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
gsap.registerPlugin( ScrollTrigger ); // protect against tree-shaking

/**
 * @function initScrollableHeader
 * This example composes a couple of animations into a single timeline,
 * to be triggered at the same time by a single ScrollTrigger.
 *
 * On scroll:
 *
 * - fade in the logo and slide it down from the top
 * - reveal a border and shadow under the header
 *
 * DOM Dependencies (if your DOM is different, update the selectors below):
 *
 * <header class="js-masthead">
 *  <div class="js-header-logo">My logo!</div>
 * </header>
 *
 * Default styles to set in CSS:
 *
 *  .js-masthead {
 *    position: fixed;
 *    top: 0;
 *  }
 *
 *  .js-header-logo {
 *    opacity: 0;
 *  }
 */

export function initScrollableHeader() {
	/**
	 * @function triggerTimelines
	 * Compose timelines and set ScrollTrigger
	 * @param {Array} timelines - array of gsap timelines instances
	 */
	function triggerTimelines( timelines ) {
		// find the trigger element
		const body = document.querySelector( 'body' );

		// create main timeline and configure the scrollTrigger
		const mainTl = gsap.timeline( {
			scrollTrigger: {
				trigger: body,
				start: 'top top-=100', // when the top of the body reaches 100px above the top of the viewport
				end: 'top top-=200', // when the top of the body reaches 200px above the top of the viewport
				scrub: true,
				// markers: true, // uncomment to debug
			},
		} );

		// add child timelines to all start at the same time
		// (at the 'start' of the mainTl)
		timelines.forEach( ( tl ) => {
			mainTl.add( tl(), 'start' );
		} );
	}

	/**
	 * @function fohRevealLogo
	 * At top of page, hide the logo.
	 * On scroll, reveal the logo (slide down and fade in)
	 * @return {Object} gsap timeline instance
	 */
	function fohRevealLogo() {
		const logoTl = gsap.timeline();

		const logo = document.querySelector( '.js-header-logo' );

		logoTl.fromTo(
			logo,
			{
				y: -logo.offsetHeight,
			},
			{
				opacity: 1,
				y: 0,
			}
		);

		return logoTl;
	}

	/**
	 * @function fohRevealEdge
	 * At top of page, hide the edge of the header.
	 * On scroll, reveal a border and shadow.
	 * @return {Object} gsap timeline instance
	 */
	function fohRevealEdge() {
		const shadowTl = gsap.timeline();

		const header = document.querySelector( '.js-masthead' );

		shadowTl.fromTo(
			header,
			{
				borderBottom: '1px solid rgba(0, 0, 0, 0)',
				boxShadow: 'none',
			},
			{
				borderBottom: '1px solid rgba(255, 255, 255, 0.15)',
				boxShadow: '0 4px 8px rgba(0, 0, 0, 0.7)',
			}
		);

		return shadowTl;
	}

	triggerTimelines( [ fohRevealLogo, fohRevealEdge ] );
}
