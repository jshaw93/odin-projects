package advent11

import "core:fmt"
import "core:strings"
import "core:os"
import "core:unicode/utf8"
import "core:math"

Galaxy :: struct {
    y: int,
    x: int,
}

main :: proc() {
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines, _ := strings.split(string(file), "\r\n")
    defer delete(file)
    emptyRows : [dynamic]int
    emptyCols : [dynamic]int
    defer delete(emptyRows)
    defer delete(emptyCols)
    for row, y in lines {
        galaxyFound : bool = false
        for char in row {
            if char != '.' {
                galaxyFound = true
                break
            }
        }
        if !galaxyFound do append(&emptyRows, y)
    }
    for x in 0..<len(lines[0]) {
        galaxyFoundCol : bool = false
        for y in 0..<len(lines) {
            if lines[y][x] != '.' {
                galaxyFoundCol = true
                break
            }
        }
        if !galaxyFoundCol do append(&emptyCols, x)
    }
    galaxies : [dynamic]Galaxy
    defer delete(galaxies)
    for row, y in lines {
        for col, x in row {
            if col == '#' do append(&galaxies, Galaxy{y, x})
        }
    }
    // Part 1
    scale : int = 2
    totalPart1 := solve(galaxies[:], emptyRows[:], emptyCols[:], scale)
    fmt.println("Part 1:", totalPart1)
    
    // Part 2
    scale = 1000000
    totalPart2 := solve(galaxies[:], emptyRows[:], emptyCols[:], scale)
    fmt.println("Part 2:", totalPart2)
}

arrayHasElement :: proc(array: []int, element: int) -> bool {
    for i in array {
        if i == element do return true
    }
    return false
}

solve :: proc(galaxies: []Galaxy, emptyRows: []int, emptyCols: []int, scale: int) -> int {
    total : int = 0
    for galaxy, i in galaxies {
        y1 := galaxy.y
        x1 := galaxy.x
        for nextGalaxy in galaxies[:i] {
            y2 := nextGalaxy.y
            x2 := nextGalaxy.x
            for r in math.min(y1, y2)..<math.max(y1, y2) {
                if arrayHasElement(emptyRows, r) do total += scale
                else do total += 1
            }
            for c in math.min(x1, x2)..<math.max(x1, x2) {
                if arrayHasElement(emptyCols, c) do total += scale
                else do total += 1
            }
        }
    }
    return total
}
