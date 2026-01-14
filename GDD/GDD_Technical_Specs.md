# Way of Shogun - Technical Specifications

## 1. Engine Selection: Godot 4.x

### 1.1 Why Godot?

**CLI/AI Debugging Capabilities**:
- Native headless mode for automated testing
- Remote debugging over network
- Extensive command-line arguments
- GDScript accessibility for AI agents
- Open-source and free

**2D Capabilities**:
- Excellent TileMap and TileSet systems
- Built-in sprite animation support
- 2D physics engine
- Efficient rendering for 2D games

**Cross-Platform**:
- Windows, macOS, Linux support
- Web export (HTML5)
- Consistent behavior across platforms

**Community & Resources**:
- Active development community
- Extensive documentation
- Large asset library (free and paid)

### 1.2 Godot 4.x Setup with CLI/AI Debugging

**Required Version**: Godot 4.2 or later

**Project Setup Commands**:
```bash
# Create new project
godot --editor --path /path/to/project

# Run in headless mode (no GUI)
godot --headless --path /path/to/project

# Run with remote debugging
godot --headless --path /path/to/project --remote-debug 127.0.0.1:6007

# Run with verbose logging
godot --headless --path /path/to/project --verbose > debug.log

# Run with collision debugging
godot --headless --path /path/to/project --debug-collisions

# Run GUT tests (automated testing)
godot --headless -s addons/gut/gut_cmdln.gd -gexit
```

**AI Integration Commands**:
```bash
# Start game with AI debugging enabled
godot --headless --path ./ --remote-debug 127.0.0.1:6007

# Export game state to JSON for AI analysis
godot --headless --path ./ --export-state state.json

# Run automated tests
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/combat_test.gd -gexit

# Log all debug output
godot --headless --path ./ --verbose --debug-level 4 > full_debug.log
```

### 1.3 AI-Friendly Architecture

**GDScript for Accessibility**:
- Python-like syntax (familiar to AI)
- Clear variable naming conventions
- Extensive logging system
- Singleton GameManager for state inspection

**GameManager Singleton**:
```gdscript
# GameManager.gd
extends Node
signal game_state_changed()
signal combat_event(event_data: Dictionary)
signal information_received(info: Dictionary)

# Game state accessible to AI
var game_state: Dictionary = {
    "player_position": Vector2.ZERO,
    "armies": [],
    "fog_of_war": [],
    "information_sources": [],
    "current_meeting": null,
    "skills": {}
}

func export_state() -> Dictionary:
    """Export current game state for AI analysis"""
    return game_state.duplicate(true)

func import_state(state: Dictionary) -> void:
    """Import game state from AI analysis"""
    game_state = state.duplicate(true)
    apply_state_changes()

func log_event(event_type: String, data: Dictionary) -> void:
    """Log game events for AI debugging"""
    print("[%s] %s" % [event_type, str(data)])
    game_state["events"].append({
        "type": event_type,
        "data": data,
        "timestamp": Time.get_unix_time_from_system()
    })
```

**State Inspection**:
```gdscript
# AI can inspect any game state
var current_state = GameManager.game_state
print("Player position: " + str(current_state["player_position"]))
print("Active armies: " + str(len(current_state["armies"])))
print("Fog of war coverage: " + str(len(current_state["fog_of_war"])))
```

---

## 2. Performance Targets

### 2.1 Frame Rate

**Minimum Target**: 30 FPS
**Target**: 60 FPS
**Measurement**:
```gdscript
func _process(delta: float) -> void:
    var fps = Engine.get_frames_per_second()
    if fps < 30:
        print("WARNING: Low FPS detected: " + str(fps))
        GameManager.log_event("performance", {"fps": fps, "warning": true})
```

**Optimization Strategies**:
- LOD (Level of Detail) for distant units
- Sprite instancing for repeated assets
- Tile culling (render only visible tiles)
- Object pooling for units and projectiles

### 2.2 Unit Count

**Maximum Units per Battle**: 50
**Maximum Units on Map**: 200 (including armies, scouts, etc.)
**Performance Scaling**:
```
10 units: 60 FPS (baseline)
25 units: 55 FPS
50 units: 45 FPS (minimum target)
100 units: 30 FPS (acceptable)
200 units: 20 FPS (warning - consider LOD)
```

