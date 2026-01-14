# Way of Shogun - Role System

## 1. Shogun General (MVP Focus)

### 1.1 Role Overview

The Shogun General is the player's primary avatar in the MVP phase. This role combines battlefield leadership with strategic command, requiring players to balance direct combat participation with army management and decision-making.

**Role Capabilities**:
- Command armies on the strategic map
- Make tactical and strategic decisions in real-time meetings
- Participate directly in combat (optional but beneficial)
- Recruit and manage units
- Control territory and resources

**Starting Stats**:
- Combat Skill: Moderate (3/10)
- Command Skill: High (8/10)
- Diplomacy Skill: Moderate (4/10)
- Leadership: High (7/10)

### 1.2 Unique Abilities

**Command Aura**:
- Range: 3-tile radius
- Effect: All armies in range execute orders 15% faster
- Active ability: Drains 5 stamina/second when activated

**Army Recruitment**:
- Cost: 10 gold per infantry unit
- Cost: 25 gold per cavalry unit
- Cost: 15 gold per archer unit
- Time: 5 seconds per 10 units recruited

**Territory Management**:
- Tax collection: 10 gold per village per day
- Food production: 5 food per village per day
- Population growth: +1% per day per village

---

## 2. Skill System

### 2.1 Skill Data Structure

```
Skill {
  skill_id: int
  name: string
  description: string
  skill_type: string (passive/active)
  magnitude: float (effect strength)
  duration: float (for active skills, in seconds)
  range: float (in tiles)
  level: int (current level)
  max_level: int
  carry_over_percentage: float (0.0-1.0)
}
```

### 2.2 Shogun General Skills (MVP - 2 Passive)

#### Skill 1: Tactical Insight

**Type**: Passive
**Effect**: +10% information accuracy per level
**Range**: Self
**Leveling**: Starts at +10%, increases by 5% per level
**Max Level**: 5 (final: +30% information accuracy)
**Carry-Over**: 50% efficiency in other roles

**Mechanics**:
- Applies to all information retrieval (scouts, informants, captured enemies)
- Does not affect information degradation over time
- Stacks with other information-boosting abilities

**Example Impact**:
- Scout normally 60% accuracy
- With Tactical Insight Level 1: 66% accuracy
- With Tactical Insight Level 5: 78% accuracy

#### Skill 2: Charisma

**Type**: Passive, Area-of-Effect
**Effect**: Allied units in range fight +5% harder per level
**Range**: 5-tile radius
**Leveling**: Starts at +5%, increases by 2% per level
**Max Level**: 5 (final: +15% ally combat effectiveness)
**Carry-Over**: 60% efficiency in leadership roles

**Mechanics**:
- Applies to both player and AI-controlled allied units
- Affects both attack power and damage resistance
- Does not affect enemy units

**Example Impact**:
- Ally army normally 100 attack power
- With Charisma Level 1 (in range): 105 attack power
- With Charisma Level 5 (in range): 115 attack power

---

## 3. Skill Progression System

### 3.1 Experience & Leveling

**Experience Sources**:
- Victory in combat: +50 XP
- Winning battle (army command): +100 XP
- Making correct decision in meeting: +75 XP
- Recruiting units: +25 XP per 10 units

**Level Requirements**:
```
Level 1 → 2: 100 XP required
Level 2 → 3: 250 XP required
Level 3 → 4: 500 XP required
Level 4 → 5: 1000 XP required
```

**Skill Point Allocation**:
- 1 skill point per character level
- Skills can be leveled up to Level 5
- Skill points can be redistributed (cost: 50 gold per point)

### 3.2 Skill UI Display

**Skill Panel Layout**:
```
+---------------------------+
| SKILLS (Shogun General)  |
+---------------------------+
| Tactical Insight [3/5]    |
| +15% information accuracy |
|                           |
| Charisma [2/5]            |
| +9% ally combat power     |
|                           |
| [Level Up] Available: 2    |
+---------------------------+
```

**Interaction**:
- Click skill icon to view details
- Click "Level Up" button to increase skill level
- Hover over skill to see next level effect

---

## 4. Future Role Switching Architecture

### 4.1 Role Switching Mechanics (Deferred)

**Switch Mechanism**:
- Complete character transfer with inventory
- Position: Teleport to nearest friendly settlement
- Time cost: 5-30 seconds transition time (prevents abuse in combat)

