###############################################################################
#                                                                             #
# Bash TUI Toolkit                                                            #
# by Timo Reymann                                                             #
#                                                                             #
# version: 1.6.0                                                              #
# bundle:  platform_helpers                                                   #
# github:  https://github.com/timo-reymann/bash-tui-toolkit                   #
#                                                                             #
# --------------------------------------------------------------------------- #
#                                                                             #
# Copyright (C) 2023 Timo Reymann (mail@timo-reymann.de)                      #
#                                                                             #
# Licensed under the Apache License, Version 2.0 (the "License");             #
# you may not use this file except in compliance with the License.            #
# You may obtain a copy of the License at                                     #
#                                                                             #
#         http://www.apache.org/licenses/LICENSE-2.0                          #
#                                                                             #
# Unless required by applicable law or agreed to in writing, software         #
# distributed under the License is distributed on an "AS IS" BASIS,           #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    #
# See the License for the specific language governing permissions and         #
# limitations under the License.                                              #
#                                                                             #
###############################################################################
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
        macos)  cmd="open"; ;;
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
