# Wordpress Portable

This PowerShell script automates the setup of a local development environment for WordPress using a portable PHP installation. It also integrates the SQLite Database Integration plugin for WordPress to allow usage without MySQL. This makes it easy to quickly get a WordPress site running locally with minimal installation and configuration.

## Features

- **Automated PHP Download and Setup**: Downloads PHP, configures it for portability, and prepares it to be used in a local environment.
- **WordPress Installation**: Downloads and extracts the latest version of WordPress if it does not already exist.
- **SQLite Plugin Integration**: Downloads and installs the SQLite Database Integration plugin, making it possible to use SQLite as the database for WordPress.
- **Local Development Server**: Starts PHP's built-in development server to serve the WordPress installation on `localhost`.

## Prerequisites

- **Windows OS**: This script is designed to run on Windows.
- **PowerShell**: Make sure you have PowerShell installed and available in your system.

## Usage

1. **Clone the Repository**: Start by cloning this repository or downloading the script file.

   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Run the Script**: Execute the script using PowerShell.

   ```powershell
   .\run.ps1
   ```

3. **Follow Prompts**: The script will download PHP, WordPress, and the SQLite plugin, then start a local development server.

   Once the server is running, visit [http://localhost:8000](http://localhost:8000) in your web browser to access your local WordPress installation.

4. **Stopping the Server**: Press any key in the PowerShell window to stop the PHP server.

## What the Script Does

### Step-by-Step Breakdown

1. **PHP Setup**
   - Downloads PHP from the official PHP website.
   - Extracts PHP to a local `./php` directory.
   - Configures `php.ini` for portability, enabling necessary extensions like `mysqli`, `sqlite3`, and `pdo_sqlite`.

2. **WordPress Installation**
   - Checks if WordPress is already installed in `./wordpress`.
   - If not, downloads and extracts WordPress to the local directory.

3. **SQLite Database Integration Plugin**
   - Downloads the SQLite Database Integration plugin.
   - Extracts it to the WordPress plugins directory.
   - Copies `db.copy` to `db.php` to enable SQLite as the database engine.

4. **Start Development Server**
   - Uses PHP's built-in web server to start serving the WordPress site locally at `http://localhost:8000`.

## Notes

- **Portability**: The script sets up PHP and WordPress as portable installations, meaning you can move the entire directory to another location and it will still work.
- **SQLite as Database**: This script configures WordPress to use SQLite, making it very easy to get started without needing to set up MySQL.

## .gitignore Documentation

This `.gitignore` file is intended for a WordPress project that uses a portable PHP setup and the SQLite Database Integration plugin. It helps ensure that only necessary files are tracked in the repository while excluding automatically downloaded components and temporary files.

### Sections Overview

#### Ignore PHP Directory

The `./php/` directory contains the portable PHP installation, which is downloaded and configured by the script. To keep the repository clean and avoid versioning large binaries, this directory is ignored:

```
# Ignore PHP installation
/php/
```

#### Ignore WordPress Core Files

WordPress core files are downloaded by the `run.ps1` script. If you want to track WordPress core files in your repository (e.g., for custom modifications), you can remove this section. This section excludes everything related to WordPress core that is redundant to version control:

```
# Ignore WordPress core files
/wordpress/wp-admin/
/wordpress/wp-content/index.php
/wordpress/wp-content/languages
/wordpress/wp-content/plugins/index.php
/wordpress/wp-content/themes/index.php
/wordpress/wp-includes/
/wordpress/index.php
/wordpress/license.txt
/wordpress/readme.html
/wordpress/wp-*.php
/wordpress/xmlrpc.php
```

#### Include WordPress Configuration File

WordPress requires a `wp-config.php` file for configuration. This file may contain sensitive information, but for a local or development environment, it is often necessary to version it to keep track of database settings and other configurations. Therefore, the `wp-config.php` file is explicitly included:

```
# Include WordPress configuration file
!/wordpress/wp-config.php
```

#### Ignore Example Themes

The default WordPress themes, like `twentytwenty` and similar, are not essential unless you are customizing them. These files are ignored:

```
# Ignore default example themes
/wordpress/wp-content/themes/twenty*/
```

#### Ignore Default Plugins

WordPress comes with a few default plugins, such as `hello.php` and `Akismet`. These plugins are often not required for custom projects, and therefore they are ignored:

```
# Ignore default plugins
/wordpress/wp-content/plugins/hello.php
/wordpress/wp-content/plugins/akismet/
```

#### Ignore SQLite Database Integration Plugin

The SQLite Database Integration plugin is downloaded and configured by the setup script. It is excluded from version control to avoid duplicating files that are automatically set up:

```
# Ignore SQLite Database Integration plugin and database file
/wordpress/wp-content/plugins/sqlite-database-integration/
/wordpress/wp-content/db.php
```

#### Ignore Log Files

Log files are generated during runtime and are not useful for version control. This rule helps keep the repository clean from any log files that may be generated:

```
# Ignore log files
*.log
```

### Customizing Your .gitignore

- If you wish to include WordPress core files or specific plugins/themes, simply remove the respective lines from the `.gitignore` file.
- If you are working on a production setup, be cautious about including sensitive files like `wp-config.php`, which may contain credentials.

By using this `.gitignore` file, you can ensure that your repository remains clean, only tracking the necessary configuration and custom files while excluding auto-downloaded and generated content.

## Troubleshooting

- **PHP Not Stopping**: If the PHP server does not stop when pressing a key, you can manually stop it by using the Task Manager or running `Stop-Process -Name php -Force` in PowerShell.
- **Permission Issues**: If you encounter permission errors, make sure you are running PowerShell with administrative privileges.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributions

Contributions are welcome! Feel free to open an issue or submit a pull request if you have suggestions or improvements.

## Acknowledgments

- [WordPress](https://wordpress.org/)
- [PHP for Windows](https://windows.php.net/)
- [SQLite Database Integration Plugin](https://wordpress.org/plugins/sqlite-database-integration/)

