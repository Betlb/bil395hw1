Programming languages lex-yacc studies

# 🧮 Advanced Calculator (Lex & Yacc)

This is a command-line **expression-based calculator** built using **Lex and Yacc**. It supports:

- Floating-point numbers
- Arithmetic operations with correct precedence
- Exponentiation (`^`)
- Variable assignment and reuse
- Error handling (e.g., division by zero)

It also includes a **test automation script** to verify correctness of the implementation.

---

## 🚀 Features

- ✅ Integer and floating-point math
- ✅ Variable declaration and usage
- ✅ Exponentiation support via `^`
- ✅ Operator precedence and parentheses
- ✅ Unary minus (e.g., `-5`, `-(3 + 2)`)
- ✅ Division-by-zero error detection
- ✅ Clean error output without showing invalid results
- ✅ Interactive and scriptable use

---

## 🧠 Design Decisions

### 📌 Lex (calculator.l)
- **Tokenizes** all valid elements: numbers, variables, operators, and parentheses.
- Ignores whitespace but returns newline (`\n`) as a token to trigger expression evaluation.
- Uses `%option noyywrap` for clean end-of-file handling.
- Sends variable names (`VARIABLE`) as strings via `yylval.sval`.

### 📌 Yacc (calculator.y)
- Defines the grammar for arithmetic expressions and assignments.
- Supports precedence for `+ -`, `* /`, and `^`, plus parentheses and unary minus.
- Stores variables in a `symbol_table` array.
- Detects and handles division by zero using `yyerror()` and an `error_flag`.
- Uses `%union` to handle both double values and strings (`sval` for variable names).

---

## 🧱 Implementation Steps

1. **Defined tokens** in Lex for all supported input types.
2. **Created grammar rules** in Yacc for expressions and assignment.
3. **Built a symbol table** using a struct array to hold variables and their values.
4. **Handled errors** using a global `error_flag` and `yyerror()` output.
5. **Ensured proper output control**: results only print when no error occurs.
6. **Created a test script** (`test.sh`) for automated validation of the calculator logic.

---

## 🗂 File Structure

| File               | Description                                       |
|--------------------|---------------------------------------------------|
| `calculator.l`     | Lex file: defines how input is tokenized          |
| `calculator.y`     | Yacc file: defines grammar and evaluation rules   |
| `test_calculator.sh`          | Bash script: automated test suite                 |
| `README.md`        | Project documentation                             |

---

## 🛠 Build & Run

### ✅ Build

Make sure you have **Flex**, **Bison**, and **GCC** installed:

```bash
sudo apt install flex bison gcc -y

Then run;
yacc -d calculator.y
lex calculator.l
gcc lex.yy.c y.tab.c -o advanced_calculator -lm

Run interactively;
./advanced_calculator

and you will see;
Advanced Calculator
Features:
- Floating-point numbers
- Exponentiation (^)
- Variable assignment
Enter expressions (e.g., 3.5 + 5, x = 10, x ^ 2




