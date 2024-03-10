package advent8

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"
import "core:thread"
import "core:math"

NetNode :: struct {
    left: string,
    right: string,
}

TaskData :: struct {
    current: string,
    count: int,
    netMap: map[string]NetNode,
    instructions: []rune,
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
        if !ok do break
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
    fmt.println("Part 1:", count)

    // Part 2
    counts : [dynamic]int
    defer delete(counts)
    currentKeys : [dynamic]string
    defer delete(currentKeys)
    for key in netMap {
        if key[2] == 'A' do append(&currentKeys, key)
    }
    pool : thread.Pool
    thread.pool_init(&pool, context.allocator, 6)
    defer thread.pool_destroy(&pool)
    thread.pool_start(&pool)
    for key in currentKeys {
        data := new(TaskData)
        data.current = key
        data.count = 0
        data.netMap = netMap
        data.instructions = instructions
        thread.pool_add_task(
            &pool,
            context.allocator,
            getIndividualSteps,
            data,
        )
    }
    thread.pool_finish(&pool)
    for {
        task, ok := thread.pool_pop_done(&pool)
        if !ok do break 
        data := transmute(^TaskData)task.data
        append(&counts, data.count)
        free(data)
    }
    lcm : int = 1
    for i in counts {
        lcm = lcm * i / math.gcd(lcm, i)
    }
    fmt.println("Part 2:", lcm)
}

parseNetMap :: proc(line: string) -> (string, NetNode) {
    node : string
    pt1 : string
    pt2 : string
    current : [dynamic]rune
    defer delete(current)
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

getIndividualSteps :: proc(task: thread.Task) {
    data := transmute(^TaskData)task.data
    using data
    index : int = 0
    for current[2] != 'Z' {
        node, ok := netMap[current]
        // if !ok do break
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
}
