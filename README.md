# LJParse
A JSON parser written in Common Lisp — parses JSON into native Lisp data structures without external dependencies.

## Lisp-JSON-Parser

A minimalist JSON parser written in **Common Lisp**, designed to convert JSON strings into native Lisp structures like alists and lists. No external libraries required — just pure Lisp.

---

## Features

- Parses:
  - JSON Objects → alists: `{"key": "val"} => (("key" . "val"))`
  - Arrays → lists: `[1, 2] => (1 2)`
  - Strings, Numbers, Booleans, and `null`
- Written in pure Common Lisp
- Lightweight and easy to integrate into other projects

---

## Example

```lisp
CL-USER> (parse-json "{\"name\": \"Alice\", \"age\": 30, \"skills\": [\"Lisp\", \"Rust\"]}")
(("name" . "Alice") ("age" . 30) ("skills" "Lisp" "Rust"))

```
## Usage

### Clone the repo
`git clone https://github.com/your-username/lisp-json-parser.gi`
`cd lisp-json-parser`

### Load in REPL
`(load "parser.lisp")`

### Parse JSON
`(parse-json "{\"key\": \"value\", \"items\": [1, 2, 3]}")`

## How It Works
The parser is built with recursive descent parsing, manually walking through the JSON input and converting it to Lisp data.
- `parse-value`: dispatches to specific parsers based on the first character
- `parse-object`, `parse-array`: handle nested structures
- `parse-string`, `parse-number`: handle primitives
