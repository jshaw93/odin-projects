package advent10

import "core:fmt"
import "core:strings"
import "core:os"
import "core:unicode/utf8"

Pos :: struct {
    x: int,
    y: int,
}

main :: proc() {
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines, _ := strings.split(string(file), "\r\n")
    defer delete(file)
    startY : int
    startX : int
    breakBool : bool = false
    for row, y in lines {
        if breakBool do break
        for col, x in row {
                if col == 'S' {
                startY = y
                startX = x
                breakBool = true
                break
            }
        }
    }
    start := Pos{startX, startY}
    seen : [dynamic]Pos
    defer delete(seen)
    queue : [dynamic]Pos
    defer delete(queue)
    possibleS : []rune = {'|', '-', 'J', 'L', '7', 'F'}
    append(&seen, start)
    append(&queue, start)
    for len(queue) > 0 {
        pos := queue[0]
        ordered_remove(&queue, 0)
        col := pos.x
        row := pos.y
        char := lines[row][col]
        // up
        if row > 0 && charInString(rune(char), "S|JL") && charInString(rune(lines[row-1][col]), "|7F") && !posInArray(seen[:], Pos{col, row-1}) {
            append(&seen, Pos{col, row-1})
            append(&queue, Pos{col, row-1})
            if char == 'S' {
                possibleS = intersect(possibleS, {'|', 'J', 'L'})
            }
        }
        // down
        if row < len(lines) - 1 && charInString(rune(char), "S|7F") && charInString(rune(lines[row+1][col]), "|JL") && !posInArray(seen[:], Pos{col, row+1}) {
            append(&seen, Pos{col, row+1})
            append(&queue, Pos{col, row+1})
            if char == 'S' {
                possibleS = intersect(possibleS, {'|', '7', 'F'})
            }
        }
        // left
        if col > 0 && charInString(rune(char), "S-J7") && charInString(rune(lines[row][col-1]), "-LF") && !posInArray(seen[:], Pos{col-1, row}) {
            append(&seen, Pos{col-1, row})
            append(&queue, Pos{col-1, row})
            if char == 'S' {
                possibleS = intersect(possibleS, {'-', 'J', '7'})
            }
        }
        // right
        if col < len(lines[row]) - 1 && charInString(rune(char), "S-LF") && charInString(rune(lines[row][col+1]), "-J7") && !posInArray(seen[:], Pos{col+1, row}) {
            append(&seen, Pos{col+1, row})
            append(&queue, Pos{col+1, row})
            if char == 'S' {
                possibleS = intersect(possibleS, {'-', 'F', 'L'})
            }
        }
    }
    fmt.println("Part 1:", len(seen)/2)
    
    // Part 2
    // Replace 'S' with proper pipe type
    replace : [dynamic]rune
    defer delete(replace)
    for row, i in lines {
        if strings.index_rune(row, 'S') >= 0 {
            for char in row {
                if char == 'S' {
                    newChar := possibleS[0]
                    append(&replace, newChar)
                    continue
                }
                append(&replace, char)
            }
            lines[i] = utf8.runes_to_string(replace[:])
        }
    }
    clear(&replace)
    // Replace garbage pipes not in loop with '.'
    for row, r in lines {
        for char, c in row {
            if !posInArray(seen[:], Pos{c, r}) {
                newChar := '.'
                append(&replace, newChar)
                continue
            }
            append(&replace, char)
        }
        lines[r] = utf8.runes_to_string(replace[:])
        clear(&replace)
    }
    outside : [dynamic]Pos
    defer delete(outside)
    for row, i in lines {
        within : bool = false
        up : int = -1
        for char, j in row {
            if char == '|' {
                within = !within
            } else if char == '-' {
            } else if charInString(char, "LF") {
                if char == 'L' do up = 1
                else do up = 0
            } else if charInString(char, "7J") {
                if up == 1 {
                    if char != 'J' do within = !within
                } else {
                    if char != '7' do within = !within
                }
                up = -1
            } else if char == '.' {}
            else {
                strBuild := "Runtime error: unexpected character (horizontal): %v"
                strings.replace(strBuild, "%v", utf8.runes_to_string([]rune {char}), -1)
                fmt.println(char)
                panic(strBuild)
                
            }
            if !within do append(&outside, Pos{j, i})
        }
    }
    // // Print representation of outside characters
    // for r in 0..<len(lines) {
    //     for c in 0..<len(lines[r]) {
    //         if posInArray(exclude(outside[:], seen[:]), Pos{c, r}) do fmt.print("#")
    //         else do fmt.print(".")
    //     }
    //     fmt.print("\n")
    // }
    fmt.println("Part 2:", len(lines) * len(lines[0]) - len(setUnion(outside[:], seen[:])))
}

charInString :: proc(char: rune, str: string) -> bool {
    for i in str {
        if i == char do return true
    }
    return false
}

posInArray :: proc(seen: []Pos, pos: Pos) -> bool {
    for i in seen {
        if i == pos do return true
    }
    return false
}

intersect :: proc(first: []rune, second: []rune) -> []rune {
    res : [dynamic]rune
    for i in first {
        for j in second {
            if i == j do append(&res, i)
        }
    }
    return res[:]
}

exclude :: proc(first: []Pos, second: []Pos) -> []Pos {
    res : [dynamic]Pos
    for i in first {
        checkBool : bool = false
        for j in second {
            if i == j do checkBool = true
        }
        if !checkBool do append(&res, i)
    }
    return res[:]
}

setUnion :: proc(first: []Pos, second: []Pos) -> []Pos {
    res : [dynamic]Pos
    for i in first {
        if !posInArray(res[:], i) do append(&res, i)
    }
    for i in second {
        if !posInArray(res[:], i) do append(&res, i)
    }
    return res[:]
}
