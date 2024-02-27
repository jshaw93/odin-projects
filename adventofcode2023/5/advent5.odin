package advent5

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:thread"
import "core:time"
import "core:mem"

Seed :: struct {
    soil: i64,
    fert: i64,
    water: i64,
    light: i64,
    temp: i64,
    humidity: i64,
    loc: i64,
}

TaskData :: struct {
    lines: []string,
    seed: i64,
    seedStruct: Seed,
}

main :: proc() {
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines, _ := strings.split(string(file), "\r\n\r\n")
    defer delete(file)
    seedPreFmt := strings.split(lines[0], " ")[1:]
    seeds : [dynamic]i64
    for i, index in seedPreFmt {
        seed, _ := strconv.parse_i64(i)
        append(&seeds, seed)
    }
    seedMapPt1 := map[i64]Seed {}
    seedMapPt2 := map[i64]Seed {}
    defer delete(seedMapPt1)
    defer delete(seedMapPt2)
    pool: thread.Pool
    thread.pool_init(&pool, allocator=context.allocator, thread_count=6)
    defer thread.pool_destroy(&pool)
    thread.pool_start(&pool)
    for i, ii in seeds { // fill seed map 1 with relevant seeds
        data := new(TaskData)
        data.lines = lines
        data.seed = i
        thread.pool_add_task(
            &pool,
            context.allocator,
            buildSeed,
            data,
            user_index=ii,
        )
    }
    thread.pool_finish(&pool)
    for {
        task, ok := thread.pool_pop_done(&pool)
        if !ok do break 
        data := transmute(^TaskData)task.data
        seedMapPt1[data.seed] = data.seedStruct
        free(data)
    }
    lowest : i64
    for seed, i in seedMapPt1 {
        if lowest == 0 {
            lowest = seedMapPt1[seed].loc
        } else if seedMapPt1[seed].loc < lowest {
            lowest = seedMapPt1[seed].loc
        }
    }
    fmt.println("Lowest loc # pt 1:", lowest)

    thread.pool_init(&pool, allocator=context.allocator, thread_count=6)
    thread.pool_start(&pool)
    for seed, ii in seeds[0]..<seeds[0]+seeds[1] {
        data := new(TaskData)
        data.lines = lines
        data.seed = seed
        thread.pool_add_task(
            &pool,
            context.allocator,
            buildSeed,
            data,
            user_index=ii,
        )
    }
    thread.pool_finish(&pool)
    for {
        task, ok := thread.pool_pop_done(&pool)
        if !ok do break 
        data := transmute(^TaskData)task.data
        seedMapPt2[data.seed] = data.seedStruct
        free(data)
    }
    thread.pool_init(&pool, allocator=context.allocator, thread_count=6)
    thread.pool_start(&pool)
    for seed, ii in seeds[2]..<seeds[2]+seeds[3] {
        data := new(TaskData)
        data.lines = lines
        data.seed = seed
        thread.pool_add_task(
            &pool,
            context.allocator,
            buildSeed,
            data,
            user_index=ii,
        )
    }
    thread.pool_finish(&pool)
    for {
        task, ok := thread.pool_pop_done(&pool)
        if !ok do break 
        data := transmute(^TaskData)task.data
        seedMapPt2[data.seed] = data.seedStruct
        free(data)
    }
    lowestPt2 : i64
    for seed, i in seedMapPt2 {
        if lowestPt2 == 0 {
            lowestPt2 = seedMapPt2[seed].loc
        } else if seedMapPt2[seed].loc < lowestPt2 {
            lowestPt2 = seedMapPt2[seed].loc
        }
    }
    fmt.println("Lowest loc # pt 2:", lowestPt2)
}

buildSeed :: proc(task: thread.Task) {
    data := transmute(^TaskData)task.data
    using data
    soil := parseMap(lines[1], seed)
    fert := parseMap(lines[2], soil)
    water := parseMap(lines[3], fert)
    light := parseMap(lines[4], water)
    temp := parseMap(lines[5], light)
    humidity := parseMap(lines[6], temp)
    loc := parseMap(lines[7], humidity)
    fmt.println("Done:", task.user_index)
    seedStruct = Seed{soil,fert,water,light,temp,humidity,loc}
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
        final := instruction[0]
        if target < instruction[1] do continue
        if target > instruction[1]+instruction[2] do continue
        if target < instruction[1]+instruction[2]/2 {
            for loc, i in instruction[1]..<instruction[1]+instruction[2]/2 {
                if loc == target {
                    return final
                }
                final += 1
                if i % 1000 == 0 {
                    thread.yield()
                }
            }
        } else if target > instruction[1]+instruction[2]/2 {
            final += instruction[2]/2
            for loc, i in instruction[1]+instruction[2]/2..<instruction[1]+instruction[2] {
                if loc == target {
                    return final
                }
                final += 1
                if i % 1000 == 0 {
                    thread.yield()
                }
            }
        }
        // thread.yield()
    }
    return target
}