### 2.3 Map Size

**Tile Count**: 50×50 = 2,500 tiles
**Visible Tiles**: ~200 tiles (depends on zoom level)
**Rendering Strategy**:
- Tile-based rendering with TileMap
- Only render visible tiles (viewport culling)
- Cache frequently accessed tiles

### 2.4 Memory Usage

**Target**: Under 300MB for full game state
**Breakdown**:
- Sprites and textures: ~100MB
- Game data (units, armies, etc.): ~50MB
- Audio buffers: ~50MB
- Godot engine overhead: ~100MB

**Memory Monitoring**:
```gdscript
func check_memory() -> void:
    var memory_usage = OS.get_static_memory_usage_by_type(OS.MEMORY_STATIC)
    print("Memory usage: " + str(memory_usage / (1024 * 1024)) + " MB")
    if memory_usage > 300 * 1024 * 1024:  # 300MB
        print("WARNING: High memory usage detected")
```

---

## 3. System Architecture

### 3.1 Core Systems

**System Hierarchy**:
```
GameManager (Singleton)
├── CombatSystem
│   ├── CharacterManager
│   ├── AttackManager
│   ├── BlockManager
│   └── DamageManager
├── InformationSystem
│   ├── FogOfWarManager
│   ├── ScoutManager
│   ├── InformantManager
│   └── InformationTracker
├── ArmyCommandSystem
│   ├── ArmyManager
│   ├── PathfindingManager
│   ├── FormationManager (deferred)
│   └── AIController
├── MeetingSystem
│   ├── MeetingManager
│   ├── DecisionManager
│   └── TimerManager
└── SkillSystem
    ├── SkillManager
    ├── ExperienceManager
    └── SkillUIManager
```

### 3.2 Scene Hierarchy

```
Main (Scene)
├── GameUI (Control)
│   ├── PerchInterface (Control)
│   ├── SkillPanel (Control)
│   └── InformationPanel (Control)
├── World (Node2D)
│   ├── TileMap (TileMap)
│   ├── Armies (Node2D)
│   │   ├── Army1 (Sprite2D)
│   │   ├── Army2 (Sprite2D)
│   │   └── ...
│   ├── PlayerCharacter (Character)
│   └── Effects (Node2D)
└── Audio (AudioStreamPlayer)
```

### 3.3 Data Structures

**Character Data**:
```gdscript
# Character.gd
class CharacterData:
    var position: Vector2
    var health: int
    var max_health: int
    var stamina: int
    var max_stamina: int
    var attack_direction: int  # 0-3 (N, E, S, W)
    var is_blocking: bool
    var skills: Array
```

**Army Data**:
```gdscript
# Army.gd
class ArmyData:
    var army_id: int
    var faction_id: int
    var position: Vector2
    var unit_count: int
    var unit_type: String  # "infantry", "cavalry", "archers"
    var morale: int
    var supplies: int
    var is_selected: bool
    var path: Array  # Movement path
```

**Information Data**:
```gdscript
# Information.gd
class InformationData:
    var info_id: int
    var info_type: String  # "troop_positions", etc.
    var data: Dictionary
    var accuracy: float  # 0.0-1.0
    var source: String  # "scout", "informant", "captured_enemy"
    var timestamp: int
    var is_verified: bool
```

**Skill Data**:
```gdscript
# Skill.gd
class SkillData:
    var skill_id: int
    var name: String
    var description: String
    var skill_type: String  # "passive", "active"
    var magnitude: float
    var duration: float
    var range: float
    var level: int
    var max_level: int
    var carry_over_percentage: float
```

---

## 4. MVP Technical Requirements

### 4.1 Engine Requirements

**Godot Version**: 4.2 or later
**Renderer**: Compatibility renderer (best compatibility)
**Physics**: 2D physics engine (limited use)
**Audio**: OpenAL backend

### 4.2 Scripting

**Primary Language**: GDScript
**Secondary Language**: C# (if needed for complex algorithms)
**Scripting Standards**:
- Clear variable naming (snake_case)
- Type hints for all functions
- Extensive documentation comments
- Error handling with try/catch

