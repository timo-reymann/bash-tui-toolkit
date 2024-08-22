LOG_ERROR=3
LOG_WARN=2
LOG_INFO=1
LOG_DEBUG=0
parse_log_level() {
  local level="$1"
  case "${level}" in
      info | INFO)   echo $LOG_INFO; ;;
      debug | DEBUG) echo $LOG_DEBUG; ;;
      warn | WARN)   echo $LOG_WARN; ;;
      error | ERROR) echo $LOG_ERROR; ;;
      *)             echo -1; ;;
  esac
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
