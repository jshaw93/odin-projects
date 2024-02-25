package advent3

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:unicode/utf8"
import "core:unicode"
import "core:strings"

main :: proc() {
    // sum: i64 = 0
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines := strings.split_lines(string(file))
    defer delete(lines)
    partOne(lines)
    partTwo(lines)
}

Position :: struct {
    value: string,
    xMin: int,
    xMax: int,
    y: int,
}

Symbol :: struct {
    value: rune,
    x: int,
    y: int,
}

partOne :: proc(lines: []string) {
    sum : i64 = 0
    posArray : [dynamic]Position = {}
    symArray : [dynamic]Symbol = {}
    defer delete(posArray)
    defer delete(symArray)
    // Populate arrays
    for row, y in lines {
        num : [dynamic]rune
        defer delete(num)
        xMin : int = 0
        xMax : int = 0
        for char, x in row {
            if unicode.is_digit(char) {
                append(&num, char)
                if xMin == 0 && x > 0 {xMin = x}
                xMax = x
            }
            if !unicode.is_digit(char) && len(num) != 0 {
                pos := Position{utf8.runes_to_string(num[:]), xMin, xMax, y}
                append(&posArray, pos)
                clear(&num)
                xMin = 0
                xMax = 0
            }
            if char != '.' && !unicode.is_digit(char) {
                sym := Symbol{char, x, y}
                append(&symArray, sym)
                clear(&num)
                xMin = 0
                xMax = 0
            }
        }
        if len(num) > 0 {
            pos := Position{utf8.runes_to_string(num[:]), xMin, xMax, y}
            append(&posArray, pos)
            xMin = 0
            xMax = 0
        }
    }
    visited := map[Position]struct{}{}
    defer delete(visited)
    for sym in symArray {
        for pos in posArray {
            if (abs(pos.xMin - sym.x ) <= 1 || abs(pos.xMax - sym.x) <= 1) && pos not_in visited {
                if abs(pos.y - sym.y) > 1 do continue
                val, _ := strconv.parse_i64(pos.value)
                sum += val
                visited[pos] = {}
            }
        }
    }
    fmt.println("Part 1:", sum)
}

partTwo :: proc(lines: []string) {
    sum : i64 = 0
    posArray : [dynamic]Position = {}
    symArray : [dynamic]Symbol = {}
    defer delete(posArray)
    defer delete(symArray)
    // Populate arrays
    for row, y in lines {
        num : [dynamic]rune
        defer delete(num)
        xMin : int = 0
        xMax : int = 0
        for char, x in row {
            if unicode.is_digit(char) {
                append(&num, char)
                if xMin == 0 && x > 0 {xMin = x}
                xMax = x
            }
            if !unicode.is_digit(char) && len(num) != 0 {
                pos := Position{utf8.runes_to_string(num[:]), xMin, xMax, y}
                append(&posArray, pos)
                clear(&num)
                xMin = 0
                xMax = 0
            }
            if char != '.' && !unicode.is_digit(char) {
                sym := Symbol{char, x, y}
                append(&symArray, sym)
                clear(&num)
                xMin = 0
                xMax = 0
            }
        }
        if len(num) > 0 {
            pos := Position{utf8.runes_to_string(num[:]), xMin, xMax, y}
            append(&posArray, pos)
            xMin = 0
            xMax = 0
        }
    }
    for sym in symArray {
        ratio : i64 = 0
        hits : i16 = 0
        if sym.value != '*' do continue
        for pos in posArray {
            if (abs(pos.xMin - sym.x ) <= 1 || abs(pos.xMax - sym.x) <= 1) {
                if abs(pos.y - sym.y) > 1 do continue
                val, _ := strconv.parse_i64(pos.value)
                if ratio == 0 && hits == 0 {
                    ratio = val
                    hits += 1
                } else if hits == 1 {
                    ratio *= val
                    hits += 1
                }
            }
        }
        if hits == 2 {
            sum += ratio
        }
    }
    fmt.println("Part 2:", sum)
}
