# QStack Plugin

![Entry screenshot](assets\entry.png)

## Overview

QStack is a powerful Cmder plugin that enhances your command-line experience with directory navigation management. It provides a stack-based approach to remembering and switching between directories, allowing users to traverse through their directories efficiently.

### Project Structure

      QStackPlugin/
      ├── Setup/
      │   ├── QStackInstall.ps1    # Installation script
      │   ├── QStackInstall.exe    # Executable installer
      │   └── README.md            # Plugin documentation
      ├── config/
      │   └── qstack.json          # User configuration
      └── LICENSE                  # Project license

### Setup Instructions

#### Automatic Installation

1. Download the QStackInstall.exe file
2. Run the installer with administrator privileges
3. The plugin will be automatically installed to your Cmder configuration

#### Manual Installation

1. Clone or download this repository
2. Copy all files to `C:\Program Files\cmder\config\QStackPlugin\`

## Basic Commands

- `show-als` - Displays the alias menu.
- `git-fp` - Runs the `git fetch --all` command then `git pull`
- `crawl [dir]` - Crawls through the provided directory and adds custom aliases for directories where .sln files are found.

## Contribution

Feel free to contribute to this project by submitting issues or pull requests. Please ensure that your code adheres to the project's coding standards and includes appropriate documentation.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

![Alias menu screenshot](assets\aliasMenu.png)

![Git aliases screenshot](assets\gitCmds.png)

![Fuzzy search screenshot](assets\fuzzySearch.png)
