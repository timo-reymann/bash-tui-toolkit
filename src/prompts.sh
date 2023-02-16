#!/bin/bash
# @name Prompts
# @brief Inquirer.js inspired prompts

_get_cursor_row() {
    local IFS=';'
    # shellcheck disable=SC2162,SC2034
    read -sdR -p $'\E[6n' ROW COL;
    echo "${ROW#*[}";
}
_cursor_blink_on() { echo -en "\e[?25h" >&2; }
_cursor_blink_off() { echo -en "\e[?25l" >&2; }
_cursor_to() { echo -en "\e[$1;${2:-1}H" >&2; }

# key input helper
_key_input() {
    read -s -r -N1 key 2>/dev/null >&2
    case $key in
        "A")   echo "up"; ;;
        "B")   echo "down"; ;;
        " ")   echo "space"; ;;
        $'\n') echo "enter" ;;
    esac
}

# print new line for empty element in array
# shellcheck disable=SC2231
_new_line_foreach_item() {
    count=0
    while [[ $count -lt $1  ]];
    do
        echo "" >&2
        ((count++))
    done
}

# display prompt text without linebreak
_prompt_text() {
    echo -en "\e[32m?\e[0m\e[1m ${1}\e[0m " >&2
}

# decrement counter $1, considering out of range for $2
_decrement_selected() {
    local selected=$1;
    ((selected--))
    if [ "${selected}" -lt 0 ]; then
        selected=$(($2 - 1));
    fi
    echo -n $selected
}

# increment counter $1, considering out of range for $2
_increment_selected() {
    local selected=$1;
    ((selected++));
    if [ "${selected}" -ge "${opts_count}" ]; then
        selected=0;
    fi
    echo -n $selected
}

# checks if $1 contains element $2
_contains() {
    items=$1
    search=$2
    for item in "${items[@]}"; do
        if [ "$item" == "$search" ]; then return 0; fi
    done
    return 1
}

# @description Prompt for text
# @arg $1 string Phrase for prompting to text
# @stderr Instructions for user
# @stdout Text as provided by user
# @example
#   # Raw input without validation
#   text=$(input "Please enter something and confirm with enter")
# @example
#   # Input with validation
#   text=$(with_validate 'input "Please enter at least one character and confirm with enter"' validate_present)
input() {
    _prompt_text "$1"; echo -en "\e[36m\c" >&2
    read -r text
    echo -n "${text}"
}

# @description Show confirm dialog for yes/no
# @arg $1 string Phrase for promptint to text
# @stdout 0 for no, 1 for yes
# @stderr Instructions for user
# @example
#   confirmed=$(confirm "Should it be?")
#   if [ "$confirmed" = "0" ]; then echo "No?"; else echo "Yes!"; fi
confirm() {
    _prompt_text "$1 (y/N)"
    echo -en "\e[36m\c " >&2
    local result=""
    echo -n " " >&2
    until [[ "$result" == "y" ]] || [[ "$result" == "N" ]]
    do
        echo -e "\e[1D\c " >&2
        # shellcheck disable=SC2162
        read -n1 result
    done
    echo -en "\e[0m" >&2

    case $result in
        y) echo -n 1; ;;
        N) echo -n 0 ;;
    esac

    echo "" >&2
}

# @description Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
# Inspired by https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu/415155#415155
# @arg $1 string Phrase for promptint to text
# @arg $2 array List of options (max 256)
# @stdout selected index (0 for opt1, 1 for opt2 ...)
# @stderr Instructions for user
# @example
#   options=("one" "two" "three" "four")
#   option=$(list "Select one item" "${options[@]}")
#   echo "Your choice: ${options[$option]}"
list() {
    _prompt_text "$1 "

    local opts=("${@:2}")
    local opts_count=$(($# -1))
    _new_line_foreach_item "${#opts[@]}"

    # determine current screen position for overwriting the options
    local lastrow; lastrow=$(_get_cursor_row)
    local startrow; startrow=$((lastrow - opts_count + 1))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "_cursor_blink_on; stty echo; exit" 2
    _cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt in "${opts[@]}"; do
            _cursor_to $((startrow + idx))
            if [ $idx -eq $selected ]; then
                printf "\e[0m\e[36m\u276F\e[0m \e[36m%s\e[0m" "$opt" >&2
            else
                printf "  %s" "$opt" >&2
            fi
            ((idx++))
        done

        # user key control
        case $(_key_input) in
            enter) break; ;;
            up) selected=$(_decrement_selected "${selected}" "${opts_count}"); ;;
            down) selected=$(_increment_selected "${selected}" "${opts_count}"); ;;
        esac
    done

    echo -en "\n" >&2

    # cursor position back to normal
    _cursor_to "${lastrow}"
    _cursor_blink_on

   echo -n "${selected}"
}

