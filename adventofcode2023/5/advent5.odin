package advent5

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:math"

seedMapPt1 := map[i64]Seed {}
seedMapPt2 := map[i64]Seed {}

main :: proc() {
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines, _ := strings.split(string(file), "\r\n\r\n")
    defer delete(file)
    seeds := strings.split(lines[0], " ")[1:]
    for i in seeds { // fill seed map 1 with relevant seeds
        i2, _ := strconv.parse_i64(i)
        soil := parseMap(lines[1], i2)
        fert := parseMap(lines[2], soil)
        water := parseMap(lines[3], fert)
        light := parseMap(lines[4], water)
        temp := parseMap(lines[5], light)
        humidity := parseMap(lines[6], temp)
        loc := parseMap(lines[7], humidity)
        seedMapPt1[i2] = Seed{soil,fert,water,light,temp,humidity,loc}
    }
    lowest : i64
    for seed, i in seedMapPt1 {
        if lowest == 0 {
            lowest = seedMapPt1[seed].loc
        } else if seedMapPt1[seed].loc < lowest {
            lowest = seedMapPt1[seed].loc
        }
    }
    fmt.println("Lowest loc #:", lowest)
}

Seed :: struct {
    soil: i64,
    fert: i64,
    water: i64,
    light: i64,
    temp: i64,
    humidity: i64,
    loc: i64,
}

parseMap :: proc(input: string, target: i64) -> i64 {
    inputFmt1 := strings.split_lines(input)[1:]
    instructions : [dynamic][3]i64
    for i, index in inputFmt1 {
        lineSplit := strings.split(i, " ")
        defer delete(lineSplit)
        temp : [3]i64
        for num, index in lineSplit {
            numi64, _ := strconv.parse_i64(num)
            temp[index] = numi64
        }
        append(&instructions, temp)
    }
    ans : i64 = parseInstructions(instructions, target)
    return ans
}

parseInstructions :: proc(instructions: [dynamic][3]i64, target: i64) -> i64 {
    defer delete(instructions)
    for instruction in instructions{
        start : i64 = instruction[0]
        if target < instruction[1] do continue
        if target > instruction[1]+instruction[2] do continue
        if target < instruction[1]+instruction[2]/2 {
            for loc in instruction[1]..<instruction[1]+instruction[2]/2 {
                if loc == target {
                    return start
                }
                start += 1
            }
        } else if target > instruction[1]+instruction[2]/2 {
            start += instruction[2]/2
            for loc in instruction[1]+instruction[2]/2..<instruction[1]+instruction[2] {
                if loc == target {
                    return start
                }
                start += 1
            }
        }
    }
    return target
}
