package advent12

import "core:fmt"
import "core:strings"
import "core:os"
import "core:math"
import "core:strconv"
import "core:unicode/utf8"

Instruction :: struct {
    cfg: string,
    nums: []int,
}

main :: proc() {
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines, _ := strings.split(string(file), "\r\n")
    defer delete(file)
    total : int = 0
    total2 : int = 0
    for line in lines {
        cfg := strings.split(line, " ")[0]
        numStr := strings.split(line, " ")[1]
        numSplit, _ := strings.split(numStr, ",")
        numArr : [dynamic]int
        for i in numSplit {
            parsed, _ := strconv.parse_int(i)
            append(&numArr, parsed)
        }
        total += count(Instruction{cfg, numArr[:]})
        total2 += count(part2ParseCfg(cfg, numArr[:]))
    }
    fmt.println("Part 1:", total)
    fmt.println("Part 2:", total2)
}

count :: proc(instruction: Instruction) -> int {
    cfg := instruction.cfg
    nums := instruction.nums
    states : [dynamic]rune = {'.'}
    defer delete(states)
    for nr in nums {
        for i in 0..<nr {
            append(&states, '#')
        }
        append(&states, '.')
    }
    statesMap : map[int]int
    defer delete(statesMap)
    statesMap[0]=1
    newMap : map[int]int
    defer delete(newMap)
    for char in cfg {
        for state in statesMap {
            if char == '?' {
                if state + 1 < len(states) {
                    newMap[state+1]=newMap[state+1]+statesMap[state]
                }
                if states[state] == '.' {
                    newMap[state]=newMap[state]+statesMap[state]
                }
            }
            else if char == '.' {
                if state+1 < len(states) && states[state+1] == '.' {
                    newMap[state+1]=newMap[state+1]+statesMap[state]
                }
                if states[state] == '.' {
                    newMap[state]=newMap[state]+statesMap[state]
                }
            }
            else if char == '#' {
                if state+1 < len(states) && states[state+1] == '#' {
                    newMap[state+1]=newMap[state+1]+statesMap[state]
                }
            }
        }
        statesMap = cloneMap(newMap)
        clear(&newMap)
    }
    return statesMap[len(states)-1]+statesMap[len(states)-2]
}

cloneMap :: proc(map1: map[int]int) -> map[int]int {
    res : map[int]int
    for i in map1 {
        res[i]=map1[i]
    }
    return res
}

part2ParseCfg :: proc(cfg: string, nums: []int) -> Instruction {
    newCfgRunes : [dynamic]rune
    defer delete(newCfgRunes)
    count : int = 0
    for i in 0..<len(cfg)*5 {
        if count >= len(cfg) {
            append(&newCfgRunes, '?')
            count = 0
        }
        append(&newCfgRunes, rune(cfg[i%len(cfg)]))
        count += 1
    }
    newCfg := utf8.runes_to_string(newCfgRunes[:])
    newNums : [dynamic]int
    // defer delete(newNums)
    count = 0
    for i in 0..<len(nums)*5 {
        append(&newNums, nums[i%len(nums)])
    }
    return Instruction{newCfg, newNums[:]}
}