# @description Render a text based list of options, where multiple can be selected by the
# user using up, down and enter keys and returns the chosen option.
# Inspired by https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu/415155#415155
# @arg $1 string Phrase for promptint to text
# @arg $2 array List of options (max 256)
# @stdout selected index (0 for opt1, 1 for opt2 ...)
# @stderr Instructions for user
# @example
#   options=("one" "two" "three" "four")
#   checked=$(checkbox "Select one or more items" "${options[@]}")
#   echo "Your choices: ${checked}"
checkbox() {
    _prompt_text "$1"

    local opts; opts=("${@:2}")
    local opts_count; opts_count=$(($# -1))
    _new_line_foreach_item "${#opts[@]}"

    # determine current screen position for overwriting the options
    local lastrow; lastrow=$(_get_cursor_row)
    local startrow; startrow=$((lastrow - opts_count + 1))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "_cursor_blink_on; stty echo; exit" 2
    _cursor_blink_off

    local selected=0
    local checked=()
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt in "${opts[@]}"; do
            _cursor_to $((startrow + idx))
            local icon
            if _contains "${checked[*]}" $idx; then
                icon=$(echo -en "\u25C9")
            else
                icon=$(echo -en "\u25EF")
            fi
            if [ $idx -eq $selected ]; then
                printf "%s \e[0m\e[36m\u276F\e[0m \e[36m%-50s\e[0m" "$icon" "$opt" >&2
            else
                printf "%s   %-50s " "$icon" "$opt" >&2
            fi
            ((idx++))
        done

        # user key control
        case $(_key_input) in
            enter) break;;
            space)
                if _contains "${checked[*]}" $selected; then
                     checked=( "${checked[@]/$selected}" )
                else
                    checked+=("${selected}")
                fi
                ;;
            up) selected=$(_decrement_selected "${selected}" "${opts_count}"); ;;
            down) selected=$(_increment_selected "${selected}" "${opts_count}"); ;;
        esac
    done

    # cursor position back to normal
    _cursor_to "${lastrow}"
    _cursor_blink_on

    IFS=" " echo -n "${checked[@]}"
}

# @description Show password prompt displaying stars for each password character letter typed
# it also allows deleting input
# @arg $1 string Phrase for promptint to text
# @stdout password as written by user
# @stderr Instructions for user
# @example
#   # Password prompt with custom validation
#   validate_password() { if [ ${#1} -lt 10 ];then echo "Password needs to be at least 10 characters"; exit 1; fi }
#   pass=$(with_validate 'password "Enter random password"' validate_password)
# @example
#   # Password ith no validation
#   pass=$(password "Enter password to use")
password() {
    _prompt_text "$1"
    echo -en "\e[36m" >&2
    local password=''
    local IFS=
    while read -r -s -n1 char; do
        # ENTER pressed; output \n and break.
        [[ -z "${char}" ]] && { printf '\n' >&2; break; }
        # BACKSPACE pressed; remove last character
        if [ "${char}" == $'\x7f' ]; then
            if [ "${#password}" -gt 0 ]; then
                password="${password%?}"
                echo -en '\b \b' >&2
            fi
        else
            password+=$char
            echo -en '*' >&2
        fi
    done
    echo -en "\e[0m" >&2
    echo -n "${password}"
}

# @description Open default editor ($EDITOR) if none is set falls back to vi
# @arg $1 string Phrase for promptint to text
# @stdout Text as input by user in input
# @stderr Instructions for user
# @example
#   # Open default editor
#   text=$(editor "Please enter something in the editor")
#   echo -e "You wrote:\n${text}"
editor() {
    tmpfile=$(mktemp)
    _prompt_text "$1"
    echo "" >&2

    "${EDITOR:-vi}" "${tmpfile}" >/dev/tty
    echo -en "\e[36m" >&2
    # shellcheck disable=SC2002
    cat "${tmpfile}" | sed -e 's/^/  /' >&2
    echo -en "\e[0m" >&2

    cat "${tmpfile}"
}

# @description Evaluate prompt command with validation, this prompts the user for input till the validation function
# returns with 0
# @arg $1 string Prompt command to evaluate until validation is successful
# @arg #2 function validation callback (this is called once for exit code and once for status code)
# @stdout Value collected by evaluating prompt
# @stderr Instructions for user
# @example
#   # Using builtin is present validator
#   text=$(with_validate 'input "Please enter something and confirm with enter"' validate_present)
# @example
#   # Using custom validator e.g. for password
#   validate_password() { if [ ${#1} -lt 10 ];then echo "Password needs to be at least 10 characters"; exit 1; fi }
#   pass=$(with_validate 'password "Enter random password"' validate_password)
with_validate() {
    while true; do
        local val; val="$(eval "$1")"
        if ($2 "$val" >/dev/null); then
            echo "$val";
            break;
        else
            show_error "$($2 "$val")";
        fi
    done
}

# @description Validate a prompt returned any value
# @arg $1 value to validate
# @stdout error message for user
# @exitcode 0 String is at least 1 character long
# @exitcode 1 There was no input given
# @example
#   # text input with validation
#   text=$(with_validate 'input "Please enter something and confirm with enter"' validate_present)
validate_present() {
    if [ "$1" != "" ]; then return 0; else echo "Please specify the value"; return 1; fi
}
