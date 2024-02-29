package advent6

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:unicode"
import "core:unicode/utf8"
import "core:math"

main :: proc() {
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines, _ := strings.split(string(file), "\r\n")
    defer delete(file)
    times: [4]int
    distances: [4]int
    timeFmt := strings.split(lines[0], " ")
    distFmt := strings.split(lines[1], " ")
    defer delete(timeFmt)
    defer delete(distFmt)

    // Part 1
    index : int = 0
    for i in timeFmt {
        if i != "Time:" && i != "" {
            time, _ := strconv.parse_int(i)
            times[index] = time
            index += 1
        }
    }
    index = 0
    for i in distFmt {
        if i != "Distance:" && i != "" {
            dist, _ := strconv.parse_int(i)
            distances[index] = dist
            index += 1
        }
    }
    total : int = 1
    for time, i in times {
        waysBeat := getNumWaysBeat(time, distances[i])
        if waysBeat == 0 do continue
        total *= waysBeat
    }
    fmt.println("Part 1:", total)

    //Part 2
    timePt2 : int
    distancePt2 : int
    index = 0
    strParts : [dynamic]rune
    defer delete(strParts)
    for i, ii in timeFmt {
        if i != "Time:" && i != "" {
            for char in i {
                append(&strParts, char)
            }
        }
    }
    timePt2, _ = strconv.parse_int(utf8.runes_to_string(strParts[:]))
    clear(&strParts)
    index = 0
    for i, ii in distFmt {
        if i != "Distance:" && i != "" {
            for char in i {
                append(&strParts, char)
            }
        }
    }
    distancePt2, _ = strconv.parse_int(utf8.runes_to_string(strParts[:]))
    fmt.println("Part 2:", getNumWaysBeat(timePt2, distancePt2))
}

getNumWaysBeat :: proc(time: int, record: int) -> int {
    beat : int = 0
    for ms in 0..<time {
        speed : int = ms
        remaining : int = time - ms
        dist : int = speed*remaining
        if dist > record do beat += 1
    }
    return beat
}
