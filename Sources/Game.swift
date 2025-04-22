import Foundation
import Graphics
class Game {
    var rooms: [Room]
    var player: Player
    var isRunning = true

    init() {
        rooms = GameData.loadWorld(from: "world")
        if let savedPlayer = GameData.loadPlayer(from: "save.json") {
            player = savedPlayer
        } else {
            print("Enter your name: ")
            let name = readLine() ?? "Adventurer"
            player = Player(name: name, inventory: [], currentRoom: 1, score: 0, achievements: [])
        }
    }

    func run() {
    // Display the title with animation
    AnimationManager.clearScreen()
    print(ConsoleStyle.colorize(AsciiArt.titleArt, with: .cyan))
    AnimationManager.typeText(ConsoleStyle.colorize("Welcome to the Adventure Game, \(player.name)!", with: .bold), speed: 0.03)
    print("Type 'help' for commands.")
    
    // Show loading animation
    AnimationManager.showLoadingAnimation(message: "Loading game world", duration: 1.5)
    
    while isRunning {
        let currentRoom = rooms.first { $0.id == player.currentRoom }!
        
        // Display room ASCII art
        if let roomArt = AsciiArt.roomArt[currentRoom.id] {
            print(ConsoleStyle.colorize(roomArt, with: .cyan))
        }
        
        // Display room information with styling
        print(ConsoleStyle.roomName(currentRoom.name))
        AnimationManager.typeText(currentRoom.description, speed: 0.01)
        
        // Display exits with styling
        print("\nExits: " + currentRoom.exits.keys.map { ConsoleStyle.commandText($0) }.joined(separator: ", "))
        
        // Display items with styling
        if !currentRoom.items.isEmpty {
            print("Items: " + currentRoom.items.map { ConsoleStyle.itemName($0.name) }.joined(separator: ", "))
        }
        
        // Display characters with styling
        if let characters = currentRoom.characters, !characters.isEmpty {
            print("Characters: " + characters.map { ConsoleStyle.characterName($0.name) }.joined(separator: ", "))
        }
        
        // Display puzzle with styling
        if let puzzle = currentRoom.puzzle, !puzzle.isSolved {
            print("\nPuzzle: " + ConsoleStyle.puzzleText(puzzle.description))
        }

        print("\n" + ConsoleStyle.importantMessage("What do you want to do?"))
        
        // Custom prompt
        print(ConsoleStyle.colorize("> ", with: .green), terminator: "")
        let input = readLine()?.lowercased() ?? ""
        parseCommand(input)
    }
}

    func parseCommand(_ input: String) {
        let components = input.split(separator: " ").map { String($0) }
        guard !components.isEmpty else {
            print("Please enter a command.")
            return
        }

        switch components[0] {
        case "go":
            if components.count > 1, let room = move(to: components[1]) {
                player.currentRoom = room.id
                player.achievements.append("Visited room \(room.id)")
            } else {
                print("Invalid direction. Try 'go north', 'go south', etc.")
            }
        case "take":
            if components.count > 1 {
                takeItem(named: components[1])
            } else {
                print("What do you want to take?")
            }
        case "use":
            if components.count > 1 {
                useItem(named: components.dropFirst().joined(separator: " "))
            } else {
                print("What do you want to use?")
            }
        case "talk":
            if components.count > 1 {
                talkTo(character: components.dropFirst().joined(separator: " "))
            } else {
                print("Who do you want to talk to?")
            }
        case "solve":
            if components.count > 1 {
                solvePuzzle(with: components.dropFirst().joined(separator: " "))
            } else {
                print("What is the solution?")
            }
        case "inventory":
            print("Inventory: \(player.inventory.map { $0.name }.joined(separator: ", "))")
        case "map":
            showMap()
        case "help", "?":
            print("""
            Available commands:
            - go <direction> (e.g., go north)
            - take <item> (e.g., take key)
            - use <item> (e.g., use key)
            - talk to <character> (e.g., talk to guard)
            - solve <solution> (e.g., solve open sesame)
            - inventory
            - map
            - help or ?
            - quit
            """)
        case "quit":
            GameData.savePlayer(player, to: "save.json")
            print("Game saved. Goodbye!")
            isRunning = false
        default:
            print("Unknown command. Type 'help' for a list of commands.")
        }
    }

    func move(to direction: String) -> Room? {
    let currentRoom = rooms.first { $0.id == player.currentRoom }!
    if let nextRoomId = currentRoom.exits[direction], let nextRoom = rooms.first(where: { $0.id == nextRoomId }) {
        // Show transition animation
        AnimationManager.animate(frames: AsciiArt.transitionFrames, frameDuration: 0.15)
        
        print(ConsoleStyle.successMessage("You moved to \(nextRoom.name)."))
        player.score += 10
        return nextRoom
    }
    return nil
}

    func takeItem(named name: String) {
        guard let roomIndex = rooms.firstIndex(where: { $0.id == player.currentRoom }) else { return }
        if let itemIndex = rooms[roomIndex].items.firstIndex(where: { $0.name.lowercased() == name && $0.canTake }) {
            let item = rooms[roomIndex].items.remove(at: itemIndex)
            player.inventory.append(item)
            player.score += 20
            print("You took the \(item.name).")
        } else {
            print("Cannot take \(name).")
        }
    }

    func useItem(named name: String) {
        if player.inventory.contains(where: { $0.name.lowercased() == name }) {
            print("You used the \(name).")
            if name.lowercased() == "rope with hook", let roomIndex = rooms.firstIndex(where: { $0.id == player.currentRoom }), let puzzle = rooms[roomIndex].puzzle, puzzle.id == 3 {
                solvePuzzle(with: "rope with hook")
            }
        } else {
            print("You don't have a \(name).")
        }
    }

    func talkTo(character name: String) {
    let currentRoom = rooms.first { $0.id == player.currentRoom }!
    if let character = currentRoom.characters?.first(where: { $0.name.lowercased() == name }) {
        print("\(ConsoleStyle.characterName(character.name)): ", terminator: "")
        AnimationManager.typeText(character.dialogue)
        player.score += 10
    } else {
        print(ConsoleStyle.errorMessage("No such character here."))
    }
}

    func solvePuzzle(with solution: String) {
        guard let roomIndex = rooms.firstIndex(where: { $0.id == player.currentRoom }),
              let puzzle = rooms[roomIndex].puzzle, !puzzle.isSolved else {
            print("No puzzle to solve here.")
            return
        }
        if solution.lowercased() == puzzle.solution.lowercased() {
            rooms[roomIndex].puzzle?.isSolved = true
            player.score += 50
            player.achievements.append("Solved puzzle: \(puzzle.id)")
            print("Puzzle solved! You received \(puzzle.reward).")
            if player.currentRoom == 8 && puzzle.id == 4 {
                print("Congratulations, \(player.name)! You completed the adventure!")
                print("Score: \(player.score)")
                print("Achievements: \(player.achievements.joined(separator: ", "))")
                isRunning = false
            }
        } else {
            print("Incorrect solution.")
        }
    }

    func showMap() {
        let visitedRooms = rooms.filter { player.achievements.contains("Visited room \($0.id)") || $0.id == player.currentRoom }
        print("Map:")
        for room in visitedRooms {
            let isCurrent = room.id == player.currentRoom ? " (You are here)" : ""
            print("- \(room.name)\(isCurrent)")
            print("  Exits: \(room.exits.keys.joined(separator: ", "))")
        }
    }
}