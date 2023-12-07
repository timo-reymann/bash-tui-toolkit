#!/bin/bash
# @name Platform-Helpers
# @brief Platform specific helpers

# @description Detect the OS the script is running on
# @stdout solaris | macos | linux | bsd | windows | unknown
detect_os() {
    case "$OSTYPE" in
        solaris*) echo "solaris"; ;;
        darwin*)  echo "macos"; ;;
        linux*)   echo "linux"; ;;
        bsd*)     echo "bsd"; ;;
        msys*)    echo "windows"; ;;
        cygwin*)  echo "windows"; ;;
        *)        echo "unknown"; ;;
    esac
}

# @description Get opener command for platform
# @stdout Command that can be used, if it is not supported returns an empty string
get_opener() {
    local cmd
    case "$(detect_os)" in
        macos)  cmd="open"; ;;
        linux)   cmd="xdg-open"; ;;
        windows) cmd="start"; ;;
        *)       cmd=""; ;;
    esac
    echo "$cmd"
}

# @description Open a link using the default opener, if it is not possible/supported or an error occurs simply prints the url with instructions
# @arg $1 Link to open
# @exitcode 1 Failed to open link
# @exitcode 0 Opened link using util
# @stdout Instructions in case link can not be opened
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

