# Way of Shogun - Core Systems

## 1. Simplified Combat System

### 1.1 Movement & Positioning

- **2D Perspective**: Isometric or top-down view
- **Grid-Based Movement**: Character moves on 1-tile grid for precision
- **Movement Controls**: WASD or arrow keys
- **Positioning Effects**:
  - Higher ground: +15% attack power, +10% defense
  - Flanking: +20% damage to enemy side/rear
  - Elevation: Can attack from 1 tile higher with range bonus

### 1.2 Directional Attacks

**Attack Directions (4 simplified)**:
- N (Up): Attack enemy in front
- E (Right): Attack enemy to right
- S (Down): Attack enemy behind
- W (Left): Attack enemy to left

**Attack Input**: Mouse position relative to character center determines direction

**Attack Types**:
- **Slash**: Wide arc (90°), medium damage, medium speed
- **Thrust**: Narrow arc (30°), long reach, low damage, fast
- **Overhead**: Narrow arc (45°), high damage, slow speed, can break blocks

**Attack Timing**:
- Windup: 0.3 seconds
- Attack: 0.2 seconds
- Recovery: 0.4 seconds
- Total: 0.9 seconds per attack

### 1.3 Blocking & Parrying

**Directional Blocking**:
- Block input matches attack direction (N/E/S/W)
- Block key held before attack windup starts

**Block Types**:
- **Perfect Parry** (0.1s window): Negates all damage, counter-attack opportunity
- **Partial Block** (0.3s window): Reduces damage by 50%
- **Failed Block** (after 0.3s): No damage reduction, takes full hit

**Shield Mechanics** (if applicable):
- Passive block from front 180° arc
- Shield durability: 100 points, decreases by 10 per blocked hit
- Broken shield: No passive block until repaired

### 1.4 Damage System

**Hitbox System**:
- Head: 1.5× damage multiplier
- Body: 1.0× damage multiplier
- Legs: 0.8× damage multiplier

**Armor Penetration**:
- Katana vs Light Armor: 1.2× damage
- Katana vs Heavy Armor: 0.8× damage
- Yari vs All Armor: 1.0× damage
- Katana vs Light Armor: 1.2× damage

**Critical Hit System**:
- Base chance: 10%
- Critical multiplier: 2.0× damage
- Backstab bonus: +5% critical chance

**Stamina System**:
- Maximum stamina: 100 points
- Attack cost: 15 stamina
- Block cost: 5 stamina per second while blocking
- Perfect parry cost: 25 stamina
- Stamina regeneration: 10 stamina per second (resting)

---

## 2. Information Warfare System (Simplified)

### 2.1 Fog of War Mechanics

**Visual Representation**:
- **Unexplored**: Black/complete darkness (no information)
- **Explored but Out of Sight**: Grey overlay (last known information)
- **Currently Visible**: Normal rendering (real-time information)

**Vision Radius**:
- Player character: 5 tiles (125px at 25px/tile)
- Scout units: 8 tiles (200px)
- Watchtowers: 12 tiles (300px)
- Information fog: Degrades 10% per minute

**Information Degradation**:
- Explored areas lose accuracy over time
- After 1 minute: 80% accuracy
- After 2 minutes: 60% accuracy
- After 5 minutes: 0% accuracy (reverts to unknown)

### 2.2 Information Sources & Costs

**Scout Units** (Free Deployment):
- Base retrieval time: 10 seconds
- Accuracy: 60-80% (varies by scout level)
- Cost: Free to deploy
- Risk: Can be captured/killed by enemy

**Informants (NPCs)**:
- Cost: 10-100 gold (varies by information complexity)
- Retrieval time: 30 seconds - 2 minutes
- Accuracy: 50-90% (varies by informant reliability)
- Risk: Can provide false information

**Captured Enemies**:
- Cost: 50 gold for interrogation
- Retrieval time: 1 minute
- Accuracy: 70%
- Risk: Limited by capture availability

### 2.3 Timing by Distance/Complexity

**Distance Formula**:
```
Base Time × Distance Multiplier × Complexity Multiplier

Distance Multipliers:
- Nearby (0-10 tiles): ×1.0
- Medium (11-25 tiles): ×2.5
- Far (26-50 tiles): ×5.0
```

**Complexity Multipliers**:
- Simple info (unit count): ×1.0
- Medium info (positions + types): ×1.5
- Complex info (formations + equipment): ×2.0
- Strategic info (intentions + plans): ×3.0

**Example Calculations**:
- Scout nearby, simple: 10s × 1.0 × 1.0 = 10 seconds
- Informant far, complex: 60s × 5.0 × 2.0 = 600 seconds (10 minutes)

### 2.4 Information Types (Simplified - MVP)

**1. Enemy Troop Positions** (Only type for MVP):
- What: Location of enemy armies on map
- Accuracy: Varies by source (60-90%)
- Retrieval time: 10s (scout) to 10min (informant)
- Visual: Army icons appear on map with uncertainty radius

---

## 3. Army Command System (Basic)

### 3.1 Chess-Style Map Interface

**Visual Style**:
- Ancient Japanese map aesthetic (ink wash style)
- Army pieces represented as stylized icons:
  - Kanji symbols (characters representing armies)
  - Banners/fans (traditional Japanese military symbols)
  - Faction colors (Azure Dragon: Blue, Crimson Phoenix: Red)

