#!/usr/bin/env bash
#
# Basic demo of features
#
cd src || exit 2
source main.sh
cd - || exit 2

#
# Platform
#
echo "You are using the OS '$(detect_os)'"
echo "Opener for tools/links: '$(get_opener)'"
open_link "https://github.com"

#
# UTILS
#
show_error "Something went wrong"
show_success "There we go"

#
# LOGGING
#
export LOG_LEVEL="$LOG_DEBUG"
log "$LOG_DEBUG" "Debug message"
log "$LOG_INFO" "Info message"
log "$LOG_WARN" "Warn message"
log "$LOG_ERROR" "Error message"

#
# PROMPTS
#

options=("one" "two" "three" "four" "a" "b" "c" "d" "e")

validate_password() {
    if [ ${#1} -lt 10 ];then
        echo "Password needs to be at least 10 characters"
        exit 1
    fi
}
# Password prompt
#pass=$(with_validate 'password "Enter random password"' validate_password)

# Checkbox
checked=$(checkbox "Select one or more items" "${options[@]}")

# text input with validation
#text=$(with_validate 'input "Please enter something and confirm with enter"' validate_present)

# Select
option=$(list "Select one item" "${options[@]}")

# Confirm
confirmed=$(confirm "Should it be?")

# Open editor
editor=$(editor "Please enter something in the editor")

# Print results
echo "
---
password:
$pass
input:
$text
select:
$option
checkbox:
$checked
confirm:
$confirmed
editor:
$editor
"
