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
* [range](#range)
* [validate_present](#validate_present)

### input

Prompt for text

#### Example

```bash
# Raw input without validation
text=$(input "Please enter something and confirm with enter")
# Input with validation
text=$(with_validate 'input "Please enter at least one character and confirm with enter"' validate_present)
```

#### Arguments

* **$1** (string): Phrase for prompting to text

#### Output on stdout

* Text as provided by user

### confirm

Show confirm dialog for yes/no

#### Example

```bash
confirmed=$(confirm "Should it be?")
if [ "$confirmed" = "0" ]; then echo "No?"; else echo "Yes!"; fi
```

#### Arguments

* **$1** (string): Phrase for promptint to text

#### Output on stdout

* 0 for no, 1 for yes

### list

Renders a text based list of options that can be selected by the
user using up, down and enter keys and returns the chosen option.
Inspired by https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu/415155#415155

#### Example

```bash
options=("one" "two" "three" "four")
option=$(list "Select one item" "${options[@]}")
echo "Your choice: ${options[$option]}"
```

#### Arguments

* **$1** (string): Phrase for promptint to text
* **$2** (array): List of options (max 256)

#### Output on stdout

* selected index (0 for opt1, 1 for opt2 ...)

### checkbox

Render a text based list of options, where multiple can be selected by the
user using up, down and enter keys and returns the chosen option.
Inspired by https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu/415155#415155

#### Example

```bash
options=("one" "two" "three" "four")
checked=$(checkbox "Select one or more items" "${options[@]}")
echo "Your choices: ${checked}"
```

#### Arguments

* **$1** (string): Phrase for promptint to text
* **$2** (array): List of options (max 256)

#### Output on stdout

* selected index (0 for opt1, 1 for opt2 ...)

### password

Show password prompt displaying stars for each password character letter typed
it also allows deleting input

#### Example

```bash
# Password prompt with custom validation
validate_password() { if [ ${#1} -lt 10 ];then echo "Password needs to be at least 10 characters"; exit 1; fi }
pass=$(with_validate 'password "Enter random password"' validate_password)
# Password ith no validation
pass=$(password "Enter password to use")
```

#### Arguments

* **$1** (string): Phrase for prompting to text

#### Output on stdout

* password as written by user

### editor

Open default editor ($EDITOR) if none is set falls back to vi

#### Example

```bash
# Open default editor
text=$(editor "Please enter something in the editor")
echo -e "You wrote:\n${text}"
```

#### Arguments

* **$1** (string): Phrase for promptint to text

#### Output on stdout

* Text as input by user in input

### with_validate

Evaluate prompt command with validation, this prompts the user for input till the validation function
returns with 0

#### Example

```bash
# Using builtin is present validator
text=$(with_validate 'input "Please enter something and confirm with enter"' validate_present)
# Using custom validator e.g. for password
validate_password() { if [ ${#1} -lt 10 ];then echo "Password needs to be at least 10 characters"; exit 1; fi }
pass=$(with_validate 'password "Enter random password"' validate_password)
```

#### Arguments

* **$1** (string): Prompt command to evaluate until validation is successful
* **$2** (function): validation callback (this is called once for exit code and once for status code)

#### Output on stdout

* Value collected by evaluating prompt

### range

Display a range dialog that can incremented and decremented using the arrow keys

#### Example

```bash
# Range with negative min value
value=$(range -5 0 5)
```

#### Arguments

* **$1** (string): Phrase for prompting to text
* **$2** (int): Minimum selectable value
* **$3** (int): Default selected value
* **$4** (int): Maximum value of the select

#### Output on stdout

* Selected value using arrow keys

### validate_present

Validate a prompt returned any value

#### Example

```bash
# text input with validation
text=$(with_validate 'input "Please enter something and confirm with enter"' validate_present)
```

#### Arguments

* **$1** (value): to validate

#### Exit codes

* **0**: String is at least 1 character long
* **1**: There was no input given

#### Output on stdout

* error message for user

