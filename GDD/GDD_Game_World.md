# Way of Shogun - Game World & Setting

## 1. Single Region Map Design

### 1.1 Map Overview

**Geographic Size**:
- Dimensions: 50×50 tiles (2,500 total tiles)
- Tile Size: 25 pixels × 25 pixels
- Total Map Size: 1,250×1,250 pixels (scaled to display)

**Map Boundaries**:
- Edge tiles are impassable (mountains or ocean)
- Player starts in center-right area
- Enemy factions start in opposing corners

### 1.2 Terrain Types

**Plains** (40% of map):
- **Color**: Light green (#90EE90)
- **Movement Modifier**: 1.0× (normal speed)
- **Combat Modifier**: No bonus/penalty
- **Visual**: Simple grass texture with occasional flowers
- **Strategic Value**: High (fast movement, open terrain)

**Forest** (30% of map):
- **Color**: Dark green (#228B22)
- **Movement Modifier**: 0.7× (slower movement)
- **Combat Modifier**: +15% defense (cover bonus)
- **Visual**: Stylized pine trees (3-4 variations)
- **Strategic Value**: Medium (defensive advantage, ambush opportunities)

**Mountains** (20% of map):
- **Color**: Grey (#808080)
- **Movement Modifier**: 0.4× (very slow) or impassable (extreme mountains)
- **Combat Modifier**: +25% defense (high ground advantage)
- **Visual**: Mountain peaks with snow caps
- **Strategic Value**: Low (difficult terrain, defensive strongholds)

**Rivers** (8% of map):
- **Color**: Blue (#4169E1)
- **Movement Modifier**: 0.8× (crossing), impassable (no bridges)
- **Combat Modifier**: -10% defense (open terrain near water)
- **Visual**: Winding lines with bridge icons at crossing points
- **Strategic Value**: High (natural barriers, chokepoints)

**Settlements** (2% of map):
- **Castles**: Large fortified structures
- **Villages**: Small settlements
- **Combat Modifier**: +20% defense (fortification bonus)
- **Visual**: Traditional Japanese architecture
- **Strategic Value**: Very high (recruitment, resources, defense)

### 1.3 Terrain Distribution Map

**Layout Pattern**:
```
[M = Mountains, F = Forest, P = Plains, R = River, C = Castle, V = Village]

M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M
M F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F M
M F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P M
M F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P M
M F P P R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R P P M
M F P P R F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P R P P M
M F P P R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R P P M
M F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P M
M F P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P P M
M F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F M
M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M M
```

**Legend**:
- Player Castle: C at (25, 35)
- Enemy Castle 1: C at (40, 15)
- Enemy Castle 2: C at (10, 15)
- Villages: V distributed across map (5 total)
- Rivers: Main river flowing from top-left to bottom-right

### 1.4 Environmental Factors

**Weather Systems**:
- **Clear**: Default weather, no modifiers
- **Rain**:
  - Visibility: -20%
  - Movement: -15% (mud)
  - Combat: -5% attack power (slippery)
  - Occurrence: 20% chance per day
- **Fog**:
  - Visibility: -50%
  - Movement: No change
  - Combat: +10% stealth success
  - Occurrence: 15% chance per day
- **Storm**:
  - Visibility: -30%
  - Movement: -25%
  - Combat: -10% attack power, -10% defense
  - Occurrence: 5% chance per day

**Day/Night Cycle**:
- **Day** (60% of time):
  - Visibility: 100% (normal)
  - Stealth: Normal success rate
- **Night** (40% of time):
  - Visibility: -40% (darker)
  - Stealth: +20% success rate
  - Combat: -5% attack power (reduced visibility)

**Seasonal Effects** (Deferred to Future Phases):
- **Spring**: Food production +20%, Movement normal
- **Summer**: Food production +10%, Movement -5% (heat)
- **Autumn**: Food production 0%, Movement normal
- **Winter**: Food production -30%, Movement -20% (snow)

---

## 2. Factions & Territories

### 2.1 Factions (MVP - 2 Factions)

**Faction 1: Azure Dragon Clan (Player)**
- **Color**: Blue (#1E90FF)
- **Starting Territory**: Center-right area (3 provinces)
- **Starting Castles**: 1 castle at (25, 35)
- **Starting Villages**: 2 villages
- **Faction Bonus**: +10% defense in forests
- **Strategic Preference**: Balanced (expand, defend, trade)

**Faction 2: Crimson Phoenix Clan (Enemy)**
- **Color**: Red (#DC143C)
- **Starting Territory**: Top-left area (3 provinces)
- **Starting Castles**: 2 castles at (10, 15) and (40, 15)
- **Starting Villages**: 1 village
- **Faction Bonus**: +10% attack power in plains
- **Strategic Preference**: Aggressive (expand, attack)

### 2.2 Territory Control

**Ownership Mechanics**:
- Each tile belongs to a faction or is neutral
- Ownership changes when faction controls adjacent settlement
- Neutral territories: No ownership (grey color)

**Control Benefits**:
- **Villages**: 10 gold/day, 5 food/day
- **Castles**: 50 gold/day, 20 food/day, +1 recruitment speed
- **Territories**: Visibility of owned tiles (no fog of war)

**Victory Condition**:
- Control 80% of map tiles (2,000/2,500)
- Control enemy capital castle(s)

### 2.3 AI Behavior

**Azure Dragon Clan (Player) AI** (if computer-controlled):
- Balanced expansion
- Defensive posture
- Trade-focused
- Diplomatic when possible

**Crimson Phoenix Clan AI**:
- Aggressive expansion
- Attack-focused
- Rarely trades
- Hostile diplomacy

**AI Decision Frequency**:
- Every 5 seconds, evaluate army positions
- Every 10 seconds, consider diplomatic actions
- Every 30 seconds, assess strategic situation

---

## 3. Settlements

### 3.1 Castles

**Castle Functions**:
- **Recruitment**: +50% unit recruitment speed
- **Defense**: +20% defensive bonus when defending
- **Storage**: 500 gold, 500 food capacity
- **Repair**: Restores building damage at 10 gold/hour

**Castle Visual**:
- Large fortified structure with walls
- Traditional Japanese castle architecture (tenshu, yagura)
- Faction-colored banners
- Size: 3×3 tiles (75×75 pixels)

**Castle Data**:
```
Castle {
  faction_id: int
  position: Vector2 (tile coordinates)
  size: Vector2 (3, 3)
  health: int (0-100)
  recruitment_speed_multiplier: float (1.5)
  defense_bonus: float (1.2)
  gold_capacity: int (500)
  food_capacity: int (500)
}
```

### 3.2 Villages

**Village Functions**:
- **Production**: 10 gold/day, 5 food/day
- **Recruitment**: Normal recruitment speed
- **Storage**: 100 gold, 100 food capacity

**Village Visual**:
- Small settlement with traditional houses
- Rice paddies and farms nearby
- Faction-colored flags
- Size: 2×2 tiles (50×50 pixels)

**Village Data**:
```
Village {
  faction_id: int
  position: Vector2 (tile coordinates)
  size: Vector2 (2, 2)
  health: int (0-100)
  gold_production: int (10)
  food_production: int (5)
  gold_capacity: int (100)
  food_capacity: int (100)
}
```

---

## 4. Creative Shogun Era Setting

### 4.1 Time Period

**Era**: Fictional Sengoku-style period
**No Specific Historical Constraints**: Creative freedom for gameplay balance
**Inspiration**: Warring States period (1467-1615) with supernatural elements optional

### 4.2 Technology Level

**Weapons**:
- **Katana**: Primary melee weapon, 1.2× damage vs light armor
- **Yumi (Longbow)**: Ranged weapon, 1.0× damage, medium range
- **Naginata**: Polearm, 1.1× damage vs cavalry
- **Yari (Spear)**: Spear, 1.0× damage, +10% vs infantry

**Armor Types**:
- **Light Armor**: Bamboo/leather, -20% damage taken, fast movement
- **Heavy Armor**: Iron/steel, -40% damage taken, slow movement

**Military Technology**:
- No gunpowder (deferred to future phases)
- No siege engines (deferred to future phases)
- Traditional Japanese warfare focus

### 4.3 Cultural Elements

**Honor System** (Deferred):
- Honorable actions increase honor rating
- Dishonorable actions decrease honor rating
- High honor: Better diplomacy, cheaper recruitment
- Low honor: Worse diplomacy, expensive recruitment

**Political Intrigue** (Deferred):
- Assassinate enemy officers
- Bribe enemy armies to switch sides
- Spread rumors to weaken enemy morale

**Supernatural Elements** (Optional):
- Oni (demons) as special units
- Yokai (spirits) as terrain hazards
- Shrines with blessings/abilities

### 4.4 Art Style

**Traditional Japanese Art Styles**:
- **Sumi-e (Ink Wash)**: Primary visual style
- **Ukiyo-e**: Character portraits and UI elements
- **Emakimono**: Narrative elements and backgrounds

**Color Palette**:
- **Faction Colors**: Blue (Azure Dragon), Red (Crimson Phoenix), Gold (neutral)
- **Natural Colors**: Greens, browns, greys, blues
- **UI Colors**: Muted tones, high contrast text

---

## 5. Resource System

### 5.1 Gold

**Gold Sources**:
- Village production: 10 gold/day
- Castle production: 50 gold/day
- Battle victory: +50-200 gold (varies by enemy strength)
- Trade routes: +20 gold/day (deferred)

**Gold Uses**:
- Recruit infantry: 10 gold per unit
- Recruit cavalry: 25 gold per unit
- Recruit archers: 15 gold per unit
- Hire informants: 10-100 gold (varies by information)
- Interrogate prisoners: 50 gold
- Build structures: 100-500 gold (deferred)

**Gold Capacity**:
- Castle storage: 500 gold
- Village storage: 100 gold
- Excess gold: Lost (no global storage)

### 5.2 Food

**Food Sources**:
- Village production: 5 food/day
- Castle production: 20 food/day
- Foraging: +1 food per 10 tiles explored (deferred)

**Food Uses**:
- Maintain troops: 1 food per unit per day
- Create decoy armies: 30 food (deferred)
- Build structures: 10-50 food (deferred)

**Food Capacity**:
- Castle storage: 500 food
- Village storage: 100 food
- Excess food: Lost (no global storage)

**Starvation Effects** (Deferred):
- Food < 0: Units lose 10% health/day
- Food < -50: Units lose 20% health/day
- Food < -100: Units desert (50% loss per day)

---

**Document Version**: 1.0
**Last Updated**: 2025-01-11
**Next Review**: After Step 4 completion
