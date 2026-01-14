# Way of Shogun - Development Roadmap (Step-Based)

## Overview

This roadmap provides a step-by-step development plan optimized for AI-driven development. Each step has clear actions, verification criteria, and parallel execution opportunities.

**Total Steps**: 9
**Estimated Time**: 1 week (with parallelization)
**Approach**: Sequential steps with parallel work where possible

---

## Step 1: Godot Setup & Base Architecture

### Prerequisites
- Godot 4.2 or later installed
- CLI access verified
- Basic knowledge of Godot interface

### Actions
1. Create Godot project with standard structure
2. Setup scene hierarchy (Main, Combat, Map, Meeting scenes)
3. Create GameManager singleton script
4. Implement basic game state management
5. Setup GUT testing framework with CLI integration
6. Verify AI debugging: Run `godot --headless --path ./ --verbose > debug.log`
7. Create placeholder assets (colored squares for testing)

### Verification
- [ ] Project runs in headless mode
- [ ] GameManager state accessible via CLI
- [ ] GUT tests can run via command line
- [ ] Placeholder assets display correctly
- [ ] Debug logging functional

### PARALLEL NOTE
- Can start researching AI art generation prompts while setting up project
- Can prepare skill data structures (JSON) while coding

### Dependencies
- No previous steps required

### Time Estimate (Sequental)
- 4-6 hours

---

## Step 2: Combat System Implementation

### Prerequisites
- Step 1 complete
- Basic character sprite (placeholder OK)

### Actions
1. Create Character scene with Sprite2D
2. Implement 4-directional movement (WASD controls)
3. Add CollisionShape2D for hit detection
4. Create attack system with 4 directions
5. Implement directional blocking system
6. Add simple damage calculation (HP reduction)
7. Create basic stamina system (cost for attacks/blocks)
8. Add visual feedback (attack animations, damage indicators)

### Verification
- [ ] Character moves in 4 directions smoothly
- [ ] Attacks execute in facing direction
- [ ] Blocking reduces or negates damage
- [ ] Stamina depletes with combat actions
- [ ] Damage displayed on screen

### PARALLEL NOTE
- Can generate placeholder art assets (colored squares for sprites) while coding combat
- Can design hitbox system in parallel
- Can create attack/block animation placeholders

### Dependencies
- Step 1 must be complete

### Time Estimate (Sequental)
- 6-8 hours

---

## Step 3: Information System Implementation

### Prerequisites
- Step 2 complete
- Basic TileMap setup (placeholder tiles OK)

### Actions
1. Create TileMap for game world (50×50 tiles)
2. Implement fog of war visual system (grey overlay on hidden tiles)
3. Create Scout unit scene
4. Implement information retrieval system:
   - Scout deployment mechanic
   - Base timing: 10 seconds
   - Distance multipliers: 1.0x (near), 2.0x (medium), 4.0x (far)
5. Track enemy troop positions
6. Update visibility based on scout locations
7. Create information display UI

### Verification
- [ ] Fog of war covers unexplored areas
- [ ] Scouts deploy to specified locations
- [ ] Information retrieval timing matches formula
- [ ] Enemy troop positions reveal after retrieval
- [ ] Visibility updates correctly

### PARALLEL NOTE
- Scout unit sprites can be generated simultaneously with information system coding
- Map tiles (plains, forest, mountains) can be generated in parallel
- Can design information UI in parallel

### Dependencies
- Step 2 must be complete

### Time Estimate (Sequental)
- 5-7 hours

---

## Step 4: Army Command System

### Prerequisites
- Step 3 complete
- Basic map display functional

### Actions
1. Create Army data structure (unit count, faction, position)
2. Implement chess-style map interface:
   - Display armies as icons (kanji/symbols)
   - Click-to-select armies
   - Visual selection indicator
3. Implement army movement:
   - Click destination
   - Pathfinding (basic A* or direct movement)
   - Movement animation
4. Create attack order system:
   - Click enemy army to attack
   - Combat calculation (simple unit count comparison)
5. Add basic enemy AI:
   - Move armies toward player territories
   - Attack player armies when in range

### Verification
- [ ] Armies display on map correctly
- [ ] Selection works with visual feedback
- [ ] Armies move to clicked locations
- [ ] Attack orders execute combat
- [ ] Enemy AI moves and attacks

### PARALLEL NOTE
- Army icons and map tiles can be generated while coding
- Faction banners (kanji) can be designed in parallel
- Can create enemy AI logic simultaneously with army movement

### Dependencies
- Step 3 must be complete

### Time Estimate (Sequental)
- 6-8 hours

---

## Step 5: Meeting System Implementation

