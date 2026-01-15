# Way of Shogun - AI Debugging Guide

**Version**: 1.0
**Last Updated**: January 15, 2026

---

## Overview

This guide provides comprehensive information for debugging the game state and AI behavior using Godot's CLI and the GameManager singleton.

---

## Table of Contents

1. [CLI Commands](#cli-commands)
2. [Game State Inspection](#game-state-inspection)
3. [Event Logging](#event-logging)
4. [AI Debugging](#ai-debugging)
5. [Common Issues](#common-issues)

---

## CLI Commands

### Basic Commands

```bash
# Run game normally
godot --headless --path ./

# Run with verbose logging
godot --headless --path ./ --verbose > debug.log

# Run with remote debugging
godot --headless --path ./ --remote-debug 127.0.0.1:6007

# Run specific scene
godot --headless --path ./ --scene scenes/main.tscn

# Run with editor
godot --path ./
```

### Godot Path

- **Linux**: `/snap/bin/godot-4` (if installed via snap)
- **Windows**: `C:\Program Files\Godot\godot.exe`
- **macOS**: `/Applications/Godot.app/Contents/MacOS/Godot`

### Running Tests

```bash
# Run all tests (requires GUT addon)
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/ -gexit

# Run specific test
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/test_game_manager.gd -gexit
```

---

## Game State Inspection

### Exporting Game State

```gdscript
# In GDScript
var state = GameManager.export_state()
print(state)

# From CLI, you can inspect:
# - Player position
# - Player health/stamina
# - All armies
# - Scout deployments
# - Information sources
# - Current meeting
# - Skills and levels
# - Event history
```

### Key State Variables

#### Player State
```gdscript
GameManager.game_state["player_position"]  # Vector2 (grid coordinates)
GameManager.game_state["player_health"]     # int (0-100)
GameManager.game_state["player_max_health"]  # int
GameManager.game_state["player_stamina"]     # int (0-100)
GameManager.game_state["player_max_stamina"]  # int
GameManager.game_state["player_attack_direction"]  # int (0=N, 1=E, 2=S, 3=W)
GameManager.game_state["player_is_blocking"]   # bool
```

#### Army State
```gdscript
var armies = GameManager.game_state["armies"]
for army in armies:
    print("Army ID: ", army.army_id)
    print("Faction: ", army.faction_id)  # 0=player, 1=enemy
    print("Unit Count: ", army.unit_count)
    print("Unit Type: ", army.unit_type)  # "infantry", "cavalry", "archers"
    print("Morale: ", army.morale)
    print("Position: ", army.position)
    print("Selected: ", army.is_selected)
```

#### Information System
```gdscript
var scouts = GameManager.game_state["scouts"]
var info_sources = GameManager.game_state["information_sources"]

# Scout data
for scout in scouts:
    print("Scout ID: ", scout.scout_id)
    print("Faction: ", scout.faction_id)
    print("Position: ", scout.position)
    print("Level: ", scout.scout_level)
    print("State: ", scout.scout_state)

# Information data
for info in info_sources:
    print("Type: ", info.info_type)
    print("Accuracy: ", info.accuracy)
    print("Timestamp: ", info.timestamp)
```

#### Fog of War
```gdscript
var fog_data = GameManager.game_state["fog_of_war"]
# 50x50 array, each cell has:
# - visible (bool)
# - explored (bool)
# - last_seen (float)

# Check specific tile
var tile_x = 10
var tile_y = 15
var tile_info = fog_data[tile_x][tile_y]
print("Visible: ", tile_info.visible)
print("Explored: ", tile_info.explored)
```

#### Meeting State
```gdscript
var meeting = GameManager.game_state["current_meeting"]
if meeting:
    print("Type: ", meeting.type)
    print("Active: ", meeting.active)
    print("Timer: ", meeting.meeting_timer)
    print("Options: ", meeting.options)
    print("Selected: ", meeting.selected_option)
```

#### Skill State
```gdscript
var skills = GameManager.game_state["skills"]
for skill_name in skills:
    var skill = skills[skill_name]
    print("Skill: ", skill.name)
    print("Level: ", skill.level)
    print("Max Level: ", skill.max_level)
    print("Magnitude: ", skill.magnitude)
```

### State Modification

```gdscript
# Update player health
GameManager.update_player_health(75)

# Update player stamina
GameManager.update_player_stamina(90)

# Update player position
GameManager.update_player_position(Vector2(30, 25))

# Reveal fog of war
GameManager.reveal_fog_of_war(Vector2(25, 25), 5)

# Get skill effect
var tactical_bonus = GameManager.get_skill_effect("tactical_insight")
var charisma_bonus = GameManager.get_skill_effect("charisma")

# Get information accuracy
var accuracy = GameManager.get_information_accuracy()
```

---

## Event Logging

### Event Types

The game logs events for all major actions:

#### Movement Events
```gdscript
{
    "type": "move",
    "data": {
        "direction": "north",
        "position": Vector2(25, 24)
    },
    "timestamp": 1234567890.0
}
```

#### Combat Events
```gdscript
{
    "type": "combat",
    "data": {
        "direction": 0,
        "position": Vector2(800, 600),
        "damage": 15,
        "attacker": 0,
        "defender": 1
    },
    "timestamp": 1234567890.0
}
```

#### Army Events
```gdscript
{
    "type": "army_selected",
    "data": {
        "army_id": 0,
        "faction_id": 0,
        "unit_count": 75
    },
    "timestamp": 1234567890.0
}

{
    "type": "army_move",
    "data": {
        "army_id": 0,
        "from": Vector2(320, 320),
        "to": Vector2(640, 640),
        "path_length": 10
    },
    "timestamp": 1234567890.0
}

{
    "type": "battle_result",
    "data": {
        "attacker": 0,
        "defender": 3,
        "result": "victory"
    },
    "timestamp": 1234567890.0
}
```

#### Scout Events
```gdscript
{
    "type": "scout_manual_deploy",
    "data": {
        "scout_id": 0,
        "position": Vector2i(15, 20)
    },
    "timestamp": 1234567890.0
}

{
    "type": "information",
    "data": {
        "source": "scout_0",
        "info_type": "enemy_strength",
        "accuracy": 0.85
    },
    "timestamp": 1234567890.0
}
```

#### Meeting Events
```gdscript
{
    "type": "meeting",
    "data": {
        "type": "call_meeting"
    },
    "timestamp": 1234567890.0
}

{
    "type": "decision_consequences",
    "data": {
        "option": "Charge Enemy",
        "consequences": {
            "attack_power": 0.2,
            "defense": -0.15,
            "morale": -0.1
        }
    },
    "timestamp": 1234567890.0
}
```

#### AI Events
```gdscript
{
    "type": "ai_decision",
    "data": {
        "army_id": 3,
        "decision_type": "attack",
        "target": 0,
        "confidence": 0.8
    },
    "timestamp": 1234567890.0
}
```

### Accessing Event History

```gdscript
var events = GameManager.game_state["events"]

# Print all events
for event in events:
    print("Event: ", event.type)
    print("Data: ", event.data)
    print("Time: ", event.timestamp)

# Filter by type
var combat_events = []
for event in events:
    if event.type == "combat":
        combat_events.append(event)

# Get recent events (last 10)
var recent_events = events.slice(events.size() - 10, 10)
```

---

## AI Debugging

### Enemy AI State

```gdscript
var enemy_ai = get_node("/World/EnemyAI")

# Get AI state
var ai_state = enemy_ai.get_ai_state()
print("Enemy Count: ", ai_state.enemy_count)
print("Decision Timer: ", ai_state.decision_timer)
print("Decision Interval: ", ai_state.decision_interval)
```

### AI Decision Analysis

```gdscript
# AI decisions are logged to events
var ai_events = []
for event in GameManager.game_state["events"]:
    if event.type == "ai_decision":
        ai_events.append(event)

# Analyze decision patterns
var attack_count = 0
var move_count = 0
var idle_count = 0

for event in ai_events:
    match event.data.decision_type:
        "attack":
            attack_count += 1
        "move":
            move_count += 1
        "idle":
            idle_count += 1

print("Attack Decisions: ", attack_count)
print("Move Decisions: ", move_count)
print("Idle Decisions: ", idle_count)
```

### Army Path Analysis

```gdscript
var armies = GameManager.game_state["armies"]

for army in armies:
    print("Army ID: ", army.army_id)
    print("Path Length: ", army.path.size())
    print("Current Path Index: ", army.current_path_index)
    print("Is Moving: ", army.is_moving)
    
    # Print path waypoints
    for i in range(army.path.size()):
        print("  Waypoint ", i, ": ", army.path[i])
```

### Combat Analysis

```gdscript
var armies = GameManager.game_state["armies"]
var player_armies = []
var enemy_armies = []

for army in armies:
    if army.faction_id == 0:
        player_armies.append(army)
    else:
        enemy_armies.append(army)

# Calculate total power
var player_power = 0.0
var enemy_power = 0.0

for army in player_armies:
    player_power += army.get_combat_power()

for army in enemy_armies:
    enemy_power += army.get_combat_power()

print("Player Power: ", player_power)
print("Enemy Power: ", enemy_power)
print("Ratio: ", player_power / enemy_power if enemy_power > 0 else "INF")
```

### Information System Analysis

```gdscript
var info = GameManager.game_state["information_sources"]

# Information accuracy distribution
var high_accuracy = 0
var medium_accuracy = 0
var low_accuracy = 0

for info_item in info:
    if info_item.accuracy >= 0.85:
        high_accuracy += 1
    elif info_item.accuracy >= 0.60:
        medium_accuracy += 1
    else:
        low_accuracy += 1

print("High Accuracy Info: ", high_accuracy)
print("Medium Accuracy Info: ", medium_accuracy)
print("Low Accuracy Info: ", low_accuracy)

# Information age analysis
var current_time = Time.get_unix_time_from_system()
var recent_info = 0
var old_info = 0

for info_item in info:
    var age = current_time - info_item.timestamp
    if age < 60:  # Less than 1 minute
        recent_info += 1
    else:
        old_info += 1

print("Recent Info: ", recent_info)
print("Old Info: ", old_info)
```

---

## Common Issues

### Game Not Starting

**Symptom**: Game doesn't launch in CLI

**Solution**:
1. Verify Godot path is correct
2. Check project path exists
3. Ensure `project.godot` is present
4. Check for script errors in output

```bash
# Verify project structure
ls -la project.godot
ls -la scenes/main.tscn
ls -la scripts/game_manager.gd
```

### State Not Updating

**Symptom**: Game state doesn't change when actions occur

**Solution**:
1. Check GameManager singleton is loaded
2. Verify signals are connected
3. Check event logging for errors

```gdscript
# In game script
@onready var game_manager = GameManager

func _ready():
    # Verify GameManager is loaded
    if game_manager == null:
        print("ERROR: GameManager not loaded!")
    else:
        print("GameManager loaded successfully")
```

### AI Not Making Decisions

**Symptom**: Enemy AI armies not moving

**Solution**:
1. Check AI timer: should be 5.0 at reset
2. Verify AI process is running
3. Check enemy army count

```gdscript
# Debug AI
var enemy_ai = get_node("/World/EnemyAI")
print("AI Timer: ", enemy_ai.decision_timer)
print("AI Interval: ", enemy_ai.decision_interval)
print("Enemy Armies: ", enemy_ai.enemy_armies.size())
```

### Scouts Not Working

**Symptom**: Scouts don't deploy or retrieve information

**Solution**:
1. Check gold balance (need 50 gold)
2. Verify max scouts not exceeded (3)
3. Check scout deployment UI is visible
4. Verify Ctrl key is pressed

### Meetings Not Triggering

**Symptom**: Pressing M doesn't show meeting

**Solution**:
1. Check M key is working
2. Verify meeting system is loaded
3. Check if meeting already active
4. Verify UI panels exist

---

## Advanced Debugging

### Creating Custom Debug Scripts

Create `debug_tools.gd`:

```gdscript
extends Node

func _ready():
    add_debug_shortcuts()

func add_debug_shortcuts():
    print_debug_commands()

func _input(event):
    if event is InputEventKey and event.pressed:
        match event.keycode:
            KEY_F1:
                dump_game_state()
            KEY_F2:
                dump_armies()
            KEY_F3:
                dump_events()
            KEY_F4:
                reset_game()

func dump_game_state():
    print("=" * 60)
    print("GAME STATE DUMP")
    print("=" * 60)
    print(GameManager.game_state)

func dump_armies():
    print("=" * 60)
    print("ARMIES DUMP")
    print("=" * 60)
    var armies = GameManager.game_state["armies"]
    for army in armies:
        print("ID: ", army.army_id, "Faction: ", army.faction_id, 
              "Units: ", army.unit_count, "Morale: ", army.morale)

func dump_events():
    print("=" * 60)
    print("EVENTS DUMP (Last 20)")
    print("=" * 60)
    var events = GameManager.game_state["events"]
    var recent = events.slice(events.size() - 20, 20)
    for event in recent:
        print(event.type, " - ", event.data)

func reset_game():
    GameManager.initialize_game_state()
    print("Game state reset to default")
```

### Remote Debugging

1. Start Godot with remote debug:
```bash
godot --headless --path ./ --remote-debug 127.0.0.1:6007
```

2. Connect with Godot editor:
   - Open project in Godot
   - Project → Tools → Debugger
   - Connect to localhost:6007

3. Set breakpoints and inspect variables

---

## Performance Debugging

### FPS Monitoring

```gdscript
func _process(delta):
    var fps = Engine.get_frames_per_second()
    
    if fps < 30:
        print("WARNING: Low FPS: ", fps)
        GameManager.log_event("performance", {"fps": fps, "warning": true})
```

### Memory Profiling

```gdscript
func get_memory_usage():
    # Godot doesn't provide direct memory access
    # Use system monitoring tools
    pass

# Linux: use pmap or top
# Windows: use Task Manager
# macOS: use Activity Monitor
```

### Optimization Tips

1. **Reduce Fog Updates**:
   - Update fog every 0.5 seconds instead of every frame

2. **Optimize AI**:
   - Increase decision interval from 5s to 10s

3. **Limit Information Display**:
   - Show only last 10 information items

4. **Use Object Pooling**:
   - Reuse sprite objects instead of creating/destroying

---

## Expected Output Examples

### Normal Game Start
```
Godot Engine v4.5.1.stable.mono.official
[game_start] Starting game initialization
[game_start] Game initialized
[game_start] Player position: Vector2(25, 25)
[game_start] Creating armies...
[game_start] 5 armies created (2 player, 3 enemy)
[game_start] Enemy AI initialized
```

### Player Movement
```
[move] Direction: north
[move] Position: Vector2(25, 24)
```

### Combat Event
```
[combat] Attacker: 0, Defender: 1
[combat] Damage: 12
[combat] Attack direction: 2 (south)
```

### AI Decision
```
[ai_decision] Army: 3, Decision: move
[ai_decision] Target: Vector2(30, 25)
[ai_decision] Confidence: 0.7
```

---

## Summary

The Way of Shogun game state is fully accessible via the GameManager singleton. All major actions are logged as events for debugging and analysis.

**Key Takeaways**:
1. Use `GameManager.export_state()` for full state inspection
2. All events are logged with timestamps
3. AI decisions can be analyzed via event history
4. CLI commands allow headless debugging
5. Remote debugging available via Godot editor

For more information, see:
- `README.md` - Project overview
- `PLAYER_GUIDE.md` - Gameplay instructions
- `GDD/` folder - Complete game design documentation

---

**Document Version**: 1.0
**Last Updated**: January 15, 2026
