# Define URLs and file paths

# URL to download PHP package -- remember to UPDATE THIS
$phpUrl = "https://windows.php.net/downloads/releases/php-8.4.4-nts-Win32-vs17-x64.zip"

# URL to download NGinx
$nginxUrl = "http://nginx.org/download/nginx-1.27.4.zip"

# URL to download WordPress
$wordpressUrl = "https://wordpress.org/latest.zip"

# URL to download SQLite Database Integration plugin
$pluginUrl = "https://downloads.wordpress.org/plugin/sqlite-database-integration.zip"

# Directory to store PHP installation
$phpDir = "./php"

# Directory to store WordPress installation
$wordpressDir = "./wordpress"

# Directory to store NGinx installation
$nginxDir = "./nginx-1.27.4"

# Directory to store SQLite Database Integration plugin
$pluginDir = "$wordpressDir/wp-content/plugins/sqlite-database-integration"

# Path to php.ini file
$phpIniPath = "$phpDir/php.ini"

# Step 1: Download and extract PHP if ./php does not exist
if (!(Test-Path -Path $phpDir)) {
    # Create php directory if it does not exist
    New-Item -ItemType Directory -Path $phpDir -Force | Out-Null

    # Download PHP package and unzip it into ./php
    Invoke-WebRequest -Uri $phpUrl -OutFile "$phpDir.zip"
    Expand-Archive -Path "$phpDir.zip" -DestinationPath $phpDir -Force
    Remove-Item -Path "$phpDir.zip" -Force
}

# Step 2: Download and extract nginx webserver if it doesn't exist
if (!(Test-Path -Path $nginxDir)) {
    # Download and unzip nginx
    Invoke-WebRequest -Uri $nginxUrl -OutFile "nginx.zip"
    Expand-Archive -Path "nginx.zip" -DestinationPath "./" -Force
    Remove-Item -Path "nginx.zip" -Force
}

# Step 3: Download and extract WordPress if ./wordpress/wp-admin does not exist
if (!(Test-Path -Path "$wordpressDir/wp-admin")) {
    # Download and unzip WordPress into the current directory if it does not exist
    Invoke-WebRequest -Uri $wordpressUrl -OutFile "wordpress.zip"
    Expand-Archive -Path "wordpress.zip" -DestinationPath "./" -Force
    Remove-Item -Path "wordpress.zip" -Force
}

# Step 4: Download and extract the SQLite Database Integration plugin if it does not exist
if (!(Test-Path -Path $pluginDir)) {
    # Ensure the plugins directory exists
    if (!(Test-Path -Path "$wordpressDir/wp-content/plugins")) {
        New-Item -ItemType Directory -Path "$wordpressDir/wp-content/plugins" -Force | Out-Null
    }

    # Download and unzip the SQLite Database Integration plugin into the plugins directory
    Invoke-WebRequest -Uri $pluginUrl -OutFile "sqlite-plugin.zip"
    Expand-Archive -Path "sqlite-plugin.zip" -DestinationPath "$wordpressDir/wp-content/plugins" -Force
    Remove-Item -Path "sqlite-plugin.zip" -Force
    
    # Copy db.copy to db.php for SQLite integration
    Copy-Item -Path "$wordpressDir/wp-content/plugins/sqlite-database-integration/db.copy" -Destination "$wordpressDir/wp-content/db.php" -Force
}

# Step 5: Start PHP's built-in development server
# Set PHPRC environment variable to point to the PHP directory
$phpPath = (Resolve-Path "$phpDir/*").Path
[Environment]::SetEnvironmentVariable("PHPRC", $phpPath, [System.EnvironmentVariableTarget]::Process)

# Launch PHP's built-in development server to serve WordPress
$phpProcess = Start-Process -FilePath "php\php" -ArgumentList "-S localhost:8000 -t ./wordpress -c ./php/php.ini" -NoNewWindow -PassThru

Write-Output "Press any key to stop the server..."

# Wait for any key press to stop the server
[Console]::ReadKey($true) | Out-Null

# Stop the PHP process when a key is pressed
try {
    Stop-Process -Id $phpProcess.Id -Force
    Write-Output "PHP server stopped successfully."
} catch {
    Write-Output "Failed to stop PHP server: $_"
}
