#!/bin/sh

# Get the directory of the script
SCRIPT_DIR=$(dirname "$0")

# Load config if available
CONFIG_FILE="$SCRIPT_DIR/greetcow.conf"
[ -f "$CONFIG_FILE" ] && . "$CONFIG_FILE"


# Plugin path - auto-create user config directory
DEFAULT_PLUGIN_DIR="$HOME/.config/cowgreeting/plugins"
PLUGIN_PATH="${PLUGIN_DIR:-$DEFAULT_PLUGIN_DIR}"

# Auto-create plugin directory if it doesn't exist
if [ ! -d "$PLUGIN_PATH" ]; then
    mkdir -p "$PLUGIN_PATH"
fi


# Defaults if not set in config
SHOW_TIME=${SHOW_TIME:-true}
TIME_FORMAT_24HR=${TIME_FORMAT_24HR:-true}
TIMEZONE=${TIMEZONE:-"UTC"}
SHOW_DATE=${SHOW_DATE:-true}
DATE_FORMAT=${DATE_FORMAT:-"%Y-%m-%d"}
TIME_BEFORE_DATE=${TIME_BEFORE_DATE:-true}
GREETING_TEMPLATE=${GREETING_TEMPLATE:-"Good TIMEOFDAY, USER! It is DATESTR."}

# Set timezone
export TZ="$TIMEZONE"

# Time-of-day logic
HOUR=$(date +%H)
if [ "$HOUR" -lt 12 ]; then
    TIMEOFDAY="morning"
elif [ "$HOUR" -lt 18 ]; then
    TIMEOFDAY="afternoon"
else
    TIMEOFDAY="evening"
fi



# Get username
USER=$(whoami)

# Build date/time
TIME_PART=""
DATE_PART=""

if [ "$SHOW_TIME" = true ]; then
    if [ "$TIME_FORMAT_24HR" = true ]; then
        # Use 24-hour format
        TIME_PART=$(date +"$TIME_FORMAT_24HR_FORMAT")
    else
        # Use AM/PM format
        TIME_PART=$(date +"$TIME_FORMAT_AMPM_FORMAT")
    fi
fi

if [ "$SHOW_DATE" = true ]; then
    DATE_PART=$(date +"$DATE_FORMAT")
fi

# Ensure the date/time isn't empty
if [ -n "$TIME_PART" ] && [ -n "$DATE_PART" ]; then
    if [ "$TIME_BEFORE_DATE" = true ]; then
        DATESTR="$TIME_PART $DATE_PART"
    else
        DATESTR="$DATE_PART $TIME_PART"
    fi
elif [ -n "$TIME_PART" ]; then
    DATESTR="$TIME_PART"
elif [ -n "$DATE_PART" ]; then
    DATESTR="$DATE_PART"
else
    DATESTR="some time"
fi

# Fill template manually
GREETING=$(printf "%s\n" "$GREETING_TEMPLATE" \
    | sed "s/TIMEOFDAY/$TIMEOFDAY/" \
    | sed "s/USER/$USER/" \
    | sed "s/DATESTR/$DATESTR/")

# --------------------------------------------------


# Plugin Logic
if [ "$DISABLE_PLUGINS" != "true" ] && [ -d "$PLUGIN_PATH" ]; then
    for plugin in "$PLUGIN_PATH"/*; do
        plugin_name=$(basename "$plugin")

        if [ -n "$PLUGINS" ]; then
            case " $PLUGINS " in
                *" $plugin_name "*) ;;  # plugin is in whitelist, continue
                *) continue ;;          # plugin not in whitelist, skip
            esac
        fi

        if [ -x "$plugin" ]; then
            plugin_output="$("$plugin" 2>&1)"
            exit_code=$?

            if [ $exit_code -eq 0 ]; then
                GREETING="$GREETING 
		$plugin_output"
            else
                if [ "$SILENT" != "true" ]; then
                    GREETING="$GREETING
		    [Plugin Error: $plugin_name exited with code $exit_code]"
                    GREETING="$GREETING
		    $plugin_output"
                fi
            fi
        else
            if [ "$SILENT" != "true" ]; then
                GREETING="$GREETING
		[Plugin Skipped: $plugin_name is not executable]"
            fi
        fi
    done
elif [ "$DISABLE_PLUGINS" != "true" ] && [ "$SILENT" != "true" ]; then
    GREETING="$GREETING
    [Plugin directory not found: $PLUGIN_PATH]"
fi


# Output with cowsay
cowsay "$GREETING"
