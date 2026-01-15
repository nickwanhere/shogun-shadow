# Way of Shogun - Player Guide

**Version**: 1.0 (MVP Release)
**Last Updated**: January 15, 2026

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Basic Controls](#basic-controls)
3. [Core Mechanics](#core-mechanics)
4. [Gameplay Tips](#gameplay-tips)
5. [Understanding Systems](#understanding-systems)

---

## Getting Started

### System Requirements

- Godot 4.2 or later
- 1920x1080 display (recommended)
- Mouse and keyboard

### Installation

1. **Download**:
   - Clone repository or download ZIP
   - Extract to desired location

2. **Open Project**:
   - Launch Godot
   - Click "Import" and select `project.godot`
   - Wait for project import

3. **Run Game**:
   - Press F5 to play in editor
   - Or export as executable (see README)

---

## Basic Controls

### Movement

| Key | Action |
|-----|--------|
| W / Up Arrow | Move North |
| S / Down Arrow | Move South |
| A / Left Arrow | Move West |
| D / Right Arrow | Move East |

### Combat

| Key / Mouse | Action |
|-------------|--------|
| Space | Attack |
| Shift (hold) | Block |
| Left Click | Attack |
| Right Click (hold) | Block |

### Army Command

| Mouse | Action |
|-------|--------|
| Left Click (army) | Select army |
| Right Click (ground) | Move army |
| Right Click (enemy) | Attack enemy |

### Information Warfare

| Key | Action |
|-----|--------|
| S | Toggle Scout UI |
| Ctrl + Right Click | Deploy scout |
| I | Toggle Information Display |

### Meetings

| Key | Action |
|-----|--------|
| M | Call tactical meeting |
| 1, 2, 3 | Select decision option |

---

## Core Mechanics

### Combat System

**Directional Attacks**:
- Your facing direction determines attack direction
- 4 attack directions: North, South, East, West
- Move with WASD to change facing

**Blocking**:
- Hold Shift or Right Click to block
- Perfect parry: Block at exact moment of attack (0.1s window)
  - 100% damage negation
  - No stamina cost
- Partial block: Block early (0.3s window)
  - 50% damage reduction
  - Normal stamina cost

**Stamina**:
- Attacking costs stamina
- Blocking costs stamina (when hit)
- Regenerates slowly over time
- Manage stamina for sustained combat

**Hit Locations**:
- Head: 1.5x damage
- Body: 1.0x damage
- Legs: 0.8x damage

### Army Command

**Chess-Style Interface**:
- Armies displayed as icons on map
- Blue icons = your armies
- Red icons = enemy armies

**Selection**:
- Click your army to select
- Golden glow indicates selection
- Only one army selected at a time

**Movement**:
- Right-click to move selected army
- Army moves in straight line to destination
- Movement speed varies by unit type:
  - Cavalry: Fast (1.5x)
  - Infantry: Normal (1.0x)
  - Archers: Slow (0.8x)

**Combat**:
- Click enemy army while your army selected
- Combat calculated automatically:
  - Army Power = Unit Count × Morale / 100
  - Terrain bonuses apply
  - Four outcomes: Quick Victory, Victory, Stalemate, Defeat

**Terrain Effects**:
- Plains: No bonus
- Forest: +10% defense
- Mountains: +20% defense, -10% offense

### Information Warfare

**Fog of War**:
- Grey overlay = Unexplored
- Semi-transparent = Explored (fades over time)
- Clear = Currently visible

**Scouts**:
- Deploy scouts to gather information
- Cost: 50 gold per scout
- Max: 3 active scouts
- Click location to deploy (Ctrl + Right Click)
- Retrieval time: 10-50 seconds (based on distance)
- Accuracy: 65-95% (based on scout level)

**Information Display**:
- View gathered intelligence
- Filter by type
- See accuracy badges:
  - Green: High accuracy (≥85%)
  - Yellow: Medium accuracy (60-84%)
  - Red: Low accuracy (<60%)
- Auto-cleanup after 5 minutes

### Tactical Meetings

**Calling Meetings**:
- Press M to call tactical meeting
- Game slows to 50% speed during meeting
- Background fades/blurs

**Decision Timer**:
- 30 seconds to make decision
- Countdown displayed in top right
- Timeout = Random selection

**Decision Options** (Default):
1. **Charge Enemy**:
   - Aggressive attack
   - +20% attack power
   - -15% defense
   - -10% morale

2. **Defend Position**:
   - Defensive strategy
   - -10% attack power
   - +25% defense
   - 0% morale change

3. **Retreat to Castle**:
   - Strategic retreat
   - 0% attack/defense
   - -20% morale

**Consequences**:
- Apply immediately when selected
- Affect all your armies
- Last until next meeting

### Skill System

**Passive Skills**:
1. **Tactical Insight**:
   - +10% information accuracy per level
   - Affects scout and meeting information
   - Max level: 5

2. **Charisma**:
   - +5% ally combat effectiveness per level
   - Affects all your armies
   - Max level: 5

**Active Skills**:
- Mana-based system
- Mana: 100 max
- Regenerates 5 mana/second
- Cooldowns: 5-15 seconds

**Tactical Insight (Active)**:
- Cost: 0 mana
- Cooldown: 8 seconds
- Effect: Reveal all enemy units for 5 seconds
- +20% scout accuracy bonus

**Charisma (Active)**:
- Cost: 10 mana
- Cooldown: 15 seconds
- Duration: 60 seconds
- Effect: +15% morale to all armies
- +5% combat power

---

## Gameplay Tips

### Combat Tips

1. **Timing is Key**:
   - Learn enemy attack patterns
   - Perfect parry for zero damage
   - Block early to reduce damage

2. **Manage Stamina**:
   - Don't spam attacks
   - Block only when necessary
   - Retreat to recover stamina

3. **Watch Your Back**:
   - Position yourself carefully
   - Don't get surrounded
   - Use terrain for cover

### Army Command Tips

1. **Scout First**:
   - Deploy scouts before moving armies
   - Know enemy positions before attacking
   - Use information to plan attacks

2. **Use Terrain**:
   - Fight in mountains for defense bonus
   - Attack on plains for offense
   - Forest provides moderate defense

3. **Balance Morale**:
   - High morale = more combat power
   - Avoid repeated defeats
   - Use meetings to boost morale

4. **Exploit Weaknesses**:
   - Attack smaller armies
   - Attack weakened armies (low morale)
   - Use cavalry speed for surprise

### Information Warfare Tips

1. **Scout Strategically**:
   - Place scouts near objectives
   - Scout enemy territory
   - Monitor enemy army movements

2. **Verify Information**:
   - Cross-check multiple sources
   - Watch accuracy badges
   - Old information may be outdated

3. **Timing Matters**:
   - Deploy scouts before battles
   - Recall scouts during attacks
   - Update information frequently

### Meeting Tips

1. **Plan Ahead**:
   - Read current situation carefully
   - Consider information accuracy
   - Think about army positions

2. **Match Strategy**:
   - Charge: When you have advantage
   - Defend: When outnumbered
   - Retreat: When outmatched

3. **Use Skills**:
   - Active Charisma before battles
   - Tactical Insight for information
   - Time skills with meetings

---

## Understanding Systems

### Game State Structure

The game tracks:
- Player position, health, stamina
- All armies (yours and enemy)
- Scout deployments
- Gathered information
- Active meetings
- Skill levels and effects
- Combat events and history

### Event System

All actions generate events:
- Combat events (attacks, damage, defeats)
- Movement events (army moves)
- Information events (scout deployments)
- Meeting events (decisions)
- AI events (enemy decisions)

View events in console for debugging.

### AI Behavior

Enemy AI:
- Makes decisions every 5 seconds
- 40% chance to attack (if enemy nearby)
- 60% chance to move toward your territories
- Will retreat if significantly outnumbered

Use this to predict enemy actions.

---

## Advanced Strategies

### Blitzkrieg
1. Use Charisma active skill
2. Deploy scouts to find enemy
3. Call meeting, choose Charge Enemy
4. Attack immediately with all armies
5. Exploit morale boost

### Defensive Hold
1. Fortify in mountains
2. Use Defend Position meeting option
3. Scout enemy movements
4. Counter-attack when enemies attack

### Guerrilla Tactics
1. Deploy scouts everywhere
2. Use Tactical Insight to see enemies
3. Hit isolated enemy armies
4. Retreat before enemy reinforcements
5. Repeat

---

## Troubleshooting

### Game Not Responding
- Check FPS (should be 30+)
- Reduce graphics settings if needed
- Restart game if frozen

### Armies Not Moving
- Verify army is selected (golden glow)
- Check path is clear
- Right-click destination

### Scouts Not Deploying
- Check gold (need 50 gold)
- Verify not at max (3 scouts)
- Ctrl + Right Click to deploy

### Meetings Not Appearing
- Press M key
- Check if meeting already active
- Verify game not in cinematic

---

## Performance Tips

- **Godot**: Use Compatibility renderer (default)
- **Resolution**: 1920x1080 recommended
- **Backgrounds**: Close other applications
- **Memory**: Game uses ~50-100MB

---

## Next Steps

After mastering these mechanics:
1. Experiment with unit compositions
2. Develop personal strategies
3. Challenge higher difficulties (future updates)
4. Compete in multiplayer (future updates)

---

**Enjoy Way of Shogun!**

For technical support, see `README.md` or visit the GitHub repository.
