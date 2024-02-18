package higherlower

import "core:fmt"
import "core:os"
import "core:unicode/utf8"
import "core:math/rand"

main :: proc() {
    fmt.println("Hello and welcome to my classical rendition of the game Higher or Lower, written in Odin!")
    fmt.println("The goal of this game is to guess if the next number generated between 1-100 will be higher or lower than the last given number.")
    first := rand.int31_max(100) + 1
    gameLoop(first) // Begin game loop
}

LEGALRUNES := []rune {'q', '>', '<'}

gameLoop :: proc(first: i32) {
    current: i32 = first
    last: i32
    score: int = 0
    for { // Infinite loop
        fmt.println("Your number is:", current)
        last = current
        current = rand.int31_max(100) + 1
        fmt.print("Guess higher (>) or lower (<) or quit (q): ")
        userInput := getUserInput()
        if !checkUserInput(userInput) {
            fmt.println("Sorry, that wasn't a recognized character!")
            continue
        }
        if userInput == 'q' {
            fmt.println("Your final score is:", score)
            fmt.println("Thanks for playing!")
            return
        }
        if (userInput == '>' && current >= last) || (userInput == '<' && current <= last) {
            fmt.println("Very nice! You're correct!")
            score += 1
        } else {
            fmt.println("You got it wrong!")
            score -= 1
        }
        fmt.println("Your current score is:", score)
    }
}

getUserInput :: proc() -> (userInput: rune) {
    // Get user input through I/O, convert to single character rune
    buffer: [256]byte
    n, err := os.read(os.stdin, buffer[:])
    if err < 0 {
        return 'f'
    }
    return utf8.string_to_runes(string(buffer[:n]))[0]
}

checkUserInput :: proc(userInput: rune) -> bool {
    // Check if user input rune is a legal character
    for char in LEGALRUNES {
        if userInput == char {return true}
    }
    return false
}
