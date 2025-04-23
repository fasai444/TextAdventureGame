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
    
    // Define the SlidingPuzzle struct
    struct SlidingPuzzle {
        let size: Int
        var grid: [[Int]]
        var emptyRow: Int
        var emptyCol: Int
        var moves = 0
        var solved = false
        
        init(size: Int) {
            self.size = size
            let values = Array(1...(size*size-1)) + [0] // 0 represents empty space
            var shuffledValues = values.shuffled()
            
            // Make sure the puzzle is solvable
            while !SlidingPuzzle.isSolvable(values: shuffledValues, size: size) {
                shuffledValues = values.shuffled()
            }
            
            // Initialize the grid
            self.grid = Array(repeating: Array(repeating: 0, count: size), count: size)
            var index = 0
            for row in 0..<size {
                for col in 0..<size {
                    grid[row][col] = shuffledValues[index]
                    if grid[row][col] == 0 {
                        emptyRow = row
                        emptyCol = col
                    }
                    index += 1
                }
            }
            
            // Default values for emptyRow and emptyCol if not set (should not happen)
            self.emptyRow = 0
            self.emptyCol = 0
            
            // Find the empty space
            for row in 0..<size {
                for col in 0..<size {
                    if grid[row][col] == 0 {
                        emptyRow = row
                        emptyCol = col
                        break
                    }
                }
            }
        }
        
        // Helper function to check if a puzzle is solvable
        private static func isSolvable(values: [Int], size: Int) -> Bool {
            var inversions = 0
            for i in 0..<values.count {
                if values[i] == 0 { continue }
                for j in (i+1)..<values.count {
                    if values[j] == 0 { continue }
                    if values[i] > values[j] {
                        inversions += 1
                    }
                }
            }
            
            // For odd-sized puzzles, the puzzle is solvable if inversions is even
            if size % 2 == 1 {
                return inversions % 2 == 0
            } else {
                // For even-sized puzzles, the puzzle is solvable if:
                // - inversions is odd and the empty space is on an even row from the bottom
                // - inversions is even and the empty space is on an odd row from the bottom
                let emptyIndex = values.firstIndex(of: 0)!
                let emptyRow = emptyIndex / size
                let rowFromBottom = size - emptyRow
                return (inversions % 2 == 0) == (rowFromBottom % 2 == 1)
            }
        }
        
        mutating func move(direction: String) -> Bool {
            var newRow = emptyRow
            var newCol = emptyCol
            
            switch direction.lowercased() {
            case "up": newRow -= 1
            case "down": newRow += 1
            case "left": newCol -= 1
            case "right": newCol += 1
            default: return false
            }
            
            // Check if move is valid
            if newRow < 0 || newRow >= size || newCol < 0 || newCol >= size {
                return false
            }
            
            // Swap tiles
            grid[emptyRow][emptyCol] = grid[newRow][newCol]
            grid[newRow][newCol] = 0
            emptyRow = newRow
            emptyCol = newCol
            moves += 1
            
            // Check if puzzle is solved
            checkIfSolved()
            
            return true
        }
        
        mutating func checkIfSolved() {
            var expected = 1
            for row in 0..<size {
                for col in 0..<size {
                    // Skip the last cell which should be empty
                    if row == size-1 && col == size-1 {
                        solved = grid[row][col] == 0
                        return
                    }
                    
                    if grid[row][col] != expected {
                        solved = false
                        return
                    }
                    expected += 1
                }
            }
            solved = true
        }
        
        func display() -> String {
            var result = "\n"
            for row in 0..<size {
                result += " "
                for col in 0..<size {
                    if grid[row][col] == 0 {
                        result += "   "
                    } else {
                        let value = grid[row][col]
                        result += String(format: "%2d ", value)
                    }
                }
                result += "\n"
            }
            return result
        }
    }
    
    // Define the MemoryGame struct
    struct MemoryGame {
        var rows: Int
        var cols: Int
        var cards: [[String]]
        var revealed: [[Bool]]
        var lastRevealedRow: Int?
        var lastRevealedCol: Int?
        var moves = 0
        var matchesFound = 0
        var totalMatches: Int
        var gameOver = false
        
        init(rows: Int, cols: Int) {
            self.rows = rows
            self.cols = cols
            
            // Make sure rows * cols is even
            if rows * cols % 2 != 0 {
                fatalError("Memory game requires an even number of cards")
            }
            
            self.cards = Array(repeating: Array(repeating: " ", count: cols), count: rows)
            self.revealed = Array(repeating: Array(repeating: false, count: cols), count: rows)
            self.totalMatches = (rows * cols) / 2
            
            // Generate pairs of symbols
            let symbols = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
                          "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
            
            var availableSymbols = symbols.prefix(totalMatches).flatMap { [$0, $0] }
            availableSymbols.shuffle()
            
            var index = 0
            for row in 0..<rows {
                for col in 0..<cols {
                    cards[row][col] = availableSymbols[index]
                    index += 1
                }
            }
        }
        
        mutating func revealCard(row: Int, col: Int) -> Bool {
            // Check if the card is already revealed
            if revealed[row][col] {
                return false
            }
            
            // Reveal the card
            revealed[row][col] = true
            
            // If this is the first card in a pair
            if lastRevealedRow == nil {
                lastRevealedRow = row
                lastRevealedCol = col
                return true
            }
            
            // This is the second card
            moves += 1
            
            // Check if the cards match
            if cards[row][col] == cards[lastRevealedRow!][lastRevealedCol!] {
                // Match found
                matchesFound += 1
                lastRevealedRow = nil
                lastRevealedCol = nil
                
                // Check if game is over
                if matchesFound == totalMatches {
                    gameOver = true
                }
                
                return true
            } else {
                // No match, cards will be hidden after a delay
                return true
            }
        }
        
        mutating func hideUnmatchedCards() {
            // Hide cards that don't match
            if lastRevealedRow != nil && lastRevealedCol != nil {
                revealed[lastRevealedRow!][lastRevealedCol!] = false
                lastRevealedRow = nil
                lastRevealedCol = nil
            }
        }
        
        func display() -> String {
            var result = "\n  "
            
            // Column headers
            for c in 0..<cols {
                result += " \(c) "
            }
            result += "\n"
            
            for r in 0..<rows {
                result += "\(r) "
                for c in 0..<cols {
                    if revealed[r][c] {
                        result += "[\(cards[r][c])]"
                    } else {
                        result += "[ ]"
                    }
                }
                result += "\n"
            }
            
            result += "\nMatches: \(matchesFound)/\(totalMatches)  Moves: \(moves)\n"
            return result
        }
        
        func allCardsWithSymbol(symbol: String) -> [(Int, Int)] {
            var positions: [(Int, Int)] = []
            for r in 0..<rows {
                for c in 0..<cols {
                    if revealed[r][c] && cards[r][c] == symbol {
                        positions.append((r, c))
                    }
                }
            }
            return positions
        }
    }
    
    // Define the MazeGame struct
    struct MazeGame {
        var width: Int
        var height: Int
        var maze: [[String]]
        var playerRow: Int
        var playerCol: Int
        var exitRow: Int
        var exitCol: Int
        var moves = 0
        var solved = false
        
        init(width: Int, height: Int) {
            // Ensure dimensions are odd for better maze generation
            self.width = width % 2 == 0 ? width + 1 : width
            self.height = height % 2 == 0 ? height + 1 : height
            
            // Initialize maze with walls
            self.maze = Array(repeating: Array(repeating: "#", count: width), count: height)
            
            // Simple maze generation (just a border with some random walls)
            for row in 1..<height-1 {
                for col in 1..<width-1 {
                    if row % 2 == 1 || col % 2 == 1 {
                        maze[row][col] = "."
                    }
                }
            }
            
            // Ensure entrance and exit have paths
            for row in 1..<height-1 {
                maze[row][1] = "."
                maze[row][width-2] = "."
            }
            
            for col in 1..<width-1 {
                maze[1][col] = "."
                maze[height-2][col] = "."
            }
            
            // Place player at entrance
            playerRow = height / 2
            playerCol = 1
            maze[playerRow][playerCol] = "P"
            
            // Place exit at far end
            exitRow = height / 2
            exitCol = width - 2
            maze[exitRow][exitCol] = "E"
        }
        
        mutating func move(direction: String) -> Bool {
            var newRow = playerRow
            var newCol = playerCol
            
            switch direction.lowercased() {
            case "up": newRow -= 1
            case "down": newRow += 1
            case "left": newCol -= 1
            case "right": newCol += 1
            default: return false
            }
            
            // Check if move is valid
            if newRow < 0 || newRow >= height || newCol < 0 || newCol >= width {
                return false
            }
            
            // Check if destination is walkable
            if maze[newRow][newCol] == "." || maze[newRow][newCol] == "E" {
                // Update player position
                moves += 1
                maze[playerRow][playerCol] = "."
                
                // Check if player reached the exit
                if newRow == exitRow && newCol == exitCol {
                    solved = true
                }
                
                // Update player position
                playerRow = newRow
                playerCol = newCol
                maze[playerRow][playerCol] = "P"
                
                return true
            }
            
            return false
        }
        
        func display() -> String {
            var result = "\n"
            for row in 0..<height {
                for col in 0..<width {
                    let cell = maze[row][col]
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
            return result + "\nMoves: \(moves)\n"
        }
    }
    
    static func mazeGameInstructions() -> String {
        return """
        \n== MAZE GAME INSTRUCTIONS ==
        Find your way through the maze to the exit.
        
        Controls:
        - up/down/left/right: Move in that direction
        - q: Quit the maze game
        
        Legend:
        - ☺: Your position
        - ★: Exit
        - ■: Wall
        - ·: Path
        
        Reach the exit to win!
        """
    }
    
    static func slidingPuzzleInstructions() -> String {
        return """
        \n== SLIDING PUZZLE INSTRUCTIONS ==
        Rearrange the tiles in numerical order.
        
        Controls:
        - up/down/left/right: Slide a tile into the empty space
        - q: Quit the puzzle
        
        The empty space is represented by a blank.
        Arrange the numbers in order, with the empty space in the bottom-right corner.
        """
    }
    
    static func memoryGameInstructions() -> String {
        return """
        \n== MEMORY GAME INSTRUCTIONS ==
        Find all matching pairs of cards.
        
        Controls:
        - Enter row and column (e.g., "1 2") to reveal a card
        - q: Quit the memory game
        
        Find all matching pairs to win!
        """
    }
}