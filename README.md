# FOH starter theme

<!-- The tables in this document might be easier to read in markdown preview mode -->

## Contents

<!-- TOC -->

- [FOH starter theme](#foh-starter-theme)
  - [Contents](#contents)
  - [Intro](#intro)
    - [New features introduced by FOH](#new-features-introduced-by-foh)
    - [Pre-requisites](#pre-requisites)
  - [Usage](#usage)
    - [Naming conventions](#naming-conventions)
    - [Update package information](#update-package-information)
  - [Appendix: Original documentation for Underscores starter theme](#appendix-original-documentation-for-underscores-starter-theme)
    - [_s](#_s)
      - [Installation](#installation)
        - [Requirements](#requirements)
        - [Quick Start](#quick-start)
        - [Setup](#setup)
        - [Available CLI commands](#available-cli-commands)

<!-- /TOC -->

## Intro

This is a starter theme based on Underscores and adapted for FOH projects.

Modify this theme for each project. Do not use it as a parent theme (all the Webpack stuff should be in the active theme directory).

The original Underscores files say it's version 1.0.0, downloaded Feb 2021. Latest tested WordPress was 5.6.

The original documentation included with Underscores theme is included at the end of this file for reference.

### New features introduced by FOH

-   Production: Webpack bundle optimizations
-   Development: Webpack dev server with BrowserSync

### Pre-requisites

Familiarity with fundamental concepts of Composer, NPM, Sass, Babel, Webpack and WordPress theme development.

## Usage

Clone or download this repository into your WordPress site's `themes` dir.

### Naming conventions

Decide on a namespace for your project. E.g. If your project is called Megatherium, your namespace might be `mega` (this is also called your theme slug) .

Change the dir name to something else (like, say, `mega`), and then you'll need to do a multi-step find and replace on the name in all the templates.

1. Search for `'foh'` (inside single quotations) to capture the text domain and replace with: `'mega'`.
2. Search for `"foh"` (inside double quotations) to capture the text domain and replace with: `"mega"`.
3. Search for `foh_` to capture all the functions names and replace with: `mega_`.
4. Search for `FOH_` (in uppercase) to capture constants and replace with: `MEGA_`.
5. Search for `Text Domain: foh` in `style.css` and replace with: `Text Domain: mega`.
6. Search for `foh.pot` and replace with: `mega.pot`,
7. Search for ` foh` (with a space before it) to capture DocBlocks and replace with: ` Mega`.
8. Search for `foh-`  (caution: manually exclude URLs) to capture prefixed handles and replace with: `mega-`.

Then, update the stylesheet header in `style.css`, the links in `footer.php` with your own information and rename `foh.pot` from `languages` folder to use the theme's slug. Next, update or delete this readme.

Note: The above instructions are an extension of the original ones that came with Underscores theme, included in the Appendix at the end of this document.

### Update package information

Package information is defined  somewhat redundantly across a few different places.
Here are the main things to consider updating.

Notes:
- Authors could be one or many, and can optionally include a URI.
- Tags in `style.css` are from a pre-defined list in the [Theme Developer Handbook](https://make.wordpress.org/themes/handbook/review/required/theme-tags/).
- Extra information in `languages/foh.pot` is auto-generated from `style.css` when running the Composer `make-pot` script.

| composer.json  | package.json   | readme.txt   | style.css    | languages/foh.pot    | GitHub repo |
| :------------- | :------------- | :----------- | :----------- | :------------------- | :---------- |
| name           | name           | top heading  | Theme Name   |                      |             |
| description    | description    | Description  | Description  |                      | Description |
|                | version        | Stable tag   | Version      | Project-Id-Version   |             |
| license        | license        | License      | License      |                      |             |
| homepage       | homepage       |              | Theme URI    |                      | Website     |
| authors        | author         | Contributors | Author       |                      |             |
| support.source | repository.url |              |              |                      |             |
| support.issues | bugs.url       |              |              | Report-Msgid-Bugs-To |             |
| keywords       | keywords       |              |              |                      | Topics      |
| require.php    |                | Requires PHP | Requires PHP |                      |             |

## Appendix: Original documentation for Underscores starter theme

[![Build Status](https://travis-ci.org/Automattic/_s.svg?branch=master)](https://travis-ci.org/Automattic/_s)

### _s

Hi. I'm a starter theme called `_s`, or `underscores`, if you like. I'm a theme meant for hacking so don't use me as a Parent Theme. Instead try turning me into the next, most awesome, WordPress theme out there. That's what I'm here for.

My ultra-minimal CSS might make me look like theme tartare but that means less stuff to get in your way when you're designing your awesome theme. Here are some of the other more interesting things you'll find here:

* A modern workflow with a pre-made command-line interface to turn your project into a more pleasant experience.
* A just right amount of lean, well-commented, modern, HTML5 templates.
* A custom header implementation in `inc/custom-header.php`. Just add the code snippet found in the comments of `inc/custom-header.php` to your `header.php` template.
* Custom template tags in `inc/template-tags.php` that keep your templates clean and neat and prevent code duplication.
* Some small tweaks in `inc/template-functions.php` that can improve your theming experience.
* A script at `js/navigation.js` that makes your menu a toggled dropdown on small screens (like your phone), ready for CSS artistry. It's enqueued in `functions.php`.
* 2 sample layouts in `sass/layouts/` made using CSS Grid for a sidebar on either side of your content. Just uncomment the layout of your choice in `sass/style.scss`.
Note: `.no-sidebar` styles are automatically loaded.
* Smartly organized starter CSS in `style.css` that will help you to quickly get your design off the ground.
* Full support for `WooCommerce plugin` integration with hooks in `inc/woocommerce.php`, styling override woocommerce.css with product gallery features (zoom, swipe, lightbox) enabled.
* Licensed under GPLv2 or later. :) Use it to make something cool.

#### Installation

##### Requirements

`_s` requires the following dependencies:

- [Node.js](https://nodejs.org/)
- [Composer](https://getcomposer.org/)

##### Quick Start

Clone or download this repository, change its name to something else (like, say, `megatherium-is-awesome`), and then you'll need to do a six-step find and replace on the name in all the templates.

1. Search for `'_s'` (inside single quotations) to capture the text domain and replace with: `'megatherium-is-awesome'`.
2. Search for `_s_` to capture all the functions names and replace with: `megatherium_is_awesome_`.
3. Search for `Text Domain: _s` in `style.css` and replace with: `Text Domain: megatherium-is-awesome`.
4. Search for <code>&nbsp;_s</code> (with a space before it) to capture DocBlocks and replace with: <code>&nbsp;Megatherium_is_Awesome</code>.
5. Search for `_s-` to capture prefixed handles and replace with: `megatherium-is-awesome-`.
6. Search for `_S_` (in uppercase) to capture constants and replace with: `MEGATHERIUM_IS_AWESOME_`.

Then, update the stylesheet header in `style.css`, the links in `footer.php` with your own information and rename `_s.pot` from `languages` folder to use the theme's slug. Next, update or delete this readme.

##### Setup

To start using all the tools that come with `_s`  you need to install the necessary Node.js and Composer dependencies :

```sh
$ composer install
$ npm install
```

##### Available CLI commands

`_s` comes packed with CLI commands tailored for WordPress theme development :

- `composer lint:wpcs` : checks all PHP files against [PHP Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/).
- `composer lint:php` : checks all PHP files for syntax errors.
- `composer make-pot` : generates a .pot file in the `languages/` directory.
- `npm run compile:css` : compiles SASS files to css.
- `npm run compile:rtl` : generates an RTL stylesheet.
- `npm run watch` : watches all SASS files and recompiles them to css when they change.
- `npm run lint:scss` : checks all SASS files against [CSS Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/css/).
- `npm run lint:js` : checks all JavaScript files against [JavaScript Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/javascript/).
- `npm run bundle` : generates a .zip archive for distribution, excluding development and system files.

Now you're ready to go! The next step is easy to say, but harder to do: make an awesome WordPress theme. :)

Good luck!
