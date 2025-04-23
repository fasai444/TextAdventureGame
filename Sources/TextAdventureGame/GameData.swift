import Foundation

// Wrapper struct to decode the "rooms" key
struct World: Codable {
    let rooms: [Room]
}

class GameData {
    static func loadWorld(from file: String) -> [Room] {
        let url = URL(fileURLWithPath: "Resources/\(file).json", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file).json")
        }
        let decoder = JSONDecoder()
        let world = try! decoder.decode(World.self, from: data)
        return world.rooms
    }

    static func savePlayer(_ player: Player, to file: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(player)
        let url = URL(fileURLWithPath: "Resources/\(file)", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
        try! data.write(to: url)
    }

    static func loadPlayer(from file: String) -> Player? {
        let url = URL(fileURLWithPath: "Resources/\(file)", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(Player.self, from: data)
    }
}