# User-Feedback

Provides useful colored outputs for user feedback on actions

## Overview

Display error message in stderr, prefixed by check emoji

## Index

* [show_error](#show_error)
* [show_success](#show_success)

### show_error

Display error message in stderr, prefixed by check emoji

#### Example

```bash
show_error "Oh snap, that went horribly wrong"
```

#### Arguments

* **$1** (string): Error message to display

### show_success

Display success message in stderr, prefixed by cross emoji

#### Example

```bash
show_success "There it is! World peace."
```

#### Arguments

* **$1** (string): Success message to display

