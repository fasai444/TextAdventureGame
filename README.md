# Text Adventure Game

A feature-rich console-based text adventure game built in Swift, featuring room exploration, puzzle solving, inventory management, and mini-games.

## Setup with Docker
1. Install Docker Desktop.
2. Clone the repository: `git clone <repo-url>`
3. Navigate to the project: `cd TextAdventureGame`
4. Run a Swift container: `docker run -v ${PWD}:/app -w /app -it swift:5.9 bash`
5. Build and run: `swift run`

## Game Features

### Core Features
- **World Exploration**: Navigate through 8 uniquely themed rooms including Entrance Hall, Library, Armory, Kitchen, Dining Hall, Garden, Tower, and Treasure Room.
- **Item Collection**: Find and use items to solve puzzles and progress through the game.
- **Character Interaction**: Talk to NPCs like the Guard and Chef to get hints and advance the story.
- **Puzzle Solving**: Solve various types of puzzles to progress.
- **Mini-Games**: Play integrated mini-games like Sliding Puzzle, Memory Match, and Maze.
- **Save System**: Your progress is automatically saved when you quit.
- **Score & Achievements**: Track your performance and accomplishments.

### Visual Elements
- ASCII art for rooms and game elements
- Text animations and transitions between rooms
- Color-coded interface elements for better readability
- Typewriter text effect for immersive storytelling

### Mini-Games
- **Sliding Puzzle**: Rearrange numbered tiles into the correct order
- **Memory Match**: Find matching pairs of cards
- **Maze Game**: Navigate through a randomly generated maze

## How to Play
1. Start the game and enter your name when prompted.
2. Explore rooms using directional commands.
3. Collect items you find along the way.
4. Interact with characters for clues.
5. Solve puzzles to unlock new areas.
6. Use items strategically to overcome obstacles.
7. Reach the Treasure Room and solve the final puzzle to win.

## Commands
- `go <direction>`: Move to another room (north, south, east, west, up, down)
- `take <item>`: Pick up an item
- `use <item>`: Use an item
- `talk to <character>`: Talk to a character
- `solve <solution>`: Solve a puzzle
- `play <mini-game>`: Play a mini-game (puzzle, memory, maze)
- `inventory`: View your collected items
- `map`: Show visited rooms and connections
- `help` or `?`: Show available commands
- `quit`: Save your progress and exit

## Game Structure
The game world is defined in JSON files:
- `world.json`: Contains room definitions, items, characters, and puzzles
- `save.json`: Stores player progress, inventory, and achievements

## Development Notes
The game is built using Swift and Swift Package Manager, with a focus on:
- Object-oriented design with clear separation of concerns
- JSON serialization for game data
- Console styling and animations for improved user experience
- Mini-game implementations to add gameplay variety
