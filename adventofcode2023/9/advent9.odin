package advent9

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:math"

main :: proc() {
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines, _ := strings.split(string(file), "\r\n")
    defer delete(file)
    data : [dynamic][dynamic]int
    defer delete(data)
    for i in data do defer delete(i)
    for line, index in lines {
        newLineStr, _ := strings.split(line, " ")
        newLine : [dynamic]int
        for i in newLineStr {
            num, _ := strconv.parse_int(i)
            append(&newLine, num)
        }
        append(&data, newLine)
    }

    // Part 1
    res1 : int = 0
    for line in data {
        res1 += getNextValue(line[:])
    }
    fmt.println("Part 1:", res1)

    // Part 2
    res2 : int = 0
    for line in data {
        res2 += getPrevValue(line[:])
    }
    fmt.println("Part 2:", res2)
}

getNextValue :: proc(row: []int) -> int {
    checkBool : bool = true
    for i in row {
        if i != 0 do checkBool = false
    }
    if checkBool do return 0
    diff : [dynamic]int
    for i in 0..<len(row) - 1 {
        append(&diff, row[i + 1] - row[i])
    }
    return row[len(row) - 1] + getNextValue(diff[:])
}

getPrevValue :: proc(row: []int) -> int {
    checkBool : bool = true
    for i in row {
        if i != 0 do checkBool = false
    }
    if checkBool do return 0
    diff : [dynamic]int
    for i in 0..<len(row) - 1 {
        append(&diff, row[i+1] - row[i])
    }
    return row[0] - getPrevValue(diff[:])
}