### Prerequisites
- Step 4 complete
- Basic UI framework functional

### Actions
1. Create perch-style UI panel:
   - Semi-transparent background
   - Traditional Japanese aesthetic
   - Position: Right side of screen
2. Implement tactical meeting interface:
   - Display current battlefield situation
   - Show available decision options
   - Display consequences for each option
3. Create decision timer (30 seconds countdown)
4. Implement real-time integration:
   - Game continues at 50% speed during meeting
   - Background fades/blurs
5. Add consequence system:
   - Apply selected decision effects immediately
   - Update army positions, morale, or status

### Verification
- [ ] Perch UI displays correctly
- [ ] Meeting pauses game action appropriately
- [ ] Decision timer counts down
- [ ] Consequences apply when decision selected
- [ ] Game resumes with updated state

### PARALLEL NOTE
- UI elements (perch interface, decision cards) can be generated while coding
- Meeting background art can be generated simultaneously
- Can design decision consequence system in parallel

### Dependencies
- Step 4 must be complete

### Time Estimate (Sequental)
- 4-6 hours

---

## Step 6: Skill System Implementation

### Prerequisites
- Step 5 complete
- UI system functional

### Actions
1. Create Skill data structure:
   - Name, description, effect type (passive/active)
   - Magnitude, duration, range
   - Level, max_level, carry_over_percentage
2. Implement Shogun General skills:
   - Tactical Insight: +10% information accuracy
   - Charisma: +5% ally combat effectiveness
3. Create skill UI panel:
   - Display active skills
   - Show skill effects
4. Integrate skills into systems:
   - Apply Tactical Insight to information retrieval
   - Apply Charisma to combat calculations

### Verification
- [ ] Skills display in UI
- [ ] Tactical Insight increases information accuracy
- [ ] Charisma boosts ally combat effectiveness
- [ ] Skill effects visible in gameplay

### PARALLEL NOTE
- Skill UI art (skill icons, icons, progress bars) can be generated simultaneously
- Can design skill progression system in parallel
- Can create skill tooltips while coding

### Dependencies
- Step 5 must be complete

### Time Estimate (Sequental)
- 3-5 hours

---

## Step 7: AI Art Generation & Integration

### Prerequisites
- Step 6 complete
- All placeholder art created

### Actions
1. Generate map tiles using AI prompts (6 variations):
   - Plains (1 variation)
   - Forest (2 variations)
   - Mountains (2 variations)
   - Rivers (1 variation)
2. Generate character sprites (40 total):
   - Shogun General (8 sprites: 4 directions × 2 frames)
   - Infantry (16 sprites: 2 factions × 4 directions × 2 frames)
   - Cavalry (16 sprites: 2 factions × 4 directions × 2 frames)
3. Generate army icons (4 total):
   - Infantry icon (2 factions)
   - Cavalry icon (2 factions)
4. Generate UI elements (10 total):
   - Perch interface panel
   - Button design
   - Information card
   - Skill icon
   - Health/mana bar
   - Timer interface
   - Selection indicator
   - Status display
   - Movement preview
   - Damage indicator
5. Generate backgrounds (3 total):
   - Menu background
   - Combat background
   - Meeting background
6. Integrate all generated assets:
   - Replace placeholder art
   - Update sprite references in code
   - Adjust scaling/positioning
7. Polish UI with traditional Japanese aesthetic:
   - Apply ink wash effects
   - Add pattern overlays (asanoha, seigaiha)
   - Adjust colors to muted palette

### Verification
- [ ] All generated assets display correctly
- [ ] Visual style is consistent
- [ ] No broken textures or sprites
- [ ] Performance remains acceptable (30 FPS+)
- [ ] UI matches traditional Japanese aesthetic

### PARALLEL NOTE
- This step IS parallel work from previous steps
- Can generate all art assets in one batch
- Post-processing can happen while coding continues

### Dependencies
- Step 6 must be complete
- All AI art tools must be accessible

### Time Estimate (Sequental)
- 4-6 hours

---

## Step 8: Integration & Testing

### Prerequisites
- Step 7 complete
- All systems implemented individually

### Actions
1. Run full integration test:
   - Complete game loop from start to combat/meeting to resolution
2. Performance profiling:
   - Monitor FPS (target 30+)
   - Check memory usage (target under 300MB)
   - Identify bottlenecks
3. Bug fixing:
   - Test all systems individually
   - Test combined system interactions
   - Fix reported issues
4. AI debugging sessions:
   - Run CLI debugging commands
   - Inspect game state at various points
   - Verify AI agent can analyze state
5. Polish:
   - Adjust game balance
   - Improve UI feedback
   - Add sound effects (if time permits)

