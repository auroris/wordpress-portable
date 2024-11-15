<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'root' );

/** Database password */
define( 'DB_PASSWORD', '' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '+R-E3&)b)TK74]12F8ZagDWwx&Ex9!D >(~gGEm;HM_dRZ9q[-i@^@`+q`(;5h<&' );
define( 'SECURE_AUTH_KEY',  'D@];B+.d$]$/%9TKZ0(xr FlxV/^z;gw:^J03@-aw?*O8HeZM<jknz>x_OypOD_O' );
define( 'LOGGED_IN_KEY',    '~;^Nv|h2=J*n<8L@*e[K&T5,m?XixkrXSwojEiw*m.4YD*]UrvTGd^7V$E-}Qf1,' );
define( 'NONCE_KEY',        'aVkYgxV]:%=$alAq?iGsUX!-7;9NU|K-4S4}Sg0PJJY~+H,%(q<,&Iu]uFFHq}rU' );
define( 'AUTH_SALT',        'lO**d$W17p,0YT;k3xj027UfP,ee x7L0`%p3+E<z1z{.f(4mm8!pGM=a@o@9,(.' );
define( 'SECURE_AUTH_SALT', 'Il~m$}Zby-ScpSZ4-s%+oVq%Fi!iUU%q ]48?a&mC(G^UJoJ&@lgDQ5<`pFc%A*E' );
define( 'LOGGED_IN_SALT',   'C|I`6G:$C(#uxkF.>^-ipF@r`,J=yr)spxAdC`%T|/E4w*DPn<7[e#By_fi,T|Al' );
define( 'NONCE_SALT',       '[Sjk]iOUWHQ=Taw!,oj:7T/yo<Rpa%{#d$2@H)JI#>s$=3k_2E>:pv}n9xro<5iT' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
