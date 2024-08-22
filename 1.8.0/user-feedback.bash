###############################################################################
#                                                                             #
# Bash TUI Toolkit                                                            #
# by Timo Reymann                                                             #
#                                                                             #
# version: 1.8.0                                                              #
# bundle:  user_feedback                                                      #
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
show_error() {
    echo -e "\033[91;1m✘ $1\033[0m" >&2
}
show_success() {
    echo -e "\033[92;1m✔ $1\033[0m" >&2
}
