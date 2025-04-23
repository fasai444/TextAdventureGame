import Foundation

struct AsciiArt {
    static let roomArt: [Int: String] = [
        1: """
        +----------------+
        |                |
        |  ENTRANCE HALL |
        |                |
        +--------++------+
        """,
        2: """
        +----------------+
        |    LIBRARY     |
        |   .-""--.      |
        |  /      \\     |
        | |  BOOKS |     |
        |  \\      /     |
        +---++----+------+
        """,
        3: """
        +----------------+
        |    ARMORY      |
        |   /|    |\\     |
        |  / |    | \\    |
        | /__|____|__\\   |
        |                |
        +----------------+
        """,
        4: """
        +----------------+
        |    KITCHEN     |
        |   _________    |
        |  |    _    |   |
        |  |   |_|   |   |
        |  |_________|   |
        +----------------+
        """,
        5: """
        +----------------+
        |  DINING HALL   |
        |  +---------+   |
        |  |         |   |
        |  |  TABLE  |   |
        |  +---------+   |
        +----------------+
        """,
        6: """
        +----------------+
        |    GARDEN      |
        |    \\|/ _ \\|/   |
        |    /|\\_|_/|\\   |
        |      |/|\\      |
        |      \\|/\\      |
        +----------------+
        """,
        7: """
        +----------------+
        |     TOWER      |
        |       /\\       |
        |      /  \\      |
        |     /    \\     |
        |    /______\\    |
        +----------------+
        """,
        8: """
        +----------------+
        |  TREASURE ROOM |
        |    _______     |
        |   /       \\    |
        |  | $ $ $ $ |   |
        |   \\_______/    |
        +----------------+
        """
    ]
    
    static let transitionFrames = [
        """
        +----------------+
        |                |
        |     >>>>       |
        |                |
        +----------------+
        """,
        """
        +----------------+
        |                |
        |       >>>>     |
        |                |
        +----------------+
        """,
        """
        +----------------+
        |                |
        |         >>>>   |
        |                |
        +----------------+
        """,
        """
        +----------------+
        |                |
        |           >>>> |
        |                |
        +----------------+
        """
    ]
    
    static let titleArt = """
        _____         _     _                 _                   
       |_   _|____  _| |_  | |    _____   ___| |_ _   _ _ __ ___ 
         | |/ _ \\ \\/ / __| | |   / _ \\ \\ / / | __| | | | '__/ _ \\
         | |  __/>  <| |_  | |__|  __/\\ V /| | |_| |_| | | |  __/
         |_|\\___/_/\\_\\\\__| |_____\\___| \\_/ |_|\\__|\\__,_|_|  \\___|
                                                                 
    """
    
    static let gameOverArt = """
        _____                         ____                 
       / ____|                       / __ \\                
      | |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __ 
      | | |_ |/ _` | '_ ` _ \\ / _ \\ | |  | \\ \\ / / _ \\ '__|
      | |__| | (_| | | | | | |  __/ | |__| |\\ V /  __/ |   
       \\_____|\\__,_|_| |_| |_|\\___|  \\____/  \\_/ \\___|_|   
                                                           
    """
    
    static let victoryArt = """
        __     ___      _                   _ 
        \\ \\   / (_) ___| |_ ___  _ __ _   _| |
         \\ \\ / /| |/ __| __/ _ \\| '__| | | | |
          \\ V / | | (__| || (_) | |  | |_| |_|
           \\_/  |_|\\___|\\__\\___/|_|   \\__, (_)
                                      |___/   
    """
    
    static let inventoryArt = """
        +-----------------------+
        |     INVENTORY         |
        +-----------------------+
    """
    
    static func showDungeonView(forward: Bool, left: Bool, right: Bool) {
        let view = """
        +----------------+
        |     \(forward ? "   " : "▓▓▓")      |
        |  \(left ? "  " : "▓▓")|    |\(right ? "  " : "▓▓")  |
        |   \(left ? " " : "▓")|    |\(right ? " " : "▓")   |
        |    |    |    |
        +----------------+
        """
        print(view)
    }
    // Add this to Sources/Graphics/AsciiArt.swift
struct SlidingPuzzle {
    private var grid: [[Int]]
    private let size: Int
    private var emptyRow: Int
    private var emptyCol: Int
    
