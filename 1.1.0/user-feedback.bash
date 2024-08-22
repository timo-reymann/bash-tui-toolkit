show_error() {
    echo -e "\e[91;1m\u2718 $1" >&2
}
show_success() {
    echo -e "\e[92;1m\u2714 $1" >&2
}
