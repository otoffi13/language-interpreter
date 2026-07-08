# Language Interpreter

A simple interpreter for a custom programming language implemented in C using Flex and Bison.

The project was developed as an academic assignment and demonstrates the basic stages of language processing: lexical analysis, syntax parsing and interpretation of simple instructions.

## Project overview

The interpreter supports a small custom language with Polish keywords and a prefix-style expression syntax.

The project includes:

- lexical analysis using Flex,
- syntax parsing using Bison,
- variable assignment,
- user input,
- printing values,
- arithmetic operations,
- comparison operations,
- logical operations,
- single-line and multi-line comments.

## Supported language features

### Variables

Variables can be assigned using the `<-` operator:

```text
x <- +(2, 3)
```

### Input

The `pobierz` instruction reads a value from the user:

```text
pobierz(x)
```

### Output

The `wyswietl` instruction prints a value or expression result:

```text
wyswietl(x)
wyswietl(+(x, 1))
```

### Arithmetic operations

The language supports arithmetic operations written in prefix notation:

```text
+(a, b)
-(a, b)
*(a, b)
/(a, b)
```

### Comparison operations

```text
==(a, b)
!=(a, b)
<(a, b)
<=(a, b)
>(a, b)
>=(a, b)
```

### Logical operations

```text
&&(a, b)
||(a, b)
~(a)
```

### Comments

Single-line comments:

```text
-- this is a comment
```

Multi-line comments:

```text
```
this is a multi-line comment
```
```

## Example program

```text
-- Example program

pobierz(x)

wyswietl(+(x, 1))
wyswietl(x)

x <- +(x, 1)

wyswietl(x)
wyswietl(&&(x, 0))
wyswietl(&&(x, 1))

pobierz(y)

wyswietl(-(x, y))
wyswietl(+(x, +(y, 4)))
```

## Repository structure

```text
language-interpreter/
│
├── lexer.l          # Flex lexer definition
├── parser.y         # Bison parser and interpreter logic
├── main.c           # Program entry point
├── Makefile         # Build and run commands
├── input.txt        # Example input program
├── Instrukcja.docx  # Original project instruction/documentation
└── README.md        # Project description
```

## Technologies

- C
- Flex
- Bison
- Makefile
- Lexical analysis
- Syntax analysis
- Interpreter design

## Requirements

To build and run the project, you need:

- GCC
- Flex
- Bison
- Make

On Linux or WSL, these tools can usually be installed with:

```bash
sudo apt update
sudo apt install gcc flex bison make
```

On Windows, the recommended option is to use WSL, MSYS2 or another environment that provides GCC, Flex, Bison and Make.

## How to run

Clone the repository:

```bash
git clone https://github.com/otoffi13/language-interpreter.git
cd language-interpreter
```

Build and run the interpreter:

```bash
make
```

The included `Makefile` generates the lexer and parser, compiles the interpreter and runs it using the example program from `input.txt`.

You can also run the interpreter manually after compilation:

```bash
./interpreter < input.txt
```

## Example workflow

```text
Source code in input.txt
        ↓
Lexer: lexer.l
        ↓
Parser: parser.y
        ↓
Interpreter execution
        ↓
Program output
```

## What I learned

During this project, I practised:

- designing a simple programming language syntax,
- implementing lexical analysis with Flex,
- implementing grammar rules with Bison,
- working with tokens and grammar productions,
- managing variables in an interpreter,
- compiling generated C code,
- using Makefile-based builds.

## Author

Oliwia Groszek  
MSc in Computer Science
