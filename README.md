
# CowGreeting, RGlusic's cowsay on sterioids.
Features:
Friendly greetings based on time of day (morning, afternoon, evening)
Personalized with your system username
Customizable date and time formats
Optional time display (12-hour or 24-hour)
Cross-shell compatible (bash, zsh)
Configurable via a simple .greetcow.conf file
Works great in .bashrc, .zshrc, or on login

🛠 Installation
1. Manual Installation
Clone the repo and install the script:
git clone https://github.com/yourusername/greetcow.git
cd greetcow
chmod +x greetcow.sh
sudo cp greetcow.sh /usr/local/bin/greetcow
Or place it anywhere in your PATH.
2. Configuration
Create a .greetcow.conf in the same directory as the script or in your home folder. Here's an example config:
# .greetcow.conf
date_format=%Y-%m-%d
time_format=%H:%M
show_time=true
time_12hr=false
timezone=local
date_format: Any valid date format string
time_format: Optional, if show_time=true
show_time: Whether to display the time
time_12hr: Use 12-hour time format (true/false)
timezone: Currently defaults to system local time
If no config is found, it will use sensible defaults.
# Reqirements:
bash/zsh terminal enviroment, CowSay (in your path).
