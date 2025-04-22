import Foundation

struct Puzzle: Codable {
    let id: Int
    let description: String
    let solution: String
    let reward: String
    var isSolved: Bool
}