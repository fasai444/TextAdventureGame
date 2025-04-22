## Text Adventure Game Report

### Design Choices
- Used Swift structs with Codable for JSON serialization to manage game data efficiently.
- Implemented a command parser that splits input for flexible command handling.
- Stored world data in `world.json` and player progress in `save.json` for persistence.

### Data Types
- Structs: `Room`, `Item`, `Character`, `Puzzle`, `Player` for game entities.
- Arrays and dictionaries for dynamic data like exits and inventory.

### Challenges
- Loading JSON resources in Swift Package Manager.
- Handling invalid user inputs gracefully.
- Designing varied, engaging puzzles.

### Solutions
- Used `Bundle.module` for resource access in Swift packages.
- Implemented input validation with descriptive error messages.
- Created four puzzles: password, riddle, item combination, and a final question.

### Development Environment
Developed using Docker Desktop with the `swift:5.9` image on Windows for a consistent environment.