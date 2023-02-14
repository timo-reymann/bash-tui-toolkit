# Prompts

Inquirer.js inspired prompts

## Overview

Prompt for text

## Index

* [input](#input)
* [confirm](#confirm)
* [list](#list)
* [checkbox](#checkbox)
* [password](#password)
* [editor](#editor)
* [with_validate](#with_validate)
* [validate_present](#validate_present)

### input

Prompt for text

#### Arguments

* **$1** (string): Phrase for promptint to text

#### Output on stdout

* Text as provided by user

### confirm

Show confirm dialog for yes/no

#### Arguments

* **$1** (string): Phrase for promptint to text

#### Output on stdout

* 0 for no, 1 for yes

### list

Renders a text based list of options that can be selected by the
user using up, down and enter keys and returns the chosen option.
Inspired by https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu/415155#415155

#### Arguments

* **$1** (string): Phrase for promptint to text
* **$2** (array): List of options (max 256)

#### Output on stdout

* selected index (0 for opt1, 1 for opt2 ...)

### checkbox

Render a text based list of options, where multiple can be selected by the
user using up, down and enter keys and returns the chosen option.
Inspired by https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu/415155#415155

#### Arguments

* **$1** (string): Phrase for promptint to text
* **$2** (array): List of options (max 256)

#### Output on stdout

* selected index (0 for opt1, 1 for opt2 ...)

### password

Show password prompt displaying stars for each password character letter typed
it also allows deleting input

#### Arguments

* **$1** (string): Phrase for promptint to text

#### Output on stdout

* password as written by user

### editor

Open default editor

#### Arguments

* **$1** (string): Phrase for promptint to text

#### Output on stdout

* Text as input by user in input

### with_validate

Evaluate prompt command with validation, this prompts the user for input till the validation function
returns with 0

#### Arguments

* **$1** (string): Prompt command to evaluate until validation is successful
* #2 function validation callback (this is called once for exit code and once for status code)

#### Output on stdout

* Value collected by evaluating prompt

### validate_present

Validate a prompt returned any value

#### Arguments

* **$1** (value): to validate

#### Output on stdout

* error message for user