### Verification
- [ ] Complete game loop functional
- [ ] Performance meets targets (30 FPS+, <300MB)
- [ ] No critical bugs
- [ ] AI debugging successful
- [ ] Gameplay is fun and engaging

### PARALLEL NOTE
- Automated testing can run while manual testing happens
- Performance profiling can run in background
- Can fix bugs in parallel with polishing

### Dependencies
- Step 7 must be complete

### Time Estimate (Sequental)
- 5-7 hours

---

## Step 9: Final Documentation & Delivery

### Prerequisites
- Step 8 complete
- Game fully functional

### Actions
1. Review and update GDD with any changes
2. Create AI debugging guide:
   - List all CLI commands
   - Explain state inspection methods
   - Document expected outputs
3. Create player guide:
   - Basic controls
   - Core mechanics explanation
   - Tips for gameplay
4. Package project:
   - Export to executable format
   - Include all assets
   - Create README with setup instructions
5. Final testing:
   - Run exported version
   - Verify all features work
   - Confirm AI debugging still functional

### Verification
- [ ] All documentation complete and accurate
- [ ] Project exports successfully
- [ ] Executable runs without errors
- [ ] AI debugging guide comprehensive
- [ ] Ready for delivery

### PARALLEL NOTE
- Documentation can be written while final testing happens
- Can prepare packaging scripts in parallel

### Dependencies
- Step 8 must be complete

### Time Estimate (Sequental)
- 3-5 hours

---

## Critical Path

The critical path (must complete in sequence) is:
1. **Step 1**: Godot Setup & Base Architecture (4-6 hours)
2. **Step 2**: Combat System (6-8 hours)
3. **Step 3**: Information System (5-7 hours)
4. **Step 4**: Army Command (6-8 hours)
5. **Step 5**: Meeting System (4-6 hours)
6. **Step 6**: Skill System (3-5 hours)
7. **Step 7**: AI Art Generation (4-6 hours)
8. **Step 8**: Integration & Testing (5-7 hours)
9. **Step 9**: Final Documentation (3-5 hours)

**Total Critical Path Time**: 40-58 hours (5-7 days)

---

## Parallel Execution Opportunities

### Major Parallelization Points

1. **Art Generation During Development**:
   - Steps 2-6: AI art generation can run parallel to coding
   - Estimated time savings: 2-3 hours
   - Tools: Separate AI agent or external service

2. **Testing During Development**:
   - Each step's verification can run while next step starts
   - Automated tests (GUT) run in background
   - Estimated time savings: 1-2 hours

3. **Documentation During Development**:
   - In-code documentation written alongside code
   - No dedicated documentation step needed
   - Estimated time savings: 1 hour

### Total Estimated Time Savings from Parallelization: 4-6 hours

**Optimized Timeline with Parallelization**: 36-52 hours (4-6 days)

---

## Risk Mitigation Strategy

### Timeline Risks

**Risk**: Step may take longer than expected
**Mitigation**: Cut features if behind schedule
- Prioritize: Combat → Information → Command → Meetings
- Defer: Formation system, secret agents, advanced skills

**Risk**: AI art generation quality may vary
**Mitigation**: Use placeholder art if AI generation fails
- Colored squares with clear labels
- Replace with better art later

**Risk**: System integration issues may arise
**Mitigation**: Daily progress reviews with AI assistant
- Check integration points after each step
- Fix integration issues immediately

### Feature Cutting Priorities

**If behind schedule, cut in this order**:
1. Formation system (deferred to Phase 2)
2. Secret agent mechanics (deferred to Phase 3)
3. Strategic meetings (deferred to Phase 2)
4. Advanced skills (deferred to Phase 2)
5. Weather effects (deferred to Phase 3)

### Rollback Strategy

**If step fails completely**:
1. Revert to previous working state
2. Document failure cause
3. Adjust approach or simplify requirements
4. Retry with modified scope

---

## Success Metrics

### Completion Criteria

- [ ] All 9 steps completed
- [ ] Core gameplay loop functional (Combat → Information → Command → Decision)
- [ ] Performance targets met (30 FPS+, <300MB memory)
- [ ] All verification criteria passed
- [ ] AI debugging functional (state inspection via CLI)
- [ ] Documentation complete (GDD, AI guide, player guide)

### Quality Criteria

- [ ] No critical bugs
- [ ] UI responsive and intuitive
- [ ] Art style consistent (traditional Japanese aesthetic)
- [ ] Game is fun and engaging (tested for at least 1 hour)

---

**Document Version**: 1.0
**Last Updated**: 2025-01-11
**Next Review**: After Step 9 completion
