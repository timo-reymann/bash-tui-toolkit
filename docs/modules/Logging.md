# Logging

Provide logging helpers for structured logging

## Overview

Parse log level from text representation to level number

## Index

* [parse_log_level](#parse_log_level)
* [log](#log)

### parse_log_level

Parse log level from text representation to level number

#### Arguments

* **$1** (string): Log level to parse

#### Output on stdout

* numeric log level

### log

Log output on a given level, checks if $LOG_LEVEL, if not set defaults to INFO

#### Arguments

* **$1** (number): Numeric log level
* **$2** (string): Message to output

#### Output on stdout

* Formatted log message with ANSI color codes

