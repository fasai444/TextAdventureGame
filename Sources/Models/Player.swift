import Foundation

struct Player: Codable {
    let name: String
    var inventory: [Item]
    var currentRoom: Int
    var score: Int
    var achievements: [String]
}