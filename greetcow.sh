#!/bin/sh

# Get the directory of the script
SCRIPT_DIR=$(dirname "$0")

# Load config if available
CONFIG_FILE="$SCRIPT_DIR/greetcow.conf"
[ -f "$CONFIG_FILE" ] && . "$CONFIG_FILE"

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

# Output with cowsay
cowsay "$GREETING"
