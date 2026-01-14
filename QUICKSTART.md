# Quick Start Guide - Way of Shogun

## Installation

### Prerequisites
1. Download and install Godot 4.2 or later from https://godotengine.org/download
2. Clone/download the GUT testing framework: https://github.com/bitwes/Gut.git

### Setup GUT Testing Framework
```bash
cd res/addons/gut
git clone https://github.com/bitwes/Gut.git .
```

### Open Project
1. Launch Godot
2. Click "Import" and select the `project.godot` file
3. Wait for project to import

## Running the Game

### In Godot Editor
1. Click the "Play" button (F5) to run the game

### From Command Line
```bash
# Run normally
godot --path ./

# Run in headless mode (no GUI)
godot --headless --path ./

# Run with verbose logging
godot --headless --path ./ --verbose > debug.log
```

## Running Tests

### Run All Tests
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/ -gexit
```

### Run Specific Test
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/test_game_manager.gd -gexit
```

## Controls

| Action | Keyboard | Mouse |
|--------|----------|-------|
| Move North | W / Up Arrow | - |
| Move South | S / Down Arrow | - |
| Move East | D / Right Arrow | - |
| Move West | A / Left Arrow | - |
| Attack | Space | Left Click |
| Block | Shift (hold) | Right Click (hold) |
| Call Meeting | M | - |

## Game Features Currently Implemented

### Step 1: Base Architecture ✅
- Project structure created
- Scene hierarchy set up
- GameManager singleton with state management
- Input and Audio managers
- GUT testing framework setup
- Placeholder assets

### Core Systems
- **Combat System**: Directional attacks, blocking, damage calculation
- **Information System**: Fog of war, scout deployment
- **Army Command**: Movement, selection, pathfinding
- **Meeting System**: Tactical meetings with timer
- **Skill System**: Two passive skills with level progression

## Debugging

### View Game State
The game state is accessible via GameManager singleton:

```gdscript
var state = GameManager.export_state()
print(state["player_position"])
print(state["armies"])
```

### Event Logging
All game events are logged:
```gdscript
GameManager.log_event("my_event", {"data": "value"})
```

## Next Steps

After completing Step 1 verification, continue to:

1. **Step 2**: Combat System Implementation (animations, hitbox system)
2. **Step 3**: Information System (scout mechanics, UI)
3. **Step 4**: Army Command (AI, advanced pathfinding)
4. **Step 5**: Meeting System (decision consequences)
5. **Step 6**: Skill System (active skills, progression)

Refer to `IMPLEMENTATION_SUMMARY.md` for detailed status.

## Troubleshooting

### Project won't open in Godot
- Ensure you have Godot 4.2 or later installed
- Check that `project.godot` is in the root directory

### Tests fail to run
- Verify GUT addon is installed in `res/addons/gut`
- Check that test files are in `res/tests/`

### No graphics display
- Placeholder textures are used intentionally
- Assets will be added in Step 7

### Game runs slowly
- Check FPS in debug output
- Verify you're using Compatibility renderer
- Check for memory leaks in output

## Support

For detailed specifications, see:
- `README.md` - Project overview
- `IMPLEMENTATION_SUMMARY.md` - Detailed implementation status
- `GDD/` folder - Complete Game Design Document
