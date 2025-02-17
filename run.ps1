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
    
    # Copy php.ini-development to php.ini to use as configuration
    Copy-Item -Path "$phpDir/php.ini-development" -Destination "$phpDir/php.ini" -Force

    if (Test-Path -Path $phpIniPath) {
        # Read the contents of php.ini into an array of lines for modification
        $phpIniContent = Get-Content -Path $phpIniPath

        # Initialize counter for mysqli occurrences
        $mysqliCount = 0

        # Define a mapping for extensions that need to be enabled
        $extensions = @{
            'sqlite3'    = 'extension=sqlite3'
            'openssl'    = 'extension=openssl'
            'curl'       = 'extension=curl'
            'gd'         = 'extension=gd'
            'mbstring'   = 'extension=mbstring'
            'exif'       = 'extension=exif'
            'pdo_sqlite' = 'extension=pdo_sqlite'
            'zip'        = 'extension=zip'
            'fileinfo'   = 'extension=fileinfo'
            'intl'       = 'extension=intl'
        }

        # Process each line to modify specific settings
        $modifiedContent = $phpIniContent | ForEach-Object {
            $line = $_

            # Modify extension_dir to use a relative path for portability
            if ($line -match '^\s*;?\s*extension_dir\s*=') {
                $line = 'extension_dir = ".\ext"'
            }
            
            # Adjust file upload and memory settings
            if ($line -match '^\s*;?\s*upload_max_filesize\s*=') {
                $line = 'upload_max_filesize = 256M'
            }
            if ($line -match '^\s*;?\s*post_max_size\s*=') {
                $line = 'post_max_size = 256M'
            }
            if ($line -match '^\s*;?\s*memory_limit\s*=') {
                $line = 'memory_limit = 512M'
            }

            # Enable only the second occurrence of extension=mysqli to avoid conflicts
            if ($line -match '^\s*;?\s*extension\s*=\s*mysqli') {
                $mysqliCount++
                if ($mysqliCount -eq 2) {
                    $line = 'extension=mysqli'
                }
            }

            # Enable other extensions as defined in the hashtable
            foreach ($ext in $extensions.Keys) {
                if ($line -match "^\s*;?\s*extension\s*=\s*$ext") {
                    $line = $extensions[$ext]
                    break
                }
            }

            $line
        }

        # Write the modified contents back to php.ini
        Set-Content -Path $phpIniPath -Value $modifiedContent -Force
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
