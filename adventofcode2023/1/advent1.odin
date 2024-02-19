package advent1

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"

main :: proc() {
    sum: i64 = 0
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines := strings.split(string(file), "\n")
    for line in lines {
        sum += parseLine(line)
    }
    fmt.println("Calibration complete!\nFinal calibration value:", sum)
}

parseLine :: proc(line: string) -> i64 {
    numbers: [2]rune
    first: rune
    last: rune
    for char in line {
        if checkIfDigit(char) {
            if first == 0 {
                first = char
            }
            last = char
        }
    }
    numbers[0] = first
    numbers[1] = last
    number, _ := strconv.parse_i64(utf8.runes_to_string(numbers[:]))
    return number
}

VALIDRUNES := []rune {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}
checkIfDigit :: proc(digit: rune) -> bool {
    for char in VALIDRUNES {
        if digit == char {return true}
    }
    return false
}
