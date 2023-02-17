#!/bin/bash
# @name Logging
# @brief Provide logging helpers for structured logging

# Log levels
LOG_ERROR=3
LOG_WARN=2
LOG_INFO=1
LOG_DEBUG=0

# @description Parse log level from text representation to level number
#
# @arg $1 string Log level to parse
# @stdout numeric log level
# @set LOG_LEVEL the global log level to use in the script
# @example
#   # Parse lower case log level
#   parse_log_level "info"
# @example
#   # Parse upper case log level
#   parse_log_level "ERROR"
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

# @description Log output on a given level, checks if $LOG_LEVEL, if not set defaults to INFO
# @arg $1 number Numeric log level
# @arg $2 string Message to output
# @stdout Formatted log message with ANSI color codes
# @example
#   # Log a message on info level
#   log "$LOG_INFO" "this is a info message"
#   log "LOG_DEBUG" "i am only visible when \$LOG_LEVEL is debug"
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
