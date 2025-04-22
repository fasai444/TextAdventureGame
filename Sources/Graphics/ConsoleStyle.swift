import Foundation

enum ConsoleColor: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case bold = "\u{001B}[1m"
    case underline = "\u{001B}[4m"
    case reset = "\u{001B}[0m"
}

struct ConsoleStyle {
    static func colorize(_ text: String, with color: ConsoleColor) -> String {
        return color.rawValue + text + ConsoleColor.reset.rawValue
    }
    
    static func roomName(_ name: String) -> String {
        return colorize(name, with: .cyan) + colorize(" (Room)", with: .blue)
    }
    
    static func itemName(_ name: String) -> String {
        return colorize(name, with: .yellow)
    }
    
    static func characterName(_ name: String) -> String {
        return colorize(name, with: .green)
    }
    
    static func puzzleText(_ text: String) -> String {
        return colorize(text, with: .magenta)
    }
    
    static func commandText(_ text: String) -> String {
        return colorize(text, with: .cyan)
    }
    
    static func importantMessage(_ text: String) -> String {
        return colorize(text, with: .bold)
    }
    
    static func errorMessage(_ text: String) -> String {
        return colorize(text, with: .red)
    }
    
    static func successMessage(_ text: String) -> String {
        return colorize(text, with: .green)
    }
}