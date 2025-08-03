
# CowGreeting, RGlusic's cowhello on sterioids.

[![Build and Test](https://github.com/hazypugfluff/CowGreeting/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/hazypugfluff/CowGreeting/actions/workflows/build-and-test.yml)
[![Release](https://github.com/hazypugfluff/CowGreeting/actions/workflows/release.yml/badge.svg)](https://github.com/hazypugfluff/CowGreeting/actions/workflows/release.yml)

Features:
Friendly greetings based on time of day (morning, afternoon, evening)
Personalized with your system username
Customizable date and time formats
Optional time display (12-hour or 24-hour)
Cross-shell compatible (bash, zsh)
Configurable via a simple .greetcow.conf file
Works great in .bashrc, .zshrc, or on login

# Now with ✨ Plugins! ✨

Plugins are automatically stored in `~/.config/cowgreeting/plugins/` and the directory is created on first run.

🛠 Installation

## 1. Debian Package Installation (Recommended)

Download the latest `.deb` package from the [Releases page](https://github.com/hazypugfluff/CowGreeting/releases) and install:

```bash
# Download and install the package
wget https://github.com/hazypugfluff/CowGreeting/releases/latest/download/cowgreeting_VERSION_all.deb
sudo dpkg -i cowgreeting_VERSION_all.deb

# If dependencies are missing, install them:
sudo apt-get install -f
```

The package automatically:
- ✅ Installs cowsay dependency
- ✅ Creates `cowgreeting` and `greetcow` commands
- ✅ Sets up plugin system
- ✅ Handles uninstallation cleanly

## 2. Manual Installation
Clone the repo and install the script:

git clone https://github.com/hazypugfluff/CowGreeting

cd greetcow

chmod +x greetcow.sh

sudo cp greetcow.sh /usr/local/bin/greetcow

Or place it anywhere in your PATH.

## 3. Configuration
CowGreeting looks for configuration files in two locations (in order of priority):
1. `~/.config/cowgreeting/greetcow.conf` (recommended)
2. Same directory as the script (legacy)

Here's an example config:
# .greetcow.conf

date_format=%Y-%m-%d

time_format=%H:%M

show_time=true

time_12hr=false

timezone=local

If no config is found, it will use sensible defaults.

## 🧪 Development & Testing

This project includes comprehensive GitHub Actions workflows for:

### Automated Testing
- ✅ Builds .deb package on every push/PR
- ✅ Tests installation and basic functionality  
- ✅ Tests plugin system and auto-creation of config directory
- ✅ Tests custom configuration options
- ✅ Tests error handling with broken plugins
- ✅ Tests package removal
- ✅ Uploads build artifacts

### Automated Releases
- ✅ Builds release packages when tags are pushed
- ✅ Creates GitHub releases with .deb files
- ✅ Automatically updates version numbers

To run tests locally:
```bash
# Install build dependencies
sudo apt-get install build-essential debhelper devscripts cowsay

# Build the package
debuild -b -us -uc

# Install and test
sudo dpkg -i ../cowgreeting_*.deb
cowgreeting
```

# Reqirements:
bash/zsh terminal enviroment, CowSay (in your path).
