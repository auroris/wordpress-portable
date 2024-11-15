# WordPress Portable

This PowerShell script automates the setup of a local development environment for WordPress using a portable PHP installation. It also integrates the SQLite Database Integration plugin for WordPress to allow usage without MySQL. This makes it easy to quickly get a WordPress site running locally with minimal manual configuration.

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
   .\wordpress_php_setup.ps1
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
- [SQLite Database Integration Plugin](https://downloads.wordpress.org/plugin/sqlite-database-integration.zip)

