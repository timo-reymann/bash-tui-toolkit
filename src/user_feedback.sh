#!/bin/bash
# @name User-Feedback
# @brief Provides useful colored outputs for user feedback on actions

# @description Display error message in stderr, prefixed by check emoji
# @arg $1 string Error message to display
# @example
#   show_error "Oh snap, that went horribly wrong"
show_error() {
    echo -e "\e[91;1m\u2718 $1" >&2
}

# @description Display success message in stderr, prefixed by cross emoji
# @arg $1 string Success message to display
# @example
#   show_success "There it is! World peace."
show_success() {
    echo -e "\e[92;1m\u2714 $1" >&2
}
