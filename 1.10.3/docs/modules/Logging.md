# Logging

Provide logging helpers for structured logging

## Overview

Parse log level from text representation to level number

## Index

* [parse_log_level](#parse_log_level)
* [log](#log)

### parse_log_level

Parse log level from text representation to level number

#### Example

```bash
# Parse lower case log level
parse_log_level "info"
# Parse upper case log level
parse_log_level "ERROR"
```

#### Arguments

* **$1** (string): Log level to parse

#### Variables set

* **LOG_LEVEL** (the): global log level to use in the script

#### Output on stdout

* numeric log level

### log

Log output on a given level, checks if $LOG_LEVEL, if not set defaults to INFO

#### Example

```bash
# Log a message on info level
log "$LOG_INFO" "this is a info message"
log "LOG_DEBUG" "i am only visible when \$LOG_LEVEL is debug"
```

#### Arguments

* **$1** (number): Numeric log level
* **$2** (string): Message to output

#### Output on stdout

* Formatted log message with ANSI color codes

