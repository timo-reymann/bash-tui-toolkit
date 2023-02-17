#!/bin/bash
# @name User-Feedback
# @brief Provides useful colored outputs for user feedback on actions

# @description Display error message in stderr, prefixed by check emoji
# @arg $1 string Error message to display
# @example
#   show_error "Oh snap, that went horribly wrong"
show_error() {
    echo -e "\033[91;1m✘ $1\033[0m" >&2
}

# @description Display success message in stderr, prefixed by cross emoji
# @arg $1 string Success message to display
# @example
#   show_success "There it is! World peace."
show_success() {
    echo -e "\033[92;1m✔ $1\033[0m" >&2
}
