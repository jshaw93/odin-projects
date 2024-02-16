package main

import "core:fmt"
import "core:os"

main :: proc() {
    buffer: [256]byte // Create buffer of 256 bytes
    fmt.println("Please enter some text:")
    n, err := os.read(os.stdin, buffer[:]) // Read from stdin into buffer
    if err < 0 {
        return
    }
    message := string(buffer[:n]) // Cast bytes to string type and assign to message
    fmt.println("Outputted text:", message)
}
