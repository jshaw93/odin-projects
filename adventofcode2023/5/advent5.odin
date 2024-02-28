package advent5

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:math"

Instruction :: struct {
    destRangeStart: int,
    srcRangeStart: int,
    rangeLen: int,
}

Range :: struct {
    start: int,
    end: int,
}

main :: proc() {
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines, _ := strings.split(string(file), "\r\n\r\n")
    defer delete(file)
    seedPreFmt := strings.split(lines[0], " ")[1:]
    seeds : [dynamic]int
    defer delete(seeds)
    for i, index in seedPreFmt {
        seed, _ := strconv.parse_int(i)
        append(&seeds, seed)
    }
    fmt.println("Lowest location # pt 1:", part1(seeds, lines))

    // Part 2
    ranges : [dynamic]Range
    for i := 0; i < len(seeds); i += 2 {
        append(&ranges, Range{seeds[i], seeds[i] + seeds[i+ 1]})
    }
    fmt.println("Lowest location # pt 2:", part2(ranges, lines))
}

part1 :: proc(seeds: [dynamic]int, lines: []string) -> int {
    seeds := seeds
    for block in lines[1:] {
        instructions : [dynamic]Instruction
        defer delete(instructions)
        for line in strings.split_lines(block)[1:] {
            lineFmt := [3]int{}
            linePreFmt, _ := strings.split(line, " ")
            for i, index2 in linePreFmt {
                f, _ := strconv.parse_int(i)
                lineFmt[index2] = f
            }
            instruction := Instruction{lineFmt[0], lineFmt[1], lineFmt[2]}
            append(&instructions, instruction)
        }
        newPt1 : [dynamic]int
        for seed in seeds {
            loopBool : bool = false
            for instruction in instructions {
                if instruction.srcRangeStart <= seed && seed < instruction.srcRangeStart + instruction.rangeLen {
                    append(&newPt1, seed - instruction.srcRangeStart + instruction.destRangeStart)
                    loopBool = true
                    break
                }
            }
            if !loopBool {
                append(&newPt1, seed)
            }
        }
        seeds = newPt1
    }
    lowest : int = 0x7fffffffffffffff
    for seed in seeds {
        lowest = math.min(lowest, seed)
    }
    return lowest
}

part2 :: proc(ranges: [dynamic]Range, lines: []string) -> int {
    ranges := ranges
    for block in lines[1:] {
        instructions : [dynamic]Instruction
        defer delete(instructions)
        for line in strings.split_lines(block)[1:] {
            lineFmt := [3]int{}
            linePreFmt, _ := strings.split(line, " ")
            for i, index2 in linePreFmt {
                f, _ := strconv.parse_int(i)
                lineFmt[index2] = f
            }
            instruction := Instruction{lineFmt[0], lineFmt[1], lineFmt[2]}
            append(&instructions, instruction)
        }
        newPt2 : [dynamic]Range
        for len(ranges) > 0 {
            range := pop(&ranges)
            s := range.start
            e := range.end
            loopBool : bool = false
            for instruction in instructions {
                overlapStart := math.max(s, instruction.srcRangeStart)
                overlapEnd := math.min(e, instruction.srcRangeStart + instruction.rangeLen)
                if overlapStart < overlapEnd {
                    loopBool = true
                    append(&newPt2, Range{
                        overlapStart - instruction.srcRangeStart + instruction.destRangeStart,
                        overlapEnd - instruction.srcRangeStart + instruction.destRangeStart,
                    })
                    if overlapStart > s {
                        append(&ranges, Range{s, overlapStart})
                    }
                    if e > overlapEnd {
                        append(&ranges, Range{overlapEnd, e})
                    }
                    break
                }
            }
            if !loopBool do append(&newPt2, Range{s, e})
        }
        ranges = newPt2
    }
    lowest : int = 0x7fffffffffffffff
    for range in ranges {
        lowest = math.min(lowest, range.start)
    }
    return lowest
}
