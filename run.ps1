# Define URLs and file paths
$phpUrl = "https://windows.php.net/downloads/releases/php-8.3.13-nts-Win32-vs16-x64.zip"
$phpDir = "./php"
$phpIniPath = "$phpDir/php.ini"

$wordpressUrl = "https://wordpress.org/latest.zip"
$wordpressDir = "./wordpress"

$pluginUrl = "https://downloads.wordpress.org/plugin/sqlite-database-integration.zip"
$pluginDir = "$wordpressDir/wp-content/plugins/sqlite-database-integration"

# Step 1: Download and extract PHP if ./php does not exist
if (!(Test-Path -Path $phpDir)) {
    # Create php directory
    New-Item -ItemType Directory -Path $phpDir -Force | Out-Null

    # Download and unzip PHP directly into ./php
    Invoke-WebRequest -Uri $phpUrl -OutFile "$phpDir.zip"
    Expand-Archive -Path "$phpDir.zip" -DestinationPath $phpDir -Force
    Remove-Item -Path "$phpDir.zip" -Force
    
    Rename-Item -Path "$phpDir/php.ini-development" -NewName "php.ini"
    if (Test-Path -Path $phpIniPath) {
        # Read the contents of php.ini into an array of lines
        $phpIniContent = Get-Content -Path $phpIniPath

        # Initialize a counter for occurrences of ";extension=mysqli"
        $mysqliCount = 0

        # Process each line to modify specific settings
        $phpIniContent = $phpIniContent | ForEach-Object {
            # Modify extension_dir to use a relative path
            if ($_ -match '^\s*;?\s*extension_dir\s*=') {
                $_ = 'extension_dir = ".\ext"'
            }

            # Enable only the second occurrence of `;extension=mysqli`
            if ($_ -match '^\s*;?\s*extension\s*=\s*mysqli') {
                $mysqliCount++
                if ($mysqliCount -eq 2) {
                    $_ = 'extension=mysqli'
                }
            }

            # Enable pdo_mysql extension unconditionally
            if ($_ -match '^\s*;?\s*extension\s*=\s*pdo_mysql') {
                $_ = 'extension=pdo_mysql'
            }

            # Return the modified or unmodified line
            $_
        }

        # Write the modified contents back to php.ini
        Set-Content -Path $phpIniPath -Value $phpIniContent -Force
    }
}

# Step 2: Prepare PHP for portability by setting the PHPRC environment variable
$phpPath = (Resolve-Path "$phpDir/*").Path
[Environment]::SetEnvironmentVariable("PHPRC", $phpPath, [System.EnvironmentVariableTarget]::Process)

# Step 3: Download and extract WordPress if ./wordpress/wp-admin does not exist
if (!(Test-Path -Path "$wordpressDir/wp-admin")) {
    # Download and unzip WordPress directly into the current directory
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

    # Download and unzip the SQLite Database Integration plugin
    Invoke-WebRequest -Uri $pluginUrl -OutFile "sqlite-plugin.zip"
    Expand-Archive -Path "sqlite-plugin.zip" -DestinationPath "$wordpressDir/wp-content/plugins" -Force
    Remove-Item -Path "sqlite-plugin.zip" -Force
}

# Inform user of completion
Write-Output "PHP has been downloaded, extracted to '$phpDir', and configured for portability."
if (Test-Path -Path "$wordpressDir/wp-admin") {
    Write-Output "WordPress has been downloaded and extracted to '$wordpressDir'."
} else {
    Write-Output "WordPress extraction not needed, as it already exists in '$wordpressDir'."
}
if (Test-Path -Path $pluginDir) {
    Write-Output "SQLite Database Integration plugin has been downloaded and installed to '$pluginDir'."
} else {
    Write-Output "SQLite Database Integration plugin installation not needed, as it already exists in '$pluginDir'."
}

# Start PHP's built-in development server
Start-Process -NoNewWindow -FilePath "php\php" -ArgumentList "-S localhost:8000 -t ./wordpress -c ./php/php.ini"
