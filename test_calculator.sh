#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to run test and check output
run_test() {
    local input="$1"
    local expected="$2"
    local description="$3"

    echo -e "\n\n--- Test: $description ---"
    echo "Input: $input"
    
    # Run the calculator with the input (add newline)
    result=$(echo -e "$input" | ./advanced_calculator 2>&1)
    
    # Check if the result matches expected
    if [[ "$result" == *"$expected"* ]]; then
        echo -e "${GREEN}PASS${NC}: $result"
    else
        echo -e "${RED}FAIL${NC}: Expected to contain '$expected', Got '$result'"
    fi
}

# Ensure the calculator is compiled
if [ ! -f advanced_calculator ]; then
    echo "Compiling calculator..."
    yacc -d calculator.y
    lex calculator.l
    gcc lex.yy.c y.tab.c -o advanced_calculator -lm
fi

# Test Simple Arithmetic Expressions
run_test "3 + 5" "Result: 8" "Simple Addition"
run_test "10 * 4" "Result: 40" "Simple Multiplication"
run_test "15 - 7" "Result: 8" "Simple Subtraction"
run_test "20 / 5" "Result: 4" "Simple Division"

# Test Expressions with Parentheses
run_test "(1 + 2) * 4" "Result: 12" "Parentheses Multiplication"
run_test "((3 + 2) * 2) / 2" "Result: 5" "Nested Parentheses"

# Test More Complex Expressions
run_test "(3 + 5) * (2 - 1) / 4" "Result: 2" "Complex Expression"
run_test "2 ^ 3 + 1" "Result: 9" "Exponentiation with Addition"

# Test Floating Point Numbers
run_test "3.5 + 2.5" "Result: 6" "Floating Point Addition"
run_test "10.0 / 3.0" "Result: 3.33" "Floating Point Division"

# Test Variable Assignment and Usage
run_test "x = 10\nx + 5" "Result: 15" "Variable Assignment and Usage"

# Test Division by Zero Error Handling
run_test "10 / 0" "Error: Division by zero" "Division by Zero Error"

# Test Negative Numbers
run_test "-5 + 3" "Result: -2" "Negative Number Addition"
run_test "-(4 + 2)" "Result: -6" "Negation with Parentheses"

# Test Exponentiation
run_test "2 ^ 3" "Result: 8" "Simple Exponentiation"
run_test "4 ^ 0.5" "Result: 2" "Square Root via Exponentiation"

echo -e "\n${GREEN}All tests completed!${NC}"