_get_cursor_row() {
    local IFS=';'
    read -sdR -p $'\E[6n' ROW COL
    echo "${ROW#*[}"
}
_cursor_blink_on() { echo -en "\e[?25h" >&2; }
_cursor_blink_off() { echo -en "\e[?25l" >&2; }
_cursor_to() { echo -en "\e[$1;${2:-1}H" >&2; }
_key_input() {
    read -s -r -N1 key 2>/dev/null >&2
    case $key in
        "A")   echo "up"  ;;
        "B")   echo "down"  ;;
        " ")   echo "space"  ;;
        $'\n') echo "enter" ;;
    esac
}
_new_line_foreach_item() {
    count=0
    while [[ $count -lt $1  ]]; do
        echo "" >&2
        ((count++))
    done
}
_prompt_text() {
    echo -en "\e[32m?\e[0m\e[1m ${1}\e[0m " >&2
}
_decrement_selected() {
    local selected=$1
    ((selected--))
    if [ "${selected}" -lt 0 ]; then
        selected=$(($2 - 1))
    fi
    echo -n $selected
}
_increment_selected() {
    local selected=$1
    ((selected++))
    if [ "${selected}" -ge "${opts_count}" ]; then
        selected=0
    fi
    echo -n $selected
}
_contains() {
    items=$1
    search=$2
    for item in "${items[@]}"; do
        if [ "$item" == "$search" ]; then return 0; fi
    done
    return 1
}
input() {
    _prompt_text "$1"
                       echo -en "\e[36m\c" >&2
    read -r text
    echo -n "${text}"
}
confirm() {
    _prompt_text "$1 (y/N)"
    echo -en "\e[36m\c " >&2
    local result=""
    echo -n " " >&2
    until [[ "$result" == "y" ]] || [[ "$result" == "N" ]]; do
        echo -e "\e[1D\c " >&2
        read -n1 result
    done
    echo -en "\e[0m" >&2
    case $result in
        y) echo -n 1  ;;
        N) echo -n 0 ;;
    esac
    echo "" >&2
}
list() {
    _prompt_text "$1 "
    local opts=("${@:2}")
    local opts_count=$(($# - 1))
    _new_line_foreach_item "${#opts[@]}"
    local lastrow
                   lastrow=$(_get_cursor_row)
    local startrow
                    startrow=$((lastrow - opts_count + 1))
    trap "_cursor_blink_on; stty echo; exit" 2
    _cursor_blink_off
    local selected=0
    while true; do
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
        case $(_key_input) in
            enter) break  ;;
            up) selected=$(_decrement_selected "${selected}" "${opts_count}")  ;;
            down) selected=$(_increment_selected "${selected}" "${opts_count}")  ;;
        esac
    done
    echo -en "\n" >&2
    _cursor_to "${lastrow}"
    _cursor_blink_on
    echo -n "${selected}"
}
checkbox() {
    _prompt_text "$1"
    local opts
                opts=("${@:2}")
    local opts_count
                      opts_count=$(($# - 1))
    _new_line_foreach_item "${#opts[@]}"
    local lastrow
                   lastrow=$(_get_cursor_row)
    local startrow
                    startrow=$((lastrow - opts_count + 1))
    trap "_cursor_blink_on; stty echo; exit" 2
    _cursor_blink_off
    local selected=0
    local checked=()
    while true; do
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
        case $(_key_input) in
            enter) break ;;
            space)
                if _contains "${checked[*]}" $selected; then
                     checked=("${checked[@]/$selected/}")
            else
                    checked+=("${selected}")
            fi
                ;;
            up) selected=$(_decrement_selected "${selected}" "${opts_count}")  ;;
            down) selected=$(_increment_selected "${selected}" "${opts_count}")  ;;
        esac
    done
    _cursor_to "${lastrow}"
    _cursor_blink_on
    IFS=" " echo -n "${checked[@]}"
}
password() {
    _prompt_text "$1"
    echo -en "\e[36m" >&2
    local password=''
    local IFS=
    while read -r -s -n1 char; do
        [[ -z "${char}" ]] && {
                                printf '\n' >&2
                                                 break
        }
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
editor() {
    tmpfile=$(mktemp)
    _prompt_text "$1"
    echo "" >&2
    "${EDITOR:-vi}" "${tmpfile}" >/dev/tty
    echo -en "\e[36m" >&2
    cat "${tmpfile}" | sed -e 's/^/  /' >&2
    echo -en "\e[0m" >&2
    cat "${tmpfile}"
}
with_validate() {
    while true; do
        local val
                   val="$(eval "$1")"
        if ($2 "$val" >/dev/null); then
            echo "$val"
            break
        else
            show_error "$($2 "$val")"
        fi
    done
}
validate_present() {
    if [ "$1" != "" ]; then return 0; else
                                           echo "Please specify the value"
                                                                            return 1
    fi
}
show_error() {
    echo -e "\e[91;1m\u2718 $1\e[0m" >&2
}
show_success() {
    echo -e "\e[92;1m\u2714 $1\e[0m" >&2
}
LOG_ERROR=3
LOG_WARN=2
LOG_INFO=1
LOG_DEBUG=0
parse_log_level() {
    local level="$1"
    local parsed
    case "${level}" in
      info | INFO)   parsed=$LOG_INFO  ;;
      debug | DEBUG) parsed=$LOG_DEBUG  ;;
      warn | WARN)   parsed=$LOG_WARN  ;;
      error | ERROR) parsed=$LOG_ERROR  ;;
      *)             parsed=-1  ;;
    esac
    export LOG_LEVEL="${parsed}"
}
log() {
    local level="$1"
    local message="$2"
    local color=""
    if [[ $level -lt ${LOG_LEVEL:-$LOG_INFO} ]]; then
        return
    fi
    case "${level}" in
      "$LOG_INFO")
        level="INFO"
        color='\e[1;36m'
        ;;
      "$LOG_DEBUG")
        level="DEBUG"
        color='\e[1;34m'
        ;;
      "$LOG_WARN")
        level="WARN"
        color='\e[0;33m'
        ;;
      "$LOG_ERROR")
        level="ERROR"
        color='\e[0;31m'
        ;;
    esac
    echo -e "[${color}$(printf '%-5s' "${level}")\e[0m] \e[1;35m$(date +'%Y-%m-%dT%H:%M:%S')\e[0m ${message}"
}
detect_os() {
    case "$OSTYPE" in
        solaris*) echo "solaris"  ;;
        darwin*)  echo "macos"  ;;
        linux*)   echo "linux"  ;;
        bsd*)     echo "bsd"  ;;
        msys*)    echo "windows"  ;;
        cygwin*)  echo "windows"  ;;
        *)        echo "unknown"  ;;
    esac
}
get_opener() {
    local cmd
    case "$(detect_os)" in
        darwin)  cmd="open"  ;;
        linux)   cmd="xdg-open"  ;;
        windows) cmd="start"  ;;
        *)       cmd=""  ;;
    esac
    echo "$cmd"
}
open_link() {
    cmd="$(get_opener)"
    if [ "$cmd" == "" ]; then
        echo "Your platform is not supported for opening links."
        echo "Please open the following URL in your preferred browser:"
        echo " ${1}"
        return 1
    fi
    $cmd "$1"
    if [[ $? -eq 1 ]]; then
        echo "Failed to open your browser."
        echo "Please open the following URL in your browser:"
        echo "${1}"
        return 1
    fi
    return 0
}
