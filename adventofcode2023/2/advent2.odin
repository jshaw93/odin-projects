package advent2

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode/utf8"

main :: proc() {
    sum: i64 = 0
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines := strings.split(string(file), "\n")
    for line in lines {
        sum += parseString2(line)
    }
    fmt.println("Analysis complete! Power sum of games:", sum)
    // fmt.println(parseString2("Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"))
}

CUBELIMITS := map[string]i64 {
    "red" = 12,
    "green" = 13,
    "blue" = 14,
}

parseString :: proc(game: string) -> i64 {
    substrings := [?]string {": ", "; "}
    gameSplit, _ := strings.split_multi(game, substrings[:])
    idReplaced, _ := strings.replace(gameSplit[0], "Game ", "", -1)
    id, _ := strconv.parse_i64(idReplaced)
    for round in gameSplit[1:] {
        roundClean, _ := strings.replace(round, "\r", "", -1)
        roundSplit := strings.split(roundClean, ", ")
        for cube in roundSplit {
            cubeFmt := strings.split(cube, " ")
            cubeNum, _ := strconv.parse_i64(cubeFmt[0])
            if cubeNum > CUBELIMITS[cubeFmt[1]] {
                fmt.println(id, cube)
                return 0
            }
        }
    }
    return id
}

parseString2 :: proc(game: string) -> i64 {
    product: i64 = 1
    cubeminimum := map[string]i64 {
        "red" = 0,
        "blue" = 0,
        "green" = 0,
    }
    defer delete(cubeminimum)
    substrings := [?]string {": ", "; "}
    gameSplit, _ := strings.split_multi(game, substrings[:])
    for round in gameSplit[1:] {
        roundClean, _ := strings.replace(round, "\r", "", -1)
        roundSplit := strings.split(roundClean, ", ")
        for cube in roundSplit {
            cubeFmt := strings.split(cube, " ")
            cubeNum, _ := strconv.parse_i64(cubeFmt[0])
            if cubeNum > cubeminimum[cubeFmt[1]] {
                cubeminimum[cubeFmt[1]] = cubeNum
            }
        }
    }
    for color in cubeminimum {
        product *= cubeminimum[color]
    }
    return product
}