    init(size: Int) {
        self.size = size
        
        // Initialize ordered grid
        var values = Array(1...(size*size-1)) + [0] // 0 represents empty space
        grid = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        // Fill grid with values
        for row in 0..<size {
            for col in 0..<size {
                grid[row][col] = values[row * size + col]
            }
        }
        
        emptyRow = size - 1
        emptyCol = size - 1
        
        // Shuffle grid (make valid, solvable moves)
        for _ in 0..<100 {
            let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
            let validMoves = directions.filter { dir in
                let newRow = emptyRow + dir.0
                let newCol = emptyCol + dir.1
                return newRow >= 0 && newRow < size && newCol >= 0 && newCol < size
            }
            
            if let move = validMoves.randomElement() {
                swapWithEmpty(row: emptyRow + move.0, col: emptyCol + move.1)
            }
        }
    }
    
    mutating func moveCell(_ row: Int, _ col: Int) -> Bool {
        // Check if the position is adjacent to the empty cell
        if (row == emptyRow && abs(col - emptyCol) == 1) || 
           (col == emptyCol && abs(row - emptyRow) == 1) {
            swapWithEmpty(row: row, col: col)
            return true
        }
        return false
    }
    
    mutating func swapWithEmpty(row: Int, col: Int) {
        grid[emptyRow][emptyCol] = grid[row][col]
        grid[row][col] = 0
        emptyRow = row
        emptyCol = col
    }
    
    func isSolved() -> Bool {
        var expectedValue = 1
        for row in 0..<size {
            for col in 0..<size {
                if row == size - 1 && col == size - 1 {
                    if grid[row][col] != 0 {
                        return false
                    }
                } else if grid[row][col] != expectedValue {
                    return false
                }
                expectedValue += 1
            }
        }
        return true
    }
    
    func render() -> String {
        var result = ""
        
        // Top border
        result += "+" + String(repeating: "---+", count: size) + "\n"
        
        // Grid cells
        for row in 0..<size {
            result += "|"
            for col in 0..<size {
                let value = grid[row][col]
                let cellText = value == 0 ? "   " : String(format: " %2d ", value)
                result += cellText + "|"
            }
            result += "\n"
            
            // Row border
            result += "+" + String(repeating: "---+", count: size) + "\n"
        }
        
        return result
    }
}

// Add this to AsciiArt
static func slidingPuzzleInstructions() -> String {
    return """
    +-----------------------------------+
    |       SLIDING PUZZLE              |
    |-----------------------------------|
    | Arrange numbers in order from 1-8 |
    | with the empty space at bottom    |
    | right.                            |
    |                                   |
    | Commands:                         |
    | - slide <row> <col>               |
    | - solve                           |
    +-----------------------------------+
    """
}
// Add to Sources/Graphics/AsciiArt.swift
struct MemoryGame {
    private var cards: [[Character]]
    private var revealed: [[Bool]]
    private let symbols = ["A", "B", "C", "D", "E", "F", "G", "H"]
    private var pairsFound = 0
    private var totalPairs: Int
    private var lastRevealedRow: Int?
    private var lastRevealedCol: Int?
    
    init(rows: Int, cols: Int) {
        // Ensure even number of cells
        assert(rows * cols % 2 == 0, "Grid must have even number of cells")
        
        self.cards = Array(repeating: Array(repeating: " ", count: cols), count: rows)
        self.revealed = Array(repeating: Array(repeating: false, count: cols), count: rows)
        self.totalPairs = rows * cols / 2
        
        // Create pairs of symbols
        var symbols = Array(repeating: self.symbols, count: 2).flatMap { $0 }
        symbols = Array(symbols.prefix(totalPairs * 2))
        symbols.shuffle()
        
        // Place symbols on grid
        var index = 0
        for row in 0..<rows {
            for col in 0..<cols {
                cards[row][col] = Character(symbols[index])
                index += 1
            }
        }
    }
    
    mutating func revealCard(row: Int, col: Int) -> Bool {
        // Check if cell is valid and not already revealed
        guard row >= 0 && row < cards.count && col >= 0 && col < cards[0].count && !revealed[row][col] else {
            return false
        }
        
        // If this is first card to reveal in this turn
        if lastRevealedRow == nil {
            revealed[row][col] = true
            lastRevealedRow = row
            lastRevealedCol = col
            return true
        }
        
        // If this is second card to reveal in this turn
        revealed[row][col] = true
        
        // Check if cards match
        if cards[row][col] == cards[lastRevealedRow!][lastRevealedCol!] {
            // Match found!
            pairsFound += 1
            lastRevealedRow = nil
            lastRevealedCol = nil
            return true
        } else {
            // No match
            return true
        }
    }
    
