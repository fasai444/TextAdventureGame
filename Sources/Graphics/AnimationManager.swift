import Foundation
#if os(macOS) || os(Linux)
import Dispatch
#endif

class AnimationManager {
    // Clear the console screen
    static func clearScreen() {
        print("\u{001B}[2J\u{001B}[H", terminator: "")
    }
    
    // Animate a sequence of frames
    static func animate(frames: [String], frameDuration: Double = 0.2, cycles: Int = 1) {
        for _ in 0..<cycles {
            for frame in frames {
                clearScreen()
                print(frame)
                
                // Sleep between frames
                #if os(macOS) || os(Linux)
                Thread.sleep(forTimeInterval: frameDuration)
                #else
                // For other platforms
                let sleepTime = UInt32(frameDuration * 1000000)
                usleep(sleepTime)
                #endif
            }
        }
        clearScreen()
    }
    
    // Create a simple loading animation
    static func showLoadingAnimation(message: String = "Loading", duration: Double = 3.0) {
        let spinnerFrames = ["|", "/", "-", "\\"]
        let frameTime = 0.1
        let iterations = Int(duration / frameTime / Double(spinnerFrames.count))
        
        for _ in 0..<iterations {
            for frame in spinnerFrames {
                clearScreen()
                print("\(message) \(frame)")
                
                #if os(macOS) || os(Linux)
                Thread.sleep(forTimeInterval: frameTime)
                #else
                let sleepTime = UInt32(frameTime * 1000000)
                usleep(sleepTime)
                #endif
            }
        }
        clearScreen()
    }
    
    // Show progress bar
    static func showProgressBar(percent: Double, width: Int = 20) {
        let filled = Int(Double(width) * percent)
        let empty = width - filled
        
        let bar = "[" + String(repeating: "█", count: filled) + String(repeating: "░", count: empty) + "]"
        print("\r\(bar) \(Int(percent * 100))%", terminator: "")
        fflush(stdout)
    }
    
    // "Typing" effect for text
    static func typeText(_ text: String, speed: Double = 0.02) {
        for char in text {
            print(char, terminator: "")
            fflush(stdout)
            #if os(macOS) || os(Linux)
            Thread.sleep(forTimeInterval: speed)
            #else
            // For other platforms
            let sleepTime = UInt32(speed * 1000000)
            usleep(sleepTime)
            #endif
        }
        print()
    }
    
    // Show particle effect (e.g., for finding treasure)
    static func showParticleEffect(duration: Double = 2.0) {
        let width = 40
        let height = 10
        
        let startTime = Date()
        while Date().timeIntervalSince(startTime) < duration {
            clearScreen()
            
            var display = Array(repeating: Array(repeating: " ", count: width), count: height)
            
            // Add random particles
            for _ in 0..<15 {
                let x = Int.random(in: 0..<width)
                let y = Int.random(in: 0..<height)
                display[y][x] = ["*", "•", "+", "✧", "✦"].randomElement()!
            }
            
            // Print the display
            for row in display {
                print(row.joined())
            }
            
            #if os(macOS) || os(Linux)
            Thread.sleep(forTimeInterval: 0.1)
            #else
            usleep(100000)
            #endif
        }
        clearScreen()
    }
}