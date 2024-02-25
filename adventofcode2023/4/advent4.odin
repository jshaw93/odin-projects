package advent4

import "core:fmt"
import "core:strings"
import "core:os"
import "core:slice"
import "core:math"

main :: proc() {
    sum: i64 = 0
    sum2: int = 0
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines := strings.split_lines(string(file))
    defer delete(lines)
    defer delete(file)
    cardCounts := make([]int, len(lines))
    defer delete(cardCounts)
    slice.fill(cardCounts, 1)
    for card, i in lines {
        wins, winCount := parseCard(card)
        sum += wins
        for j in 0..<winCount {
            cardCounts[i + int(j) + 1] += cardCounts[i]
        }
    }
    sum2 = math.sum(cardCounts)
    fmt.println("Total points (pt 1):", sum)
    fmt.println("Total scratchcards (pt 2):", sum2)
}

CARDSPLITTERRUNES : []string : {":", "|"}

parseCard :: proc(card: string) -> (i64, i64) {
    cardSplit, _ := strings.split_multi(card, CARDSPLITTERRUNES)
    winningNums := strings.split(cardSplit[1], " ")
    cardNums := strings.split(cardSplit[2], " ")
    defer delete(cardSplit)
    defer delete(winningNums)
    defer delete(cardNums)
    cardScore : i64 = 0
    scoreCount : bool = false
    winCount : i64 = 0
    for winningNum in winningNums {
        if winningNum == "" do continue
        for cardNum in cardNums {
            if winningNum != cardNum || cardNum == "" do continue 
            if cardScore == 0 {
                cardScore += 1
                scoreCount = true
            } else {
                cardScore *= 2
            }
            winCount += 1
        }
    }
    return cardScore, winCount
}
