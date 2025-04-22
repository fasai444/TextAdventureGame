import Foundation

struct Room: Codable {
    let id: Int
    let name: String
    let description: String
    let exits: [String: Int]
    var items: [Item] // Changed from let to var
    let characters: [Character]?
    var puzzle: Puzzle? // Changed from let to var
}