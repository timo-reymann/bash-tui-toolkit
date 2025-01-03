# Platform-Helpers

Platform specific helpers

## Overview

Detect the OS the script is running on

## Index

* [detect_os](#detect_os)
* [get_opener](#get_opener)
* [open_link](#open_link)

### detect_os

Detect the OS the script is running on

#### Output on stdout

* solaris | macos | linux | bsd | windows | unknown

### get_opener

Get opener command for platform

#### Output on stdout

* Command that can be used, if it is not supported returns an empty string

### open_link

Open a link using the default opener, if it is not possible/supported or an error occurs simply prints the url with instructions

#### Arguments

* **$1** (Link): to open

#### Exit codes

* **1**: Failed to open link
* **0**: Opened link using util

#### Output on stdout

* Instructions in case link can not be opened