    mutating func hideNonMatches() {
        if let row = lastRevealedRow, let col = lastRevealedCol {
            for r in 0..<cards.count {
                for c in 0..<cards[0].count {
                    if revealed[r][c] && (cards[r][c] != cards[row][col] || (r == row && c == col)) {
                        if !isPaired(r, c) {
                            revealed[r][c] = false
                        }
                    }
                }
            }
            lastRevealedRow = nil
            lastRevealedCol = nil
        }
    }
    
    private func isPaired(_ row: Int, _ col: Int) -> Bool {
        let symbol = cards[row][col]
        var pairCount = 0
        
        for r in 0..<cards.count {
            for c in 0..<cards[0].count {
                if revealed[r][c] && cards[r][c] == symbol {
                    pairCount += 1
                }
            }
        }
        
        return pairCount > 1
    }
    
    func isCompleted() -> Bool {
        return pairsFound == totalPairs
    }
    
    func render() -> String {
        var result = "  "
        // Column headers
        for col in 0..<cards[0].count {
            result += " \(col) "
        }
        result += "\n"
        
        for row in 0..<cards.count {
            result += "\(row) "
            for col in 0..<cards[0].count {
                if revealed[row][col] {
                    result += "[\(cards[row][col])]"
                } else {
                    result += "[ ]"
                }
            }
            result += "\n"
        }
        return result
    }
}

// Add this to AsciiArt
static func memoryGameInstructions() -> String {
    return """
    +-----------------------------------+
    |       MEMORY MATCH GAME           |
    |-----------------------------------|
    | Find all matching pairs of cards  |
    | by revealing them one at a time.  |
    |                                   |
    | Commands:                         |
    | - reveal <row> <col>              |
    | - solve                           |
    +-----------------------------------+
    """
}
}
// Add to Sources/Graphics/AsciiArt.swift
struct MazeGame {
    private var maze: [[Character]]
    private var playerRow: Int
    private var playerCol: Int
    private var exitRow: Int
    private var exitCol: Int
    
    init(width: Int, height: Int) {
        // Create a simple maze
        // # = wall, . = path, P = player, E = exit
        maze = Array(repeating: Array(repeating: "#", count: width), count: height)
        
        // Simple algorithm to create paths
        for row in 1..<height-1 {
            for col in 1..<width-1 {
                if (row % 2 == 1 || col % 2 == 1) && 
                   Int.random(in: 0...100) > 30 {
                    maze[row][col] = "."
                }
            }
        }
        
        // Ensure a path exists
        for row in 1..<height-1 {
            maze[row][1] = "."
            maze[row][width-2] = "."
        }
        for col in 1..<width-1 {
            maze[1][col] = "."
            maze[height-2][col] = "."
        }
        
        // Place player at start
        playerRow = 1
        playerCol = 1
        maze[playerRow][playerCol] = "P"
        
        // Place exit
        exitRow = height - 2
        exitCol = width - 2
        maze[exitRow][exitCol] = "E"
    }
    
    mutating func movePlayer(direction: String) -> Bool {
        var newRow = playerRow
        var newCol = playerCol
        
        switch direction.lowercased() {
        case "n", "north": newRow -= 1
        case "s", "south": newRow += 1
        case "e", "east": newCol += 1
        case "w", "west": newCol -= 1
        default:
            return false
        }
        
        // Check if move is valid
        if newRow >= 0 && newRow < maze.count && newCol >= 0 && newCol < maze[0].count &&
           (maze[newRow][newCol] == "." || maze[newRow][newCol] == "E") {
            
            // Update player position
            maze[playerRow][playerCol] = "."
            playerRow = newRow
            playerCol = newCol
            
            // Check if reached exit
            if playerRow == exitRow && playerCol == exitCol {
                return true // Game complete
            }
            
            maze[playerRow][playerCol] = "P"
            return false // Move successful but game not complete
        }
        
        return false // Invalid move
    }
    
    func render() -> String {
        var result = ""
        for row in maze {
            for cell in row {
                switch cell {
                case "#": result += "■"
                case ".": result += "·"
                case "P": result += "☺"
                case "E": result += "★"
                default: result += cell
                }
            }
            result += "\n"
        }
        return result
    }
    
    func isCompleted() -> Bool {
        return playerRow == exitRow && playerCol == exitCol
    }
}

// Add this to AsciiArt
static func mazeGameInstructions() -> String {
    return """
    +-----------------------------------+
    |       MAZE GAME                   |
    |-----------------------------------|
    | Find your way through the maze    |
    | to reach the exit (★).            |
    |                                   |
    | Commands:                         |
    | - move n/s/e/w                    |
    | - solve                           |
    +-----------------------------------+
    Legend:
    ■ = Wall  · = Path  ☺ = You  ★ = Exit
    """
}