**Map Elements**:
- 50×50 tile grid (2,500 total tiles)
- Terrain: Plains (green), Forest (dark green), Mountains (grey)
- Settlements: Castles (large icon), Villages (small icon)
- Rivers (blue lines) and roads (brown lines)

**Interaction**:
- **Left Click**: Select army (highlighted with golden glow)
- **Right Click**: Move army to selected location
- **Drag**: Draw movement path for preview

### 3.2 Army Selection & Movement

**Army Data Structure**:
```
Army {
  faction_id: int
  army_id: int
  position: Vector2 (tile coordinates)
  unit_count: int
  unit_type: string (infantry/cavalry/archers)
  morale: int (0-100)
  supplies: int (0-100)
  is_selected: bool
}
```

**Movement Mechanics**:
- Pathfinding: Basic A* or direct line movement
- Movement speed: 1 tile per 2 seconds
- Terrain modifiers:
  - Plains: 1.0× speed (normal)
  - Forest: 0.7× speed (slower)
  - Mountains: 0.4× speed (very slow)
  - Roads: 1.5× speed (faster)

**Movement Feedback**:
- Selected army shows movement preview (dotted line)
- Estimated travel time displayed (e.g., "12 seconds")
- Path highlights tiles to be traversed

### 3.3 Attack Orders

**Combat Calculation** (Simplified):
```
Attacker Power = (unit_count × morale/100 × terrain_bonus)
Defender Power = (unit_count × morale/100 × terrain_bonus)

If Attacker Power > Defender Power × 1.5: Quick Victory (no losses)
If Attacker Power > Defender Power × 1.1: Victory (minor losses)
If Attacker Power ≈ Defender Power (0.9-1.1): Stalemate (moderate losses)
If Attacker Power < Defender Power × 0.9: Defeat (major losses)
```

**Attack Feedback**:
- Combat result displayed in floating text (Victory/Defeat/Stalemate)
- Unit count update shown
- Morale change indicated (+/-)

### 3.4 Basic Enemy AI

**AI Behavior**:
- **Idle**: Move armies toward player territories
- **Aggressive**: Attack player armies when in range (5 tiles)
- **Defensive**: Retreat to castle when army < 20% of original size

**AI Decision Frequency**:
- Every 5 seconds, AI evaluates army positions
- Randomized decision to avoid predictable patterns

---

## 4. Meeting System (Tactical Only)

### 4.1 Perch-Style Interface Design

**Interface Layout**:
```
+-------------------------------------------+
|  [PERCH - Tactical Meeting]           |
|  Time Remaining: 28 seconds            |
+-------------------------------------------+
|                                           |
|  CENTRAL PERCH (40%):                  |
|  +---------------------------+             |
|  | Current Battlefield     |             |
|  | Situation              |             |
|  | - Army positions        |             |
|  | - Terrain conditions    |             |
|  | - Morale status        |             |
|  +---------------------------+             |
|                                           |
|  LEFT PERCH (30%): RIGHT PERCH (30%):   |
|  +----------------+   +------------------+    |
|  | Available      |   | Decision Options |    |
|  | Information    |   |                 |    |
|  | - Scout report |   | 1. Charge       |    |
|  | - Enemy       |   |    Enemy        |    |
|  |   strength    |   |                 |    |
|  | (60% acc)    |   | 2. Defend       |    |
|  +----------------+   |    Position     |    |
|                     |                 |    |
|                     | 3. Retreat      |    |
|                     |                 |    |
|                     +------------------+    |
|                                           |
+-------------------------------------------+
```

**Visual Style**:
- Semi-transparent backgrounds (70% opacity)
- Ink wash aesthetic (black ink on parchment)
- Traditional Japanese patterns (asanoha, seigaiha)
- Muted color palette (red, gold, black, white, grey)

**Typography**:
- Traditional Japanese-inspired fonts
- Handwritten style for emphasis
- Clear, readable sizes (16px body, 20px headers)

### 4.2 Tactical Meetings

**Trigger Conditions**:
- Manual: Player clicks "Call Meeting" button
- Automatic:
  - Enemy army spotted nearby (5 tiles)
  - Ally morale drops below 40%
  - Scout returns with critical information

**Meeting Content**:
- Display current battlefield situation (army positions, morale, terrain)
- Show available information (scout reports, enemy strength with accuracy %)
- Present 3 decision options with consequences

**Decision Examples**:
1. **Charge Enemy**
   - Consequence: +20% attack power, -15% defense, -10% morale
2. **Defend Position**
   - Consequence: +25% defense, -10% attack power, morale unchanged
3. **Retreat to Castle**
   - Consequence: Safe retreat, -20% morale, lose territory

### 4.3 Real-Time Integration

**Game Speed During Meeting**:
- Background game continues at 50% normal speed
- Visual effect: Background fades/blurs slightly
- Audio: Ambient sounds continue at reduced volume

**Decision Timer**:
- 30-second countdown timer
- Visual: Progress bar at top of interface
- Audio: Ticking sound every 5 seconds
- Consequence: If timer expires, random decision selected

**Consequence Application**:
- Immediate effect on army stats (morale, attack/defense bonuses)
- Visual feedback: Stat changes shown with +/- indicators
- Background game state updates instantly

---

**Document Version**: 1.0
**Last Updated**: 2025-01-11
**Next Review**: After Step 3 completion
