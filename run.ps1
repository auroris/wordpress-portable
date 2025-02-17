# Define URLs and file paths

# URL to download PHP package -- remember to UPDATE THIS
$phpUrl = "https://windows.php.net/downloads/releases/php-8.4.4-nts-Win32-vs17-x64.zip"

# Directory to store PHP installation
$phpDir = "./php"

# Path to php.ini file
$phpIniPath = "$phpDir/php.ini"

# URL to download WordPress
$wordpressUrl = "https://wordpress.org/latest.zip"
# Directory to store WordPress installation
$wordpressDir = "./wordpress"

# URL to download SQLite Database Integration plugin
$pluginUrl = "https://downloads.wordpress.org/plugin/sqlite-database-integration.zip"
# Directory to store SQLite Database Integration plugin
$pluginDir = "$wordpressDir/wp-content/plugins/sqlite-database-integration"

# Step 1: Download and extract PHP if ./php does not exist
if (!(Test-Path -Path $phpDir)) {
    # Create php directory if it does not exist
    New-Item -ItemType Directory -Path $phpDir -Force | Out-Null

    # Download PHP package and unzip it into ./php
    Invoke-WebRequest -Uri $phpUrl -OutFile "$phpDir.zip"
    Expand-Archive -Path "$phpDir.zip" -DestinationPath $phpDir -Force
    Remove-Item -Path "$phpDir.zip" -Force
    
    # Rename php.ini-development to php.ini to use as configuration
    Rename-Item -Path "$phpDir/php.ini-development" -NewName "php.ini"
    if (Test-Path -Path $phpIniPath) {
        # Read the contents of php.ini into an array of lines for modification
        $phpIniContent = Get-Content -Path $phpIniPath

        # Process each line to modify specific settings
        $phpIniContent = $phpIniContent | ForEach-Object {
            # Modify extension_dir to use a relative path for portability
            if ($_ -match '^\s*;?\s*extension_dir\s*=') {
                $_ = 'extension_dir = ".\ext"'
            }
            
            # Enable only the second occurrence of `;extension=mysqli` to avoid conflicts
            if ($_ -match '^\s*;?\s*extension\s*=\s*mysqli') {
                $mysqliCount++
                if ($mysqliCount -eq 2) {
                    $_ = 'extension=mysqli'
                }
            }

            # Enable sqlite3 extension
            if ($_ -match '^\s*;?\s*extension\s*=\s*sqlite3') {
                $_ = 'extension=sqlite3'
            }
            
            # Enable openssl extension
            if ($_ -match '^\s*;?\s*extension\s*=\s*openssl') {
                $_ = 'extension=openssl'
            }
            
            # Enable curl extension
            if ($_ -match '^\s*;?\s*extension\s*=\s*curl') {
                $_ = 'extension=curl'
            }
            
            # Enable pdo_sqlite extension
            if ($_ -match '^\s*;?\s*extension\s*=\s*pdo_sqlite') {
                $_ = 'extension=pdo_sqlite'
            }
            
            # Return the modified or unmodified line
            $_
        }

        # Write the modified contents back to php.ini
        Set-Content -Path $phpIniPath -Value $phpIniContent -Force
    }
}

# Step 2: Prepare PHP for portability by setting the PHPRC environment variable
# Set PHPRC environment variable to point to the PHP directory
$phpPath = (Resolve-Path "$phpDir/*").Path
[Environment]::SetEnvironmentVariable("PHPRC", $phpPath, [System.EnvironmentVariableTarget]::Process)

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

# Step 6: Start PHP's built-in development server
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
