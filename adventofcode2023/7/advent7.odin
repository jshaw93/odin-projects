package advent7

import "core:fmt"
import "core:os"
import "core:math"
import "core:strings"
import "core:unicode/utf8"

CARD_RANK : [13]rune : {
    '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A',
}
CARD_RANK_JOKER : [13]rune : {
    'J', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A',
}

Hand :: struct {
    cards: []rune,
    bid: int,
}

CardsType :: enum {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind,
}

main :: proc() {
    handle, err := os.open("example.txt")
    defer os.close(handle)
    file, success := os.read_entire_file_from_handle(handle)
    lines, _ := strings.split(string(file), "\r\n")
    defer delete(file)
    // Part 1
    hands : [dynamic]Hand
    defer delete(hands)
    defer for h in hands do delete(h.cards)
    for line in lines {
        lineFmt := strings.split(line, " ")
        append(&hands, Hand{utf8.string_to_runes(lineFmt[0]), strconv.parse_int(lineFmt[1])})
    }
    
}
