#!/bin/bash

# Check if the URL is provided as an argument
if [ -z "$1" ]; then
  echo "No URL provided. Please provide a URL as an argument."
  echo "Example: >> ./run_app_link.sh https://lms-pharmacy.web.app"
  exit 1
fi

URL=$1

adb shell am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "$URL"