**Code Example**:
```gdscript
# Character.gd
extends CharacterBody2D

const MAX_HEALTH: int = 100
const MAX_STAMINA: int = 100
const BASE_DAMAGE: int = 10

var health: int = MAX_HEALTH
var stamina: int = MAX_STAMINA
var attack_direction: int = 0  # 0: North, 1: East, 2: South, 3: West

func take_damage(damage: int) -> void:
    """Take damage from enemy attack"""
    health -= damage
    if health <= 0:
        die()
    else:
        GameManager.log_event("damage", {
            "damage": damage,
            "remaining_health": health
        })

func attack() -> void:
    """Execute attack in current direction"""
    if stamina < 15:  # Attack cost
        print("Not enough stamina!")
        return

    stamina -= 15
    var attack_time: float = 0.9  # Total attack time
    apply_attack_damage()

func apply_attack_damage() -> void:
    """Apply damage based on attack direction"""
    var enemies: Array = get_enemies_in_range(attack_direction)
    for enemy in enemies:
        var damage: int = calculate_damage()
        enemy.take_damage(damage)

func calculate_damage() -> int:
    """Calculate damage with multipliers"""
    var base_damage: int = BASE_DAMAGE
    var hit_location: String = get_hit_location()
    var hit_multiplier: float = get_hit_multiplier(hit_location)
    return int(base_damage * hit_multiplier)

func get_hit_multiplier(location: String) -> float:
    """Get damage multiplier based on hit location"""
    match location:
        "head":
            return 1.5
        "body":
            return 1.0
        "legs":
            return 0.8
        _:
            return 1.0
```

### 4.3 Rendering

**2D Renderer**:
- TileMap for world rendering
- Sprite2D for characters and armies
- Control nodes for UI

**Resolution**:
- Minimum: 1280×720
- Target: 1920×1080
- Scaling: Integer scaling (pixel-perfect)

### 4.4 Input

**Controls**:
- **Movement**: WASD or Arrow keys
- **Attack**: Spacebar or Mouse Left Click
- **Block**: Shift or Mouse Right Click (hold)
- **Select Army**: Left Click
- **Move Army**: Right Click
- **Call Meeting**: 'M' key or UI button

**Input Handling**:
```gdscript
# InputManager.gd
extends Node

func _input(event: InputEvent) -> void:
    if event is InputEventKey:
        handle_key_input(event)
    elif event is InputEventMouseButton:
        handle_mouse_input(event)

func handle_key_input(event: InputEventKey) -> void:
    if event.pressed:
        match event.scancode:
            KEY_W, KEY_UP:
                move_player("north")
            KEY_S, KEY_DOWN:
                move_player("south")
            KEY_A, KEY_LEFT:
                move_player("west")
            KEY_D, KEY_RIGHT:
                move_player("east")
            KEY_SPACE:
                attack()
            KEY_M:
                call_meeting()
```

### 4.5 Audio

**Audio Formats**:
- **Music**: Ogg Vorbis (.ogg)
- **Sound Effects**: Ogg Vorbis (.ogg) or WAV (.wav)

**Audio System**:
```gdscript
# AudioManager.gd
extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func play_music(track_path: String) -> void:
    music_player.stream = load(track_path)
    music_player.play()

func play_sfx(sound_path: String) -> void:
    sfx_player.stream = load(sound_path)
    sfx_player.play()

func set_volume(volume_db: float) -> void:
    music_player.volume_db = volume_db
    sfx_player.volume_db = volume_db
```

---

## 5. Project Structure

### 5.1 Directory Layout

