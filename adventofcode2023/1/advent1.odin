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
    // fmt.println(parseLine("75447"))
}

VALIDNUMBERS := [?]string {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
NUMBERCONVERSION := map[string]rune {
    "0" = '0', 
    "1" = '1', 
    "2" = '2', 
    "3" = '3', 
    "4" = '4', 
    "5" = '5', 
    "6" = '6', 
    "7" = '7', 
    "8" = '8', 
    "9" = '9',
    "one" = '1',
    "two" = '2',
    "three" = '3',
    "four" = '4',
    "five" = '5',
    "six" = '6',
    "seven" = '7',
    "eight" = '8',
    "nine" = '9',
}

parseLine :: proc(line: string) -> i64 {
    numbers: [2]rune
    first: rune
    firstIndex: int
    last: rune
    lastIndex: int
    for substring, index in VALIDNUMBERS {
        stringIndex := strings.index(line, substring)
        stringLastIndex := strings.last_index(line, substring)
        if stringIndex >= 0 && first == 0 { // 75[4]47
            first = NUMBERCONVERSION[substring]
            firstIndex = stringIndex
        } else if stringIndex >= 0 && stringIndex < firstIndex { // [7]5447
            first = NUMBERCONVERSION[substring]
            firstIndex = stringIndex
        }
        if stringIndex >= 0  && last == 0 { // 75[4]47
            last = NUMBERCONVERSION[substring]
            lastIndex = stringIndex
        } else if stringIndex >= 0 && stringIndex > lastIndex { // 75[4]47
            // repeating values makes algorithm break here
            last = NUMBERCONVERSION[substring]
            lastIndex = stringIndex
        }
        if stringLastIndex >= 0 && stringLastIndex > lastIndex { // 7544[7]
            // fix for repeated values
            last = NUMBERCONVERSION[substring]
            lastIndex = stringLastIndex
        }
    }
    numbers[0] = first
    numbers[1] = last
    number, _ := strconv.parse_i64(utf8.runes_to_string(numbers[:]))
    return number
}


