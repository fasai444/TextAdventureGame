// Update Sources/Models/Puzzle.swift
import Foundation

enum PuzzleType: String, Codable {
    case textSolution
    case slidingPuzzle
    case hangman
    case memoryMatch
    case mazeGame
}

struct Puzzle: Codable {
    let id: Int
    let description: String
    let solution: String
    let reward: String
    var isSolved: Bool
    let type: PuzzleType
    
    // Optional properties for specific puzzle types
    var puzzleData: [String: String]?
    
    // For backward compatibility with existing puzzles
    enum CodingKeys: String, CodingKey {
        case id, description, solution, reward, isSolved, type, puzzleData
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        solution = try container.decode(String.self, forKey: .solution)
        reward = try container.decode(String.self, forKey: .reward)
        isSolved = try container.decode(Bool.self, forKey: .isSolved)
        
        // Default to textSolution for backward compatibility
        type = try container.decodeIfPresent(PuzzleType.self, forKey: .type) ?? .textSolution
        puzzleData = try container.decodeIfPresent([String: String].self, forKey: .puzzleData)
    }
}