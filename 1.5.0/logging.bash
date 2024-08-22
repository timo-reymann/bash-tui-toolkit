###############################################################################
#                                                                             #
# Bash TUI Toolkit                                                            #
# by Timo Reymann                                                             #
#                                                                             #
# version: 1.5.0                                                              #
# bundle:  logging                                                            #
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
LOG_ERROR=3
LOG_WARN=2
LOG_INFO=1
LOG_DEBUG=0
parse_log_level() {
  local level="$1"
  local parsed
  case "${level}" in
      info | INFO)   parsed=$LOG_INFO; ;;
      debug | DEBUG) parsed=$LOG_DEBUG; ;;
      warn | WARN)   parsed=$LOG_WARN; ;;
      error | ERROR) parsed=$LOG_ERROR; ;;
      *)             parsed=-1; ;;
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
        color='\033[1;36m'
        ;;
      "$LOG_DEBUG")
        level="DEBUG"
        color='\033[1;34m'
        ;;
      "$LOG_WARN")
        level="WARN"
        color='\033[0;33m'
        ;;
      "$LOG_ERROR")
        level="ERROR"
        color='\033[0;31m'
        ;;
  esac
  echo -e "[${color}$(printf '%-5s' "${level}")\033[0m] \033[1;35m$(date +'%Y-%m-%dT%H:%M:%S')\033[0m ${message}"
}
