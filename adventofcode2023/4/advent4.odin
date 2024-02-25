package advent4

import "core:fmt"
import "core:strings"
import "core:os"

main :: proc() {
    sum: i64 = 0
    handle, err := os.open("input.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines := strings.split_lines(string(file))
    defer delete(lines)
    for card in lines {
        sum += parseCard(card)
    }
    fmt.println("Total points (pt 1):", sum)
    // fmt.println(parseCard("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"))
}

CARDSPLITTERRUNES : []string : {":", "|"}

parseCard :: proc(card: string) -> i64 {
    cardSplit, _ := strings.split_multi(card, CARDSPLITTERRUNES)
    winningNums := strings.split(cardSplit[1], " ")
    cardNums := strings.split(cardSplit[2], " ")
    cardScore : i64 = 0
    scoreCount : u16 = 0
    for winningNum in winningNums {
        if winningNum == "" do continue
        for cardNum in cardNums {
            if winningNum != cardNum || cardNum == "" do continue 
            if cardScore == 0 {
                cardScore += 1
                scoreCount += 1
            } else {
                cardScore *= 2
                scoreCount += 1
            }
        }
    }
    return cardScore
}