```
res://
├── scenes/
│   ├── main.tscn              # Main game scene
│   ├── combat.tscn            # Combat scene
│   ├── map.tscn               # Strategic map scene
│   ├── meeting.tscn            # Meeting UI scene
│   └── ui/
│       ├── skill_panel.tscn
│       └── information_panel.tscn
├── scripts/
│   ├── main.gd                # Main game logic
│   ├── game_manager.gd         # Game state management
│   ├── character.gd            # Character system
│   ├── army.gd                 # Army system
│   ├── information.gd           # Information system
│   ├── meeting.gd              # Meeting system
│   ├── skill.gd                 # Skill system
│   └── ai/
│       ├── army_ai.gd          # Army AI behavior
│       └── pathfinding.gd       # Pathfinding algorithms
├── assets/
│   ├── sprites/
│   │   ├── characters/
│   │   ├── armies/
│   │   └── ui/
│   ├── tilesets/
│   │   ├── plains.png
│   │   ├── forest.png
│   │   └── mountains.png
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   └── fonts/
├── data/
│   ├── skills.json             # Skill definitions
│   ├── units.json              # Unit stats
│   └── balance.json            # Game balance parameters
└── addons/
    ├── gut/                   # GUT testing framework
    └── ...
```

### 5.2 Configuration Files

**skills.json**:
```json
{
  "skills": [
    {
      "skill_id": 1,
      "name": "Tactical Insight",
      "description": "+10% information accuracy per level",
      "skill_type": "passive",
      "magnitude": 0.1,
      "range": 0.0,
      "level": 1,
      "max_level": 5,
      "carry_over_percentage": 0.5
    },
    {
      "skill_id": 2,
      "name": "Charisma",
      "description": "+5% ally combat power per level",
      "skill_type": "passive",
      "magnitude": 0.05,
      "range": 5.0,
      "level": 1,
      "max_level": 5,
      "carry_over_percentage": 0.6
    }
  ]
}
```

**units.json**:
```json
{
  "units": [
    {
      "unit_id": 1,
      "name": "Infantry",
      "type": "infantry",
      "health": 100,
      "attack_power": 10,
      "defense": 5,
      "movement_speed": 1.0,
      "cost_gold": 10,
      "cost_food": 0
    },
    {
      "unit_id": 2,
      "name": "Cavalry",
      "type": "cavalry",
      "health": 120,
      "attack_power": 15,
      "defense": 8,
      "movement_speed": 1.5,
      "cost_gold": 25,
      "cost_food": 0
    },
    {
      "unit_id": 3,
      "name": "Archer",
      "type": "archers",
      "health": 80,
      "attack_power": 12,
      "defense": 3,
      "movement_speed": 0.8,
      "cost_gold": 15,
      "cost_food": 0
    }
  ]
}
```

---

## 6. Debugging & Testing

### 6.1 GUT Testing Framework

**Setup**:
```bash
# Install GUT addon
cd addons/
git clone https://github.com/bitwes/Gut.git
```

**Test Example**:
```gdscript
# res://tests/combat_test.gd
extends GutTest

var combat_system: CombatSystem

func before_each() -> void:
    combat_system = CombatSystem.new()
    add_child_autofree(combat_system)

func test_attack_damage() -> void:
    var damage: int = combat_system.calculate_damage(10, "body")
    assert_eq(damage, 10, "Body hit should be 10 damage")

func test_critical_hit() -> void:
    var damage: int = combat_system.calculate_damage(10, "head")
    assert_eq(damage, 15, "Head hit should be 15 damage (1.5x multiplier)")

func test_leg_hit() -> void:
    var damage: int = combat_system.calculate_damage(10, "legs")
    assert_eq(damage, 8, "Leg hit should be 8 damage (0.8x multiplier)")
```

**Run Tests**:
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/ -gexit
```

### 6.2 CLI Debugging Commands

**State Inspection**:
```bash
# Export current game state
godot --headless --path ./ --export-state state.json

# View specific system state
godot --headless --path ./ --inspect-system combat

# View fog of war coverage
godot --headless --path ./ --inspect-fog
```

**Performance Monitoring**:
```bash
# Monitor FPS
godot --headless --path ./ --monitor-fps 60

# Monitor memory usage
godot --headless --path ./ --monitor-memory 300

# Generate performance report
godot --headless --path ./ --performance-report > perf_report.txt
```

**Automated Testing**:
```bash
# Run all tests
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/ -gexit

# Run specific test
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/combat_test.gd -gexit

# Generate test report
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/ -gjunit report.xml
```

---

**Document Version**: 1.0
**Last Updated**: 2025-01-11
**Next Review**: After Step 1 completion
