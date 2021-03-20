# FOH starter theme

<!-- The tables in this document might be easier to read in markdown preview mode -->

## Contents

<!-- TOC -->

-   [FOH starter theme](#foh-starter-theme)
    -   [Contents](#contents)
    -   [Intro](#intro)
        -   [Pre-requisites](#pre-requisites)
        -   [New features introduced by FOH](#new-features-introduced-by-foh)
        -   [Underscores features removed by FOH](#underscores-features-removed-by-foh)
            -   [Composer packages and associated scripts](#composer-packages-and-associated-scripts)
            -   [NPM packages and associated scripts](#npm-packages-and-associated-scripts)
            -   [Features you may want to remove for your project](#features-you-may-want-to-remove-for-your-project)
    -   [Usage](#usage)
        -   [Naming conventions](#naming-conventions)
        -   [Update package information](#update-package-information)
    -   [Scripts](#scripts)
        -   [NPM scripts](#npm-scripts)
        -   [Composer scripts](#composer-scripts)
    -   [Dependencies](#dependencies)
        -   [Binaries](#binaries)
        -   [NPM dependencies](#npm-dependencies)
        -   [Composer dependencies](#composer-dependencies)
            -   [Global dependencies](#global-dependencies)
            -   [Project dependencies](#project-dependencies)
    -   [Workflows](#workflows)
        -   [Linting and Formatting](#linting-and-formatting)
            -   [Markdown: Markdownlint](#markdown-markdownlint)
            -   [Sass / CSS: stylelint](#sass--css-stylelint)
                -   [Stylelint extended configs](#stylelint-extended-configs)
                -   [Troubleshooting ignore files](#troubleshooting-ignore-files)
                -   [VS-Code overrides](#vs-code-overrides)
            -   [JavaScript: ESLint](#javascript-eslint)
                -   [ESLint setup](#eslint-setup)
                -   [ESLint usage](#eslint-usage)
            -   [PHP: PHP Code Sniffer PHPCS](#php-php-code-sniffer-phpcs)
                -   [PHPCS setup](#phpcs-setup)
                    -   [Links that inspired this PHPCS setup](#links-that-inspired-this-phpcs-setup)
                -   [PHPCS usage linting](#phpcs-usage-linting)
                -   [PHPCBF usage formatting](#phpcbf-usage-formatting)
                    -   [Method 1: Fast and furious](#method-1-fast-and-furious)
                    -   [Method 2: Slow and steady](#method-2-slow-and-steady)
                -   [PHPCS false positives no need to fix these](#phpcs-false-positives-no-need-to-fix-these)
        -   [Internationalization i18n and Localization l10n](#internationalization-i18n-and-localization-l10n)
            -   [What gets overwritten by auto-updating with make-pot](#what-gets-overwritten-by-auto-updating-with-make-pot)
            -   [Useful docs on i18n and l10n](#useful-docs-on-i18n-and-l10n)
                -   [Fundamental concepts and the roles of related files .pot, .po and .mo](#fundamental-concepts-and-the-roles-of-related-files-pot-po-and-mo)
                -   [Syntax in .pot and .po files, including comment types and auto-updates](#syntax-in-pot-and-po-files-including-comment-types-and-auto-updates)
                -   [What's this %1$s syntax in some of the strings in the .pot file?](#whats-this-%251s-syntax-in-some-of-the-strings-in-the-pot-file)
                -   [Bonus for deeper understanding](#bonus-for-deeper-understanding)
    -   [Appendix: Original documentation for Underscores starter theme](#appendix-original-documentation-for-underscores-starter-theme)
        -   [\_s](#%5C_s)
            -   [Installation](#installation)
                -   [Requirements](#requirements)
                -   [Quick Start](#quick-start)
                -   [Setup](#setup)
                -   [Available CLI commands](#available-cli-commands)

<!-- /TOC -->

## Intro

This is a starter theme based on Underscores and adapted for FOH projects.

Modify this theme for each project. Do not use it as a parent theme (all the Webpack stuff should be in the active theme directory).

The original Underscores files say it's version 1.0.0, downloaded Feb 2021. Latest tested WordPress was 5.6.

The original documentation included with Underscores theme is included at the end of this file for reference.

### Pre-requisites

Familiarity with fundamental concepts of Composer, NPM, Sass, Babel, Webpack and WordPress theme development.

### New features introduced by FOH

-   Navigation
    -   Three nav menu locations (header, footer, legal)
    -   Breadcrumbs for pages that aren't top level.
    -   Contextual navigation ('prev' and 'next' links between sibling pages that aren't top level)
-   Two widget areas (sidebar, footer)
-   Webpack for production: Optimize bundle for caching. Include GSAP for animation.
-   Webpack for development: Dev server with BrowserSync.

### Underscores features removed by FOH

#### Composer packages and associated scripts

-   `dealerdirect/phpcodesniffer-composer-installer` (Installed globally).
-   `wptrt/wpthemereview` (Installed globally).
-   `php-parallel-lint/php-parallel-lint` (Replaced by VS Code extension).
-   `wp-cli/i18n-command` (Installed globally).

More info in sections below:

-   [Linting and Formatting](#linting-and-formatting)
-   [Internationalization i18n and Localization l10n](#internationalization-i18n-and-localization-l10n)

#### NPM packages and associated scripts

-   `@wordpress/scripts` (Replaced by custom scripts).
-   `dir-archiver` <!-- TODO: Replace with custom deployment script + workflow. -->
-   `node-sass` (Replaced by Webpack).
-   `rtlcss` and associated config in `package.json`. (Consider re-installing when adding rtl support).

More info in the [NPM scripts](#npm-scripts) section below.

#### Features you may want to remove for your project

See below: [Appendix: Original documentation for Underscores starter theme](#appendix-original-documentation-for-underscores-starter-theme)

## Usage

Clone or download this repository into your WordPress site's `themes` dir.

Install all dependencies, documented below: [Dependencies](#dependencies).

In `webpack.common.js`, update the name of the local site dir (find "foh-starter-theme-test" and replace with the name of the local dir that contains `wp-config.php`, used during development).

### Naming conventions

Decide on a namespace for your project. E.g. If your project is called Megatherium, your namespace might be `mega` (this is also called your theme slug) .

Change the theme dir name to `mega` (your slug), and then you'll need to do a multi-step find and replace on the name in all the templates.

**Important:** Step through this manually with patience. Things like URLs get tricky.

1. Search for `'foh'` (inside single quotations) to capture the text domain and replace with: `'mega'`.
2. Search for `"foh"` (inside double quotations) to capture the text domain and replace with: `"mega"`.
3. Search for `foh_` to capture all the functions names and replace with: `mega_`.
4. Search for `FOH_` (in uppercase) to capture constants and replace with: `MEGA_`.
5. Search for `Text Domain: foh` in `style.css` and replace with: `Text Domain: mega`.
6. Search for `foh.pot` and replace with: `mega.pot`,
7. Search for ` foh` (with a space before it) to capture DocBlocks and replace with: ` Mega`.
8. Search for `foh-` to capture prefixed handles and replace with: `mega-`.
9. Search for `[foh` (opening bracket only, to capture function prefix) and replace with: `[mega`.
10. Rename files and directories if you modify them:
    - `languages/foh.pot` => `mega.pot`
    - `src/js/foh-scroll-features.js` => `src/js/mega-scroll-features`
    - `src/php/foh-features/` => `src/php/mega-features/`

Then, update the stylesheet header in `style.css`, the links in `footer.php` with your own information.

Note: The above instructions are an extension of the original ones that came with Underscores theme, included in the Appendix at the end of this document.

### Update package information

Package information is defined somewhat redundantly across a few different places.
Here are the main things to consider updating.

Notes:

-   Authors could be one or many, and can optionally include a URI.
-   Tags in `style.css` are from a pre-defined list in the [Theme Developer Handbook](https://make.wordpress.org/themes/handbook/review/required/theme-tags/).
-   Extra information in `languages/foh.pot` is auto-generated from `style.css` when running the Composer `make-pot` script.

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

## Scripts

### NPM scripts

The included `package.json` file contains handy scripts that run Webpack to build assets at different parts of the development and testing process.

<!-- This table might be easier to read in markdown preview mode -->
<!-- prettier-ignore -->
| Script                  | Usage                             | Summary |
| :---------------------- | :-------------------------------- | :------ |
| `start`                 | During development                | Start dev server with hot module replacement and live reload. |
| `dev`                   | As needed                         | Run a single build in development mode. |
| `build-prod-in-dev-env` | To test before shipping           | Create a production build where paths resolve for the local environment (so we can test the production build locally). |
| `build`                 | When ready to ship                | Create a shippable production build with remote paths. |

### Composer scripts

<!-- This table might be easier to read in markdown preview mode -->
<!-- prettier-ignore -->
| Script      | Usage                         | Summary |
| :---------- | :---------------------------- | :------ |
| `lint:php`  | If you need to debug PHPCS    | Manually run code sniffer with terminal output (redundant alternative to what VS Code does automatically on save with valeryanm.vscode-phpsab extension) |
| `make-pot`  | When PHP source changes       | Re-generate `languages/foh.pot`. |

## Dependencies

### Binaries

-   WP-CLI (Installs the multi-purpose `wp` command).

    -   [Global installation guide](https://make.wordpress.org/cli/handbook/guides/installing/)

        See sections:

        -   [Composer scripts](#composer-scripts)
        -   [Internationalization i18n and Localization l10n](#internationalization-i18n-and-localization-l10n).

### NPM dependencies

1. Install dependencies included in `package.json` (documented below):

    `$ npm install`

2. Check for outdated dependencies and update if necessary:

    `$ ncu`

    _Note: If you don't have the `ncu` command, you'll need to globally install npm's update tool:_

    `$ npm install -g npm-check-updates`

<!-- These tables might be easier to read in markdown preview mode -->
<!-- prettier-ignore -->
| dependencies | Purpose |
| :----------- | :------ |
| `core-js`    | Babel polyfills |
| `gsap`       | [GreenSock](https://greensock.com/), the industry standard animation library. |

<!-- This table might be easier to read in markdown preview mode -->
<!-- prettier-ignore -->
| devDependencies               | Purpose |
| :---------------------------- | :------ |
| `@babel/core`                 | This is Babel! But it's useless without plugins or presets (which are collections of plugins). |
| `@babel/preset-env`           | Preset based on [caniuse](https://caniuse.com/). I decide which syntax to change depending on the project's supported browsers. |
| `@babel/register`             | Support ES6 syntax within the Webpack config files. |
| `@wordpress/eslint-plugin`    | ESLint plugin including configurations and custom rules for WordPress development. |
| `@wordpress/prettier-config`  | WordPress Prettier shareable config for Prettier. |
| `@wordpress/stylelint-config` | Adopt WordPress coding standards for S(CSS). |
| `babel-loader`                | Enable Webpack to run `@babel/core`. |
| `browser-sync`                | Enable live reloading during development. |
| `browser-sync-webpack-plugin` | Allow BrowserSync to work with Webpack. |
| `clean-webpack-plugin`        | Clean out old unused files from `dist/` on every build. |
| `css-loader`                  | Enable CSS to be piped to `style-loader`. |
| `cssnano`                     | Plugin used by postcss. Minifies CSS. |
| `fibers`                      | Make SCSS compilation faster as recommended in [the docs](https://webpack.js.org/loaders/sass-loader/). |
| `eslint-config-prettier`      | Turns off all rules that are unnecessary or might conflict with Prettier. |
| `fibers`                      | Make SCSS compilation faster as recommended in [the docs](https://webpack.js.org/loaders/sass-loader/). |
| `mini-css-extract-plugin`     | Generate static CSS files so users without JS still have a stylish time. |
| `postcss-loader`              | Enable CSS to run through plugins before it hits `dist/`. |
| `postcss-preset-env`          | Plugin used by postcss. Includes [Autoprefixer](http://autoprefixer.github.io/). |
| `prettier`                    | Automatic code formatter (specifies the version to be used by VS Code extension). |
| `sass`                        | Compile SCSS syntax into CSS. |
| `sass-loader`                 | Enable Webpack to run `sass`. |
| `stylelint-config-prettier`   | Turns off all rules that are unnecessary or might conflict with Prettier. |
| `webpack`                     | Your humble bundler. |
| `webpack-bundle-analyzer`     | On each build, display a graphical representation of bundle files and their sizes. |
| `webpack-cli`                 | A required helper for Webpack. |
| `webpack-dev-server`          | Enable a no-refresh dev experience, including [hot module replacement (HMR)](https://webpack.js.org/concepts/hot-module-replacement/). |
| `webpack-manifest-plugin`     | Keep track of cacheable filenames for all assets. See detailed usage at `src/php/enqueue_assets.php`. |
| `webpack-merge`               | Enable split config files for dev and prod purposes (and common configs to both). |

### Composer dependencies

1. The dependencies listed below should be installed in your global composer directory.

    On Unix systems you can find this with the following command (with example output):

    ```Console
    $ composer config --list --global | grep home
    [home] /Users/<your-username>/.composer
    ```

2. Check for outdated dependencies and update if necessary:

    From the directory we found in the previous step, check for outdated packages:

    ```Composer
    $ composer outdated
    <some-old-package>
    $composer update <some-old-package>
    ```

#### Global dependencies

These global dependencies configure PHP linting.

<!-- This table might be easier to read in markdown preview mode -->
<!-- prettier-ignore -->
| require-dev                                      | Purpose |
| :----------------------------------------------- | :------ |
| `squizlabs/php_codesniffer`                      | Shell commands: `phpcs`, `phpcbf`. Coding standards: PEAR, Zend, PSR2, MySource, Squiz, PSR1, PSR12. |
| `dealerdirect/phpcodesniffer-composer-installer` | Utility: Composer plugin sorts out the PHPCS 'installed_paths' automatically. |
| `roave/security-advisories`                      | Utility: Ensure we don't install dependencies with known vulnerabilities. Suggested by `phpcompatibility-wp`. |
| `phpcompatibility/phpcompatibility-wp`           | Coding standards: PHPCompatibility, PHPCompatibilityParagonieRandomCompat, PHPCompatibilityParagonieSodiumCompat, PHPCompatibilityWP. |
| `wptrt/wpthemereview`                            | Coding standard: WPThemeReview. |
| `wp-coding-standards/wpcs`                       | Coding standards: WordPress, WordPress-Extra, WordPress-Docs, WordPress-Core. |

Installation guide included below: [PHPCS setup](#phpcs-setup).

#### Project dependencies

<!-- prettier-ignore -->
| require | Purpose |
| :------ | :------ |
| `php`   | Specify PHP version compatibility |

## Workflows

### Linting and Formatting

This project uses the [.editorconfig from Make WordPress Core](https://core.trac.wordpress.org/browser/trunk/.editorconfig).

#### Markdown: Markdownlint

Prettier is configured to extend a WordPress config, which enforces some rules I don't like (e.g. the [WordPress Markdown Style Guide](https://developer.wordpress.org/coding-standards/styleguide/) agrees with me on lists at least, though documentation is very thin).

Maybe we can configure it away. Here's what I tried:

1. Preferred method (Unsuccessful so far due to time constraint. Revisit?)

    Goal:

    - Customize Prettier so it continues to format lists, but with respect to the style configured in Markdownlint.

    Results:

    - The main advice I fount online was 'disable Prettier for Markdown'.
    - I couldn't find specific config options to customize.
    - I couldn't find documentation for `@wordpress/prettier-config`, to see which options they are.
        <!-- TODO: where in the source should i look? -->

2. Workaround method (In use. Doesn't do what I want, but gets rid of excessive underlines).

    Goal:

    - Customize Markdownlint to ignore rules that are auto-formatted by Prettier.

    Results:

    - .markdownlint.json has the following rules defined:

        | Rule           | Description                                              |
        | :------------- | :------------------------------------------------------- |
        | "MD007": false | Unordered list indentation                               |
        | "MD013": false | Line length                                              |
        | "MD014": false | Dollar signs used before commands without showing output |
        | "MD030": false | Spaces after list markers                                |

#### Sass / CSS: stylelint

This theme is configured to show stylelint errors as you type and auto-format on save.

Two VS Code extensions read the included configs to make this happen:

-   [stylelint](https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint)
-   [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

The following files are configured for this purpose:

-   .prettierignore
-   .prettierrc.json
-   .stylelintignore
-   .stylelintrc.json

To see a list of all active rules, use this command from the theme dir:

```Console
$ npx stylelint --print-config .
```

##### Stylelint extended configs

-   `stylelint-config-wordpress/scss`

    This merges two popular configs:

    -   [stylelint-config-wordpress](https://github.com/WordPress-Coding-Standards/stylelint-config-wordpress)
    -   [stylelint-config-recommended-scss](https://github.com/kristerkari/stylelint-config-recommended-scss)

-   `stylelint-config-prettier`

    This one must be the last in the list, so it applies after the others.

    It resolves potential conflicts between stylelint and prettier.

##### Troubleshooting ignore files

Two files in the theme dir (`.stylelintignore` and `.prettierignore`) are set to not touch `style.css`, which contains theme info required by WordPress and source from `normalize.css`.

Two conditions need to be met for these ignore files to be respected:

-   VS Code considers the theme dir to be the project root (i.e. when you open a folder with VS Code, choose the theme dir).
-   In VS Code settings, Prettier's Ignore Path is pointing at `.prettierignore`.

When I had VS Code opened to the site dir (the one that contains `wp-config.php`), the above ignore files were not respected (stylelint problems would show up for `style.css`, and saving it would auto-format it).

##### VS-Code overrides

If you have a `"stylelint.config"` object in `settings.json`, it will completely override the config object in `.stylelintrc.json`, so make sure you don't have one.

If you need a few local overrides, create a `"stylelint.configOverrides"` object `settings.json` instead. Rules from there _and_ from `.stylelintrc.json` will apply.

#### JavaScript: ESLint

This theme is configured to show ESLint errors as you type and auto-format on save.

##### ESLint setup

Two VS Code extensions read the included configs to make this happen:

-   [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
-   [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

The following files are configured for this purpose:

-   .eslintrc
-   .prettierignore
-   .prettierrc.json

##### ESLint usage

To see a list of all active rules, use this command from the theme dir:

```Console
$ npx eslint --print-config src/index.js
```

To see a list of rules that conflict with Prettier, use this command from the theme dir:

```Console
$ npx eslint-config-prettier src/index.js
```

#### PHP: PHP Code Sniffer (PHPCS)

There are many ways to configure PHP linting (with or without VS Code), this is just one of them.

In this workflow, PHP files (within the theme dir, including all subdirs) are linted on type, and warnings appear in VS Code (underlined in place, and listed in the Problems panel).

The subsection on formatting offers a couple of possible approaches to applying auto-fixes.

##### PHPCS setup

1.  Globally install a security utility.

    This ensures that no Composer dependencies with known vulnerabilities are installed.
    It's recommended when installing the PHPCompatibility coding standard, and seems generally like a good idea.
    The `:dev-latest` part below is needed to get around a version stability error.

    ```Console
    $ composer g require --dev roave/security-advisories:dev-latest
    ```

2.  Globally install PHP Code Sniffer, and add it to $PATH.
    (adds capability to run both `phpcs` and `phpcbf`)

    ```Console
    $ composer g require --dev "squizlabs/php_codesniffer=*";
    $ echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc
    ```

    This step also automatically installs some coding standards (PEAR, Zend, PSR2, MySource, Squiz, PSR1, PSR12). We don't need to take any further steps to reference them in our project; phpcs will use them automatically. Just mentioning because these standards will show up again later and it's good to know where they came from.

3.  Globally install a plugin to automatically manage paths for coding standards.

    This plugin automatically tells PHPCS about installed Coding Standards by adding them to `installed_paths`.

    ```Console
    $ composer g require --dev dealerdirect/phpcodesniffer-composer-installer
    ```

    **Optional alternative:**

    Installing the above plugin once is equivalent to running the following command manually for each installed coding standard (there might not be a need to ever do it manually, but some tutorials show this method, and it's good to know we've already taken care of this step):

    Note: If you do this manually, the paths _must_ begin with `/`. The `~` shorthand will result in only one of the standards being installed.

    Make sure to replace all instances of `<your-username>`.

    ```Console
    $ phpcs --config-set installed_paths /Users/<your-username>/.composer/vendor/PHPCompatibility,/Users/<your-username>/.composer/vendor/wp-coding-standards/wpcs
    ```

4.  Install coding standards

    These are the third-party rulesets that will be referenced from within the custom project ruleset at `phpcs.xml.dist`.

    ```Composer
    $ composer g require --dev wp-coding-standards/wpcs
    $ composer g require --dev phpcompatibility/phpcompatibility-wp
    $ composer g require --dev wptrt/wpthemereview
    ```

    -   WordPress: `wpcs`
        As of version ^2.3, this installs the following coding standards:
        WordPress, WordPress-Extra, WordPress-Docs, WordPress-Core.

    -   PHP Compatibility for WordPress: `phpcompatibility-wp`
        As of version ^2.1, this installs the following coding standards:
        PHPCompatibility, PHPCompatibilityParagonieRandomCompat, PHPCompatibilityParagonieSodiumCompat, PHPCompatibilityWP.

    -   WordPress theme review: `wpthemereview`
        As of version ^0.2.1, this installs the following coding standard:
        WPThemeReview.

5.  Reference the project's coding standards in `phpcs.xml.dist`

    `phpcs.xml.dist` includes references to standards we want to check against. E.g.:

    ```xml
      <rule ref="WPThemeReview"/>
    ```

    If you're curious, you can see the dependencies of each of these standards, by diving into... ~/.composer/vendor/\*\*/ruleset.xml (there's one for each installed standard)

    This project uses the rules provided within Underscores theme.

    **PHP Compatibility versions**

    The `phpcs.xml.dist` that shipped with Underscores references PHPCompatibilityWP at version 5.6 and greater.
    The same file also references WPThemeReview which specifies PHPCompatibilityWP at version 5.2 and greater.
    Until I find a reason to change it, I'm just using it as is.
    <!--TODO: Consider investigating this discrepancy -->

    As of Sep 2020, the topic of routinely discontinuing WordPress support for old PHP versions is [being discussed](https://make.wordpress.org/core/2020/08/24/proposal-dropping-support-for-old-php-versions-via-a-fixed-schedule/).

6.  Install and configure the following VS Code extension:

    These VS Code extensions read the included configs to make this happen:

    -   [PHP Sniffer & Beautifier](https://marketplace.visualstudio.com/items?itemName=ValeryanM.vscode-phpsab)

        Add the following to VS Code's `settings.json`:

        -   Deactivate VS Code's default PHP validator:

            ```json
            "php.validate.enable": false
            ```

        -   Customize PHP Sniffer & Beautifier (Make sure to replace all instances of `<your-username>`):

            Note: `onType` might drain your laptop battery, so consider it optional.

            ```json
            "phpsab.executablePathCS": "/Users/<your-username>/.composer/vendor/bin/phpcs",
            "phpsab.executablePathCBF": "/Users/<your-username>/.composer/vendor/bin/phpcbf",
            "phpsab.snifferMode": "onType",
            "phpsab.snifferShowSources": true,
            "phpsab.allowedAutoRulesets": [
                ".phpcs.xml",
                ".phpcs.xml.dist",
                "phpcs.xml",
                "phpcs.xml.dist",
                "phpcs.ruleset.xml",
                "ruleset.xml"
            ]
            ```

7.  Check setup was successful

    Here's what should show up in `/Users/<your-username>/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer.conf` (Make sure to replace all instances of `<your-username>`):

    ```php
    <?php
    $phpCodeSnifferConfig = array (
        'installed_paths' => '/Users/<your-username>/.composer/vendor/phpcompatibility/php-compatibility,/Users/<your-username>/.composer/vendor/phpcompatibility/phpcompatibility-paragonie,/Users/<your-username>/.composer/vendor/phpcompatibility/phpcompatibility-wp,/Users/<your-username>/.composer/vendor/wp-coding-standards/wpcs,/Users/<your-username>/.composer/vendor/wptrt/wpthemereview',
    )
    ?>
    ```

    Here's the full list of all installed standards that should now show up in the console:

    ```Console
    $ phpcs -i

    The installed coding standards are PEAR, Zend, PSR2, MySource, Squiz, PSR1, PSR12, PHPCompatibility, PHPCompatibilityParagonieRandomCompat, PHPCompatibilityParagonieSodiumCompat, PHPCompatibilityWP, WordPress, WordPress-Extra, WordPress-Docs, WordPress-Core and WPThemeReview
    ```

###### Links that inspired this PHPCS setup

-   [How to Set up Modern PHP Coding Standards for WordPress](https://tfrommen.de/how-to-set-up-modern-php-coding-standards-for-wordpress/) - Article, 2019
-   [PHPCS setup for WordPress projects](https://www.youtube.com/watch?v=ASVr3zG2Q4E&ab_channel=ImranSayed-CodeytekAcademy) - YouTube, 2017
-   [Annotated example of phpcs.xml.dist (syntax guide)](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Annotated-ruleset.xml)

##### PHPCS usage (linting)

Based on the ruleset at `phpcs.xml.dist`, the VS Code extension recommended above will automatically underline issues on type, and list them in the Problems panel.

An easy example to try, just to see that it's working:

```php
<?php
// A comment that doesn't end in punctuation should produce a linting error based on the Squiz coding standard
// Add some punctuation to the above line to resolve the error, like this full stop right here.
?>
```

To run the linter manually and see output in the Terminal, run this command from the theme directory.
This script is defined in `composer.json` to run `phpcs` on the current directory based on `phpcs.xml.dist`.

```Console
$ composer run lint:php
```

##### PHPCBF usage (formatting)

Resolve auto-fixable problems from the above reports.

I'm not sure how big a risk this is with `phpcbf` in particular, but PHP can be so temperamental that a mere typo can result in a [white screen of death](https://www.wpbeginner.com/wp-tutorials/how-to-fix-the-wordpress-white-screen-of-death/).
Just in case, here are two different methods to suit your priorities around rush vs risk-aversion.

###### Method 1: Fast and furious

Caution: This is a bulldozer method that auto-fixes all issues possible, in all affected files.
**Headache prevention: Do this with a clean working tree so you can easily compare the diff.**

If you don't have a clean working tree and aren't ready to commit, `git stash` features can help.

Run from theme directory:

```Console
$ git status
On branch <your-branch>
nothing to commit, working tree clean

$ phpcbf
```

Then use VS Code's Source Control view (or run `$ git diff`) to see what changed.

Since we started with a clean a working tree, we can recover from a mess by undoing all fixes in a file:

```Console
$ git checkout -- <filename>
```

###### Method 2: Slow and steady

Consider the patch method indicated in the [PHPCS docs](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Fixing-Errors-Automatically).
This method gives you the chance to read and edit diffs before manually applying them as patches.
You'll also need to delete the diff files manually once you're done.

Generic instructions from docs:

```Console
$ phpcs --report-diff=/path/to/changes.diff /path/to/code
$ patch -p0 -ui /path/to/changes.diff
patching file /path/to/code/file.php
```

Example to auto-fix `functions.php`, with two additional steps:

-   Create the diff file before writing to it (avoid an error).
-   Examine the diff file in VS Code before applying it.

```Console
$ touch functions.diff
$ phpcs --report-diff=functions.diff functions.php
$ code functions.diff
$ patch -p0 -ui functions.diff
patching file functions.php
```

##### PHPCS false positives (no need to fix these)

False positive identified in [Trac ticket 49539](https://core.trac.wordpress.org/ticket/49539).

```Console
FILE: src/php/underscores-features/inc/template-tags.php
------------------------------------------------------------------------------------------------------------------
FOUND 2 ERRORS AFFECTING 2 LINES
------------------------------------------------------------------------------------------------------------------
 162 | ERROR | Functions declared in the global namespace by a theme/plugin should start with the theme/plugin
     |       | prefix. Found: "wp_body_open".
     |       | (WordPress.NamingConventions.PrefixAllGlobals.NonPrefixedFunctionFound)
 163 | ERROR | Hook names invoked by a theme/plugin should start with the theme/plugin prefix. Found:
     |       | "wp_body_open". (WordPress.NamingConventions.PrefixAllGlobals.NonPrefixedHooknameFound)
------------------------------------------------------------------------------------------------------------------
```

### Internationalization (i18n) and Localization (l10n)

If this is an unfamiliar topic, I'd recommend reading through the documentation links at the end of this section.

In the `./languages/` dir is a `.pot` file that can be used as the basis
for translations. This file references string locations in the source code,
including line numbers.

As the source is updated, these will go out of date, so it should be updated
before sending it to translators. Some of the updates are handled manually,
and some automatically. Keep this in mind to avoid having your manual edits
accidentally overwritten.

_Note: This Readme was written based only on a single `.pot` file, and might be
missing details that apply to localized projects with `.po` and `.mo` files._

<!-- TODO: update once you're using local translations -->
<!-- TODO: Update this section after recommending Composer scripts -->

To update `languages/foh.pot`, run this command from the theme root directory.
(Uses [wp-cli](https://make.wordpress.org/cli/handbook/guides/quick-start/))

```Console
$ wp i18n make-pot . languages/foh.pot
```

#### What gets overwritten by auto-updating with make-pot

Here's how different parts of the `.pot` file get updated:

Based on theme info in `style.css`:

-   Header entry (several headers)

Based on code in the source dir (first arg):

-   Translator comments will be deleted
    This refers to comments _by_ translators, i.e. those starting with `#<space>`.
    I guess it makes sense that they'd be deleted from `.pot` because translators
    should be editing `.po` files, not `.pot`.

-   References (filename and line number)

-   Entire entries (if they exist in the source, they'll be created in the `.pot`),
    along with developer comments (made by developers for translators).

    Developer comments must be php (not html) comments in the following format:

    `/* translators: blah */`

    Editing or deleting entries in `.pot` is not a good idea, since they will be
    re-generated from source. If you want some entries ignored, consider passing
    options to `make-pot` to indicate a blacklist.

    For `make-pot` to recognize something as an entry, it should be set with
    `esc_html_e(...)` with a text domain in the second arg that matches the
    text domain in the header of the `.pot` file.

So far, the way this works is by calling [load_text_domain](https://developer.wordpress.org/reference/functions/load_theme_textdomain/) once during theme load.

#### Useful docs on i18n and l10n

-   [What is This esc_html_e() i wordpress php?](https://wordpress.stackexchange.com/questions/285657/what-is-this-esc-html-e-i-wordpress-php)
-   [Documentation with extra options for make-pot](https://developer.wordpress.org/cli/commands/i18n/make-pot/)

##### Fundamental concepts and the roles of related files (`.pot`, `.po` and `.mo`)

-   [WP APIs handbook: Localization](https://developer.wordpress.org/apis/handbook/internationalization/localization/)

##### Syntax in `.pot` and `.po` files, including comment types and auto-updates

-   [The Format of PO Files](https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html)

##### What's this `%1$s` syntax in some of the strings in the `.pot` file?

-   [Learn the sprintf syntax](https://www.php.net/manual/en/function.sprintf.php)

##### Bonus for deeper understanding

-   [Header Entry](https://www.gnu.org/software/gettext/manual/html_node/Header-Entry.html#Header-Entry)
-   [Header: Plural forms](https://www.gnu.org/software/gettext/manual/html_node/Plural-forms.html#Plural-forms)

## Appendix: Original documentation for Underscores starter theme

[![Build Status](https://travis-ci.org/Automattic/_s.svg?branch=master)](https://travis-ci.org/Automattic/_s)

### \_s

Hi. I'm a starter theme called `_s`, or `underscores`, if you like. I'm a theme meant for hacking so don't use me as a Parent Theme. Instead try turning me into the next, most awesome, WordPress theme out there. That's what I'm here for.

My ultra-minimal CSS might make me look like theme tartare but that means less stuff to get in your way when you're designing your awesome theme. Here are some of the other more interesting things you'll find here:

-   A modern workflow with a pre-made command-line interface to turn your project into a more pleasant experience.
-   A just right amount of lean, well-commented, modern, HTML5 templates.
-   A custom header implementation in `src/php/underscores-features/inc/custom-header.php`. Just add the code snippet found in the comments of `src/php/underscores-features/inc/custom-header.php` to your `header.php` template.
-   Custom template tags in `src/php/underscores-features/inc/template-tags.php` that keep your templates clean and neat and prevent code duplication.
-   Some small tweaks in `src/php/underscores-features/inc/template-functions.php` that can improve your theming experience.
-   A script at `src/js/navigation.js` that makes your menu a toggled dropdown on small screens (like your phone), ready for CSS artistry. It's enqueued in `functions.php`.
-   2 sample layouts in `sass/layouts/` made using CSS Grid for a sidebar on either side of your content. Just uncomment the layout of your choice in `sass/style.scss`.
    Note: `.no-sidebar` styles are automatically loaded.
-   Smartly organized starter CSS in `style.css` that will help you to quickly get your design off the ground.
-   Full support for `WooCommerce plugin` integration with hooks in `src/php/underscores-features/inc/woocommerce.php`, styling override woocommerce.css with product gallery features (zoom, swipe, lightbox) enabled.
-   Licensed under GPLv2 or later. :) Use it to make something cool.

#### Installation

##### Requirements

`_s` requires the following dependencies:

-   [Node.js](https://nodejs.org/)
-   [Composer](https://getcomposer.org/)

##### Quick Start

Clone or download this repository, change its name to something else (like, say, `megatherium-is-awesome`), and then you'll need to do a six-step find and replace on the name in all the templates.

1. Search for `'_s'` (inside single quotations) to capture the text domain and replace with: `'megatherium-is-awesome'`.
2. Search for `_s_` to capture all the functions names and replace with: `megatherium_is_awesome_`.
3. Search for `Text Domain: _s` in `style.css` and replace with: `Text Domain: megatherium-is-awesome`.
4. Search for <code>&nbsp;\_s</code> (with a space before it) to capture DocBlocks and replace with: <code>&nbsp;Megatherium_is_Awesome</code>.
5. Search for `_s-` to capture prefixed handles and replace with: `megatherium-is-awesome-`.
6. Search for `_S_` (in uppercase) to capture constants and replace with: `MEGATHERIUM_IS_AWESOME_`.

Then, update the stylesheet header in `style.css`, the links in `footer.php` with your own information and rename `_s.pot` from `languages` folder to use the theme's slug. Next, update or delete this readme.

##### Setup

To start using all the tools that come with `_s` you need to install the necessary Node.js and Composer dependencies :

```sh
$ composer install
$ npm install
```

##### Available CLI commands

`_s` comes packed with CLI commands tailored for WordPress theme development :

-   `composer lint:wpcs` : checks all PHP files against [PHP Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/).
-   `composer lint:php` : checks all PHP files for syntax errors.
-   `composer make-pot` : generates a .pot file in the `languages/` directory.
-   `npm run compile:css` : compiles SASS files to css.
-   `npm run compile:rtl` : generates an RTL stylesheet.
-   `npm run watch` : watches all SASS files and recompiles them to css when they change.
-   `npm run lint:scss` : checks all SASS files against [CSS Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/css/).
-   `npm run lint:js` : checks all JavaScript files against [JavaScript Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/javascript/).
-   `npm run bundle` : generates a .zip archive for distribution, excluding development and system files.

Now you're ready to go! The next step is easy to say, but harder to do: make an awesome WordPress theme. :)

Good luck!
