# Way of Shogun

A real-time strategy game blending Mount & Blade's directional combat with Total War-scale warfare, featuring an innovative information warfare system where truth is the ultimate weapon.

## Requirements

- Godot 4.2 or later

## Installation

1. Open Godot 4.2 or later
2. Import this project folder
3. Run the project

## Controls

### Movement
- **WASD** or **Arrow Keys**: Move character

### Combat
- **Space** or **Mouse Left Click**: Attack
- **Shift** or **Mouse Right Click**: Block

### Army Command
- **Left Click**: Select army
- **Right Click**: Move army to destination

### Meeting
- **M**: Call tactical meeting

## Running Tests

### Run all tests
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/ -gexit
```

### Run specific test
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/test_game_manager.gd -gexit
```

## CLI Debugging

### Run in headless mode
```bash
godot --headless --path ./
```

### Run with verbose logging
```bash
godot --headless --path ./ --verbose > debug.log
```

### Run with remote debugging
```bash
godot --headless --path ./ --remote-debug 127.0.0.1:6007
```

## Game Features (MVP)

### Combat System
- 4-directional attacks (North, East, South, West)
- Directional blocking system
- Stamina management
- Hit location-based damage multipliers (head: 1.5x, body: 1.0x, legs: 0.8x)

### Information Warfare
- Fog of war with visibility system
- Scout deployment for information retrieval
- Information accuracy based on distance and scout level
- Time-based information degradation

### Army Command
- Chess-style strategic map (50x50 tiles)
- Army movement with pathfinding
- Attack orders with combat calculations
- Basic enemy AI

### Meeting System
- Real-time tactical meetings
- 30-second decision timer
- Consequences for decisions
- Game continues at 50% speed during meetings

### Skill System
- Tactical Insight: +10% information accuracy per level
- Charisma: +5% ally combat effectiveness per level

## Performance Targets

- Minimum FPS: 30
- Target FPS: 60
- Maximum units per battle: 50
- Maximum units on map: 200
- Memory usage: Under 300MB

## Project Structure

```
res://
├── scenes/
│   └── main.tscn
├── scripts/
│   ├── main.gd
│   ├── game_manager.gd
│   ├── character.gd
│   ├── army.gd
│   ├── scout.gd
│   ├── meeting.gd
│   ├── skill_manager.gd
│   ├── input_manager.gd
│   └── audio_manager.gd
├── tests/
│   ├── test_game_manager.gd
│   ├── test_character.gd
│   └── test_army.gd
├── assets/
│   ├── sprites/
│   ├── audio/
│   └── fonts/
└── data/
    └── skills.json
```

## Development Status

Current Step: Step 1 - Godot Setup & Base Architecture

## License

MIT License
