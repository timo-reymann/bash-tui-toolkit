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
get_opener() {
    local cmd
    case "$(detect_os)" in
        darwin)  cmd="open"; ;;
        linux)   cmd="xdg-open"; ;;
        windows) cmd="start"; ;;
        *)       cmd=""; ;;
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
