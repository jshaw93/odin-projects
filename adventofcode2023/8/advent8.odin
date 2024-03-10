package advent8

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

NetNode :: struct {
    left: string,
    right: string,
}

main :: proc() {
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines, _ := strings.split(string(file), "\r\n")
    defer delete(file)
    instructions := utf8.string_to_runes(lines[0])
    netMap := make(map[string]NetNode)
    defer delete(netMap)
    for line in lines[2:] {
        node, netNode := parseNetMap(line)
        netMap[node] = netNode
    }
    // Part 1
    current : string = "AAA"
    index : int = 0
    count : int = 0
    for current != "ZZZ" {
        node, ok := netMap[current]
        side : rune = instructions[index]
        if side == 'L' {
            current = node.left
        } else {
            current = node.right
        }
        index += 1
        if index > len(instructions) - 1 do index = 0
        count += 1
    }
    fmt.println(count)
}

parseNetMap :: proc(line: string) -> (string, NetNode) {
    node : string
    pt1 : string
    pt2 : string
    current : [dynamic]rune
    for char in line {
        if char == ' ' {
            continue
        }
        if char == '=' {
            node = utf8.runes_to_string(current[:])
            clear(&current)
        }
        if char == ',' {
            pt1 = utf8.runes_to_string(current[2:])
            clear(&current)
        }
        if char == ')' {
            pt2 = utf8.runes_to_string(current[1:])
            clear(&current)
        }
        append(&current, char)
    }
    return node, NetNode{pt1, pt2}
}
