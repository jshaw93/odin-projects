package calculator

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:unicode/utf8"

main :: proc() {
    buffer: [256]byte
    fmt.println("Enter a number:")
    n, err := os.read(os.stdin, buffer[:])
    if err < 0 {
        return
    }
    digits := string(buffer[:n])
    num1, ok := strconv.parse_f32(digits)
    fmt.println("Enter an operator:")
    n, err = os.read(os.stdin, buffer[:])
    if err < 0 {
        return
    }
    operator := utf8.string_to_runes(string(buffer[:n]))[0]
    fmt.println("Enter a second number:")
    n, err = os.read(os.stdin, buffer[:])
    if err < 0 {
        return 
    }
    digits = string(buffer[:n])
    num2, ok2 := strconv.parse_f32(digits)
    ans: f32
    switch {
    case operator == '+':
        ans = num1 + num2
    case operator == '-':
        ans = num1 - num2
    case operator == '*':
        ans = num1 * num2
    case operator == '/':
        ans = num1 / num2
    }
    fmt.println(num1, operator, num2, '=', ans)
}