**Role Options** (Future Phases):
1. **Shogun General** (Current MVP)
   - Command armies, make decisions, recruit units
2. **Soldier**
   - Direct combat focus, army leadership, battlefield tactics
3. **Scout**
   - Information gathering, stealth, reconnaissance
4. **Merchant**
   - Economic management, trade, resource allocation

### 4.2 Skill Carry-Over System (Deferred)

**Carry-Over Mechanics**:
- **Full carry-over (100%)**: Information-gathering skills, passive abilities
- **Partial carry-over (50-70%)**: Combat skills, leadership abilities
- **No carry-over (0%)**: Role-specific active abilities

**Carry-Over Formula**:
```
Effective Level = Base Level × Carry_Over_Percentage × (1 + (Total_Switches × 0.05))

Example:
Base Level: 5
Carry-Over: 50%
Total Switches: 2
Effective Level = 5 × 0.50 × (1 + (2 × 0.05)) = 5 × 0.50 × 1.10 = 2.75
```

**Maximum Bonus**: +50% (caps at 10 total switches)

**Temporary Bonus**: Switching roles grants temporary +10% to all skills for 5 minutes

### 4.3 Future Skill Tree (Reserved for Later)

**Additional Skills** (5 total, not implemented in MVP):

3. **Information Broker** (Active)
   - Effect: -30% information retrieval time, +15% informant reliability
   - Cost: 10 gold per use
   - Leveling: Reduces time by 5% per level (max -50%)
   - Carry-Over: 100% efficiency in all roles

4. **Battle Intuition** (Passive)
   - Effect: 10% chance to predict enemy attack direction (shown as visual indicator)
   - Leveling: +2% per level (max 20%)
   - Carry-Over: 70% efficiency in combat roles

5. **Command Presence** (Active)
   - Effect: Army units execute orders 15% faster, +10% army morale
   - Cost: 5 stamina/second when active
   - Range: 3-tile radius
   - Carry-Over: 0% (role-specific)

6. **Battlecry** (Active)
   - Effect: Temporary +25% attack power for all nearby allies, duration 10 seconds
   - Cost: 30 stamina, 1-time use per battle
   - Range: 5-tile radius
   - Carry-Over: 70% efficiency in combat roles

7. **Master Tactician** (Passive)
   - Effect: +10% army movement speed, +5% formation effectiveness
   - Leveling: +2% movement speed per level (max +20%)
   - Carry-Over: 80% efficiency in command roles

---

## 5. Skill Integration with Systems

### 5.1 Integration with Combat System

**Tactical Insight**:
- Increases accuracy of combat-related information (enemy formations, unit types)
- Applied when scout retrieves combat information

**Charisma**:
- Boosts allied unit combat power (attack and defense)
- Applied during combat calculations

### 5.2 Integration with Information System

**Tactical Insight**:
- Increases accuracy of all information retrieval
- Applied when scout/informant returns with data

**Information Broker** (Future):
- Reduces retrieval time for all information types
- Applied during timing calculations

### 5.3 Integration with Army Command System

**Charisma**:
- Boosts army effectiveness in battle calculations
- Applied when attacking enemy armies

**Command Presence** (Future):
- Increases order execution speed for nearby armies
- Applied when army receives movement/attack orders

**Master Tactician** (Future):
- Increases army movement speed
- Applied during pathfinding calculations

### 5.4 Integration with Meeting System

**Tactical Insight**:
- Increases accuracy of information displayed in meeting interface
- Applied when meeting shows available information

**Charisma**:
- Boosts morale of allies affected by meeting decisions
- Applied when decision consequences are applied

---

## 6. Skill Progression Roadmap

### MVP Phase (Current)
- Implement 2 passive skills (Tactical Insight, Charisma)
- Basic leveling system (XP, skill points)
- Skill UI display
- Integration with combat and information systems

### Phase 2 (Future)
- Add 3 additional skills (Information Broker, Battle Intuition, Command Presence)
- Active skill mechanics
- Skill cooldowns and stamina costs

### Phase 3 (Future)
- Implement role switching
- Skill carry-over system
- Total of 7 skills across all roles

### Phase 4 (Future)
- Advanced skill trees
- Skill synergies
- Legendary skills (unlockable through achievements)

---

**Document Version**: 1.0
**Last Updated**: 2025-01-11
**Next Review**: After Step 6 completion
