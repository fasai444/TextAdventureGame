# Text Adventure Game

A console-based text adventure game built in Swift.

## Setup with Docker
1. Install Docker Desktop.
2. Clone the repository: `git clone <repo-url>`
3. Navigate to the project: `cd TextAdventureGame`
4. Run a Swift container: `docker run -v ${PWD}:/app -w /app -it swift:5.9 bash`
5. Build and run: `swift run`

## How to Play
- Enter your name to start.
- Use commands like `go north`, `take key`, `use key`, `talk to guard`, `solve <solution>`.
- Type `help` for commands.
- Objective: Explore 8 rooms, solve 4 puzzles, and reach the Treasure Room to win.

## Commands
- `go <direction>`: Move to another room.
- `take <item>`: Pick up an item.
- `use <item>`: Use an item.
- `talk to <character>`: Talk to a character.
- `solve <solution>`: Solve a puzzle.
- `inventory`: View inventory.
- `map`: Show visited rooms.
- `help` or `?`: Show commands.
- `quit`: Save and exit.