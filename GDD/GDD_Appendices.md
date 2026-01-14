# Way of Shogun - Appendices

## Appendix A: AI Debugging Command Reference

### Godot CLI Commands

**Start Game in Headless Mode**:
```bash
godot --headless --path ./project_folder
```

**Start Game with Remote Debugging**:
```bash
godot --headless --path ./project_folder --remote-debug 127.0.0.1:6007
```

**Run with Verbose Logging**:
```bash
godot --headless --path ./project_folder --verbose > debug.log
```

**Run with Collision Debugging**:
```bash
godot --headless --path ./project_folder --debug-collisions
```

### Game State Inspection

**Export Current Game State**:
```bash
godot --headless --path ./ --export-state state.json
```

**Inspect Specific System**:
```bash
godot --headless --path ./ --inspect-system combat
godot --headless --path ./ --inspect-system information
godot --headless --path ./ --inspect-system army_command
godot --headless --path ./ --inspect-system meeting
godot --headless --path ./ --inspect-system skill
```

**Inspect Fog of War**:
```bash
godot --headless --path ./ --inspect-fog
```

**Inspect Player State**:
```bash
godot --headless --path ./ --inspect-player
```

### Performance Monitoring

**Monitor FPS**:
```bash
godot --headless --path ./ --monitor-fps 60
```
Monitors FPS and warns if drops below 60.

**Monitor Memory Usage**:
```bash
godot --headless --path ./ --monitor-memory 300
```
Monitors memory usage and warns if exceeds 300MB.

**Generate Performance Report**:
```bash
godot --headless --path ./ --performance-report > perf_report.txt
```
Generates detailed performance report.

### Automated Testing

**Run All Tests**:
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/ -gexit
```

**Run Specific Test**:
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/combat_test.gd -gexit
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/information_test.gd -gexit
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/army_command_test.gd -gexit
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/meeting_test.gd -gexit
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/skill_test.gd -gexit
```

**Generate JUnit XML Report**:
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gtest res://tests/ -gjunit report.xml
```

### Debugging Levels

**Set Debug Level**:
```bash
godot --headless --path ./ --debug-level 4
```

Debug levels:
- 0: No debug output
- 1: Critical errors only
- 2: Errors and warnings
- 3: Normal (default)
- 4: Verbose (detailed logging)

---

## Appendix B: AI Art Generation Prompt List (Consolidated)

### Map Tiles (6 Prompts)

**Plains**:
```
Prompt: "Traditional Japanese ink wash style, feudal Japan grassland, minimalist, 2D game art, 64x64 pixels, seamless tiling"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Sumi-e style grassland, feudal Japan, 64x64 pixel art, seamless tile"
Alternative: Stable Diffusion (ControlNet) "Sumi-e style, grassland, seamless tiling"
```

**Forest**:
```
Prompt: "Japanese ink wash forest with stylized pine trees, feudal Japan, 2D game art, 64x64 pixels, seamless tiling"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Sumi-e style forest, pine trees, feudal Japan, 64x64 pixel art, seamless tile"
Alternative: Stable Diffusion (ControlNet) "Sumi-e style, pine forest, seamless tiling, dark green"
```

**Mountains**:
```
Prompt: "Sumi-e style mountain ranges, traditional Japanese art, feudal Japan, 2D game art, 64x64 pixels, seamless tiling"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Ink wash mountains, feudal Japan, 64x64 pixel art, seamless tile"
Alternative: Stable Diffusion (ControlNet) "Sumi-e style, mountains, seamless tiling, grey"
```

**Rivers**:
```
Prompt: "Traditional Japanese ink wash river, flowing water, feudal Japan, 2D game art, 64x64 pixels, seamless tiling"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Sumi-e style river, feudal Japan, 64x64 pixel art, seamless tile"
Alternative: Stable Diffusion (ControlNet) "Sumi-e style, river, seamless tiling, blue"
```

**Castle**:
```
Prompt: "Traditional Japanese castle architecture, tenshu and yagura towers, feudal Japan, 2D game art, 96x96 pixels, sumi-e style"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese castle, feudal Japan, 96x96 pixel art, tenshu, yagura, traditional architecture"
Alternative: Stable Diffusion (ControlNet) "Japanese castle, traditional architecture, stone and wood, sumi-e"
```

**Village**:
```
Prompt: "Traditional Japanese village, rural houses, rice paddies, feudal Japan, 2D game art, 64x64 pixels, sumi-e style"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese village, feudal Japan, 64x64 pixel art, traditional houses, rice paddies"
Alternative: Stable Diffusion (ControlNet) "Japanese village, traditional houses, rice paddies, sumi-e"
```

### Character Sprites (5 Prompts)

**Shogun General**:
```
Prompt: "Ukiyo-e style samurai portrait, feudal Japan, minimalist, 2D game character, 96x96 pixels, facing forward, traditional armor, katana at hip"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Ukiyo-e style samurai portrait, feudal Japan, 96x96 pixel art, facing forward, traditional armor"
Alternative: Stable Diffusion (ControlNet) "Ukiyo-e style, samurai, traditional armor, katana"
```

**Infantry**:
```
Prompt: "Stylized Japanese foot soldier, feudal Japan, 2D game sprite, 64x64 pixels, 8-directional animation, traditional armor, spear or sword"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5 --multiple
Alternative: DALL-E "Japanese infantry soldier, feudal Japan, 64x64 pixel art, 8-directional, traditional armor"
Alternative: Stable Diffusion (ControlNet) "Japanese infantry, traditional armor, spear, 8 directions"
```

**Cavalry**:
```
Prompt: "Japanese cavalry, feudal Japan, 2D game sprite, 64x64 pixels, 8-directional animation, horse with rider, traditional armor"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5 --multiple
Alternative: DALL-E "Japanese cavalry, feudal Japan, 64x64 pixel art, 8-directional, horse with rider"
Alternative: Stable Diffusion (ControlNet) "Japanese cavalry, horse with rider, 8 directions"
```

**Archer**:
```
Prompt: "Japanese archer, feudal Japan, 2D game sprite, 64x64 pixels, 8-directional animation, traditional armor, yumi longbow"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5 --multiple
Alternative: DALL-E "Japanese archer, feudal Japan, 64x64 pixel art, 8-directional, yumi bow"
Alternative: Stable Diffusion (ControlNet) "Japanese archer, traditional armor, yumi bow, 8 directions"
```

**Scout**:
```
Prompt: "Japanese scout, feudal Japan, 2D game sprite, 64x64 pixels, 8-directional animation, light armor, stealthy appearance"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5 --multiple
Alternative: DALL-E "Japanese scout, feudal Japan, 64x64 pixel art, 8-directional, light armor"
Alternative: Stable Diffusion (ControlNet) "Japanese scout, light armor, stealthy, 8 directions"
```

### Army Icons (4 Prompts)

**Infantry Icon**:
```
Prompt: "Traditional Japanese kanji banner, feudal Japan, minimalist, 2D game icon, 64x64 pixels, kanji for 'infantry' (歩兵), simple bold design"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese kanji banner, feudal Japan, 64x64 pixel art, 歩兵 kanji, minimalism"
Alternative: Stable Diffusion (ControlNet) "Japanese kanji, 歩兵, minimalist"
```

**Cavalry Icon**:
```
Prompt: "Traditional Japanese kanji banner, feudal Japan, minimalist, 2D game icon, 64x64 pixels, kanji for 'cavalry' (騎兵), simple bold design"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese kanji banner, feudal Japan, 64x64 pixel art, 騎兵 kanji, minimalism"
Alternative: Stable Diffusion (ControlNet) "Japanese kanji, 騎兵, minimalist"
```

**Archer Icon**:
```
Prompt: "Traditional Japanese kanji banner, feudal Japan, minimalist, 2D game icon, 64x64 pixels, kanji for 'archer' (弓兵), simple bold design"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese kanji banner, feudal Japan, 64x64 pixel art, 弓兵 kanji, minimalism"
Alternative: Stable Diffusion (ControlNet) "Japanese kanji, 弓兵, minimalist"
```

**Faction Banner**:
```
Prompt: "Traditional Japanese fan (sensu) banner, feudal Japan, minimalist, 2D game icon, 64x64 pixels, simple elegant design"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese fan banner, feudal Japan, 64x64 pixel art, sensu fan, minimalism"
Alternative: Stable Diffusion (ControlNet) "Japanese fan banner, sensu, minimalist"
```

### UI Elements (10 Prompts)

**Perch Interface**:
```
Prompt: "Semi-transparent traditional Japanese UI panel, ink wash aesthetic, feudal Japan, 2D game UI, muted colors, parchment background, traditional patterns"
Tool: Midjourney --ar 16:9 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese UI panel, feudal Japan, 2D game UI, semi-transparent, parchment, asanoha pattern"
Alternative: Stable Diffusion (ControlNet) "Japanese UI panel, parchment, asanoha pattern"
```

**Button**:
```
Prompt: "Traditional Japanese button design, asanoha pattern, minimalist, 2D game UI, muted colors, subtle texture"
Tool: Midjourney --ar 2:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese button, feudal Japan, 2D game UI, asanoha pattern, minimalism"
Alternative: Stable Diffusion (ControlNet) "Japanese button, asanoha pattern, minimalist"
```

**Information Card**:
```
Prompt: "Japanese parchment style, ink wash aesthetic, feudal Japan, 2D game UI, information card, subtle texture"
Tool: Midjourney --ar 3:2 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese parchment card, feudal Japan, 2D game UI, information display"
Alternative: Stable Diffusion (ControlNet) "Japanese parchment, ink wash, information card"
```

**Skill Icon**:
```
Prompt: "Traditional Japanese skill icon, feudal Japan, minimalist, 2D game UI, circular or square design, faction colors"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5 --multiple
Alternative: DALL-E "Japanese skill icon, feudal Japan, 2D game UI, minimalist, circular"
Alternative: Stable Diffusion (ControlNet) "Japanese skill icon, minimalist, faction colors"
```

**Health Bar**:
```
Prompt: "Traditional Japanese health/mana bar design, feudal Japan, minimalist, 2D game UI, horizontal bar, faction colors"
Tool: Midjourney --ar 3:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese health bar, feudal Japan, 2D game UI, minimalist, horizontal"
Alternative: Stable Diffusion (ControlNet) "Japanese health bar, minimalist, faction colors"
```

**Timer**:
```
Prompt: "Traditional Japanese timer interface, feudal Japan, minimalist, 2D game UI, circular or linear progress, faction colors"
Tool: Midjourney --ar 2:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese timer, feudal Japan, 2D game UI, minimalist, circular"
Alternative: Stable Diffusion (ControlNet) "Japanese timer, minimalist, faction colors"
```

**Selection Indicator**:
```
Prompt: "Traditional Japanese selection indicator, feudal Japan, minimalist, 2D game UI, glowing border or highlight, gold color"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese selection indicator, feudal Japan, 2D game UI, gold glow"
Alternative: Stable Diffusion (ControlNet) "Japanese selection indicator, gold glow, minimalist"
```

**Status Display**:
```
Prompt: "Traditional Japanese status display, feudal Japan, minimalist, 2D game UI, information layout, faction colors"
Tool: Midjourney --ar 3:2 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese status display, feudal Japan, 2D game UI, minimalist"
Alternative: Stable Diffusion (ControlNet) "Japanese status display, minimalist"
```

**Movement Preview**:
```
Prompt: "Traditional Japanese movement preview, feudal Japan, minimalist, 2D game UI, dotted line or path, faction colors"
Tool: Midjourney --ar 3:2 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese movement path, feudal Japan, 2D game UI, dotted line"
Alternative: Stable Diffusion (ControlNet) "Japanese movement path, dotted line, minimalist"
```

**Damage Indicator**:
```
Prompt: "Traditional Japanese damage indicator, feudal Japan, minimalist, 2D game UI, floating text or icon, red color"
Tool: Midjourney --ar 1:1 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese damage indicator, feudal Japan, 2D game UI, red floating text"
Alternative: Stable Diffusion (ControlNet) "Japanese damage indicator, red, minimalist"
```

### Backgrounds (3 Prompts)

**Menu Background**:
```
Prompt: "Traditional Japanese landscape, Mount Fuji, ink wash style, feudal Japan, 2D game art, 1920x1080 pixels, minimalist"
Tool: Midjourney --ar 16:9 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese landscape, Mount Fuji, feudal Japan, 1920x1080, sumi-e style"
Alternative: Stable Diffusion (ControlNet) "Japanese landscape, Mount Fuji, sumi-e style, minimalist"
```

**Combat Background**:
```
Prompt: "Battlefield scene, feudal Japan, minimalist, ink wash style, 2D game art, 1920x1080 pixels, plains or forest"
Tool: Midjourney --ar 16:9 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese battlefield, feudal Japan, 1920x1080, sumi-e style"
Alternative: Stable Diffusion (ControlNet) "Japanese battlefield, sumi-e style, minimalist"
```

**Meeting Background**:
```
Prompt: "Traditional Japanese meeting room, feudal Japan, minimalist, ink wash style, 2D game art, 1920x1080 pixels, tatami mats"
Tool: Midjourney --ar 16:9 --v 6 --style raw --niji 5
Alternative: DALL-E "Japanese meeting room, feudal Japan, 1920x1080, sumi-e style"
Alternative: Stable Diffusion (ControlNet) "Japanese meeting room, tatami, sumi-e style"
```

---

## Appendix C: Step Verification Checklists

### Step 1: Godot Setup & Base Architecture

- [ ] Project runs in headless mode
- [ ] GameManager singleton created
- [ ] Game state accessible via CLI
- [ ] GUT tests can run via command line
- [ ] Placeholder assets display correctly
- [ ] Debug logging functional
- [ ] Scene hierarchy established (Main, Combat, Map, Meeting)
- [ ] Basic game state management working

### Step 2: Combat System Implementation

- [ ] Character moves in 4 directions smoothly
- [ ] Attacks execute in facing direction
- [ ] Blocking reduces or negates damage
- [ ] Stamina depletes with combat actions
- [ ] Damage displayed on screen
- [ ] Attack animations functional
- [ ] Collision detection working
- [ ] Hitbox system implemented (head, body, legs)

### Step 3: Information System Implementation

- [ ] Fog of war covers unexplored areas
- [ ] Scouts deploy to specified locations
- [ ] Information retrieval timing matches formula
- [ ] Enemy troop positions reveal after retrieval
- [ ] Visibility updates correctly
- [ ] Information display UI functional
- [ ] Distance multipliers working correctly

### Step 4: Army Command System

- [ ] Armies display on map correctly
- [ ] Selection works with visual feedback
- [ ] Armies move to clicked locations
- [ ] Attack orders execute combat
- [ ] Enemy AI moves and attacks
- [ ] Pathfinding functional (A* or direct)
- [ ] Movement animations working
- [ ] Combat calculation balanced

### Step 5: Meeting System Implementation

- [ ] Perch UI displays correctly
- [ ] Meeting pauses game action appropriately
- [ ] Decision timer counts down
- [ ] Consequences apply when decision selected
- [ ] Game resumes with updated state
- [ ] Real-time integration working (game at 50% speed)
- [ ] Background blur effect functional
- [ ] Decision options display correctly

### Step 6: Skill System Implementation

- [ ] Skills display in UI
- [ ] Tactical Insight increases information accuracy
- [ ] Charisma boosts ally combat effectiveness
- [ ] Skill effects visible in gameplay
- [ ] Experience system working
- [ ] Level up mechanism functional
- [ ] Skill point allocation working

### Step 7: AI Art Generation & Integration

- [ ] All generated assets display correctly
- [ ] Visual style is consistent
- [ ] No broken textures or sprites
- [ ] Performance remains acceptable (30 FPS+)
- [ ] UI matches traditional Japanese aesthetic
- [ ] Map tiles seamless tiling
- [ ] Character sprites animate correctly
- [ ] Army icons distinguishable

### Step 8: Integration & Testing

- [ ] Complete game loop functional
- [ ] Performance meets targets (30 FPS+, <300MB)
- [ ] No critical bugs
- [ ] AI debugging successful
- [ ] Gameplay is fun and engaging
- [ ] All systems integrated correctly
- [ ] Bug fixes documented
- [ ] Balance adjustments made

### Step 9: Final Documentation & Delivery

- [ ] All documentation complete and accurate
- [ ] Project exports successfully
- [ ] Executable runs without errors
- [ ] AI debugging guide comprehensive
- [ ] Player guide complete
- [ ] README with setup instructions
- [ ] Ready for delivery

---

## Appendix D: Success Metrics Checklist

### Technical Metrics

- [ ] FPS: 30+ minimum, 60+ target
- [ ] Memory usage: Under 300MB
- [ ] Unit count: 50 units per battle working
- [ ] Map size: 50×50 tiles rendering correctly
- [ ] Load times: Under 3 seconds

### Gameplay Metrics

- [ ] Core loop functional: Combat → Information → Command → Decision
- [ ] All 4 directional attacks working
- [ ] Blocking system functional
- [ ] Information retrieval working (scouts deploy, timing accurate)
- [ ] Army command system working (select, move, attack)
- [ ] Meeting system working (tactical decisions, timer, consequences)
- [ ] Skill system working (2 skills, XP, leveling)

### AI Debugging Metrics

- [ ] Game state exportable to JSON
- [ ] All CLI commands functional
- [ ] State inspection works for all systems
- [ ] Automated tests run via command line
- [ ] Performance monitoring functional

### Art & Audio Metrics

- [ ] All art assets generated (6 tiles, 40 sprites, 4 icons, 10 UI, 3 backgrounds)
- [ ] Visual style consistent (traditional Japanese aesthetic)
- [ ] No broken assets or textures
- [ ] Sound effects implemented (if time permits)
- [ ] Music implemented (if time permits)

### Documentation Metrics

- [ ] GDD complete (9 documents)
- [ ] AI debugging guide comprehensive
- [ ] Player guide complete with controls and mechanics
- [ ] README with setup instructions
- [ ] Technical documentation complete (API, data structures)

### Quality Metrics

- [ ] No critical bugs (game-breaking, crashes)
- [ ] Major bugs: Under 5
- [ ] Minor bugs: Under 10
- [ ] UI responsive and intuitive
- [ ] Game is fun and engaging (tested for at least 1 hour)

---

## Appendix E: Glossary

### Game-Specific Terms

- **Fog of War**: Visual and informational blindness in unexplored areas
- **Information Warfare**: Strategic system where information is a valuable resource
- **Perch Interface**: Semi-transparent UI panel displaying game information and decisions
- **Shogun General**: Player's primary role with command and decision-making abilities
- **Tactical Meeting**: Real-time battlefield decision interface (30-second timer)
- **Strategic Meeting**: Long-term policy decision interface (deferred to future)
- **Skill Carry-Over**: Ability to retain skill proficiency when switching roles (future feature)
- **Scout**: Unit deployed to gather information on enemy positions
- **Information Accuracy**: Percentage (0-100%) indicating reliability of intelligence
- **Tactical Insight**: Passive skill increasing information accuracy by +10-30%
- **Charisma**: Passive skill increasing ally combat effectiveness by +5-15%

### Technical Terms

- **AI Agent**: Artificial intelligence system capable of analyzing game state and making decisions
- **CLI (Command Line Interface): Text-based interface for debugging and automation
- **Godot**: Game engine used for development
- **GDScript**: Scripting language used in Godot (Python-like syntax)
- **GUT (Godot Unit Test)**: Testing framework for automated testing in Godot
- **Headless Mode**: Running Godot without graphical interface (for automated testing)
- **TileMap**: Godot system for rendering tile-based game worlds
- **Sprite2D**: Godot node for rendering 2D sprite graphics
- **Singleton**: Design pattern where only one instance of a class exists
- **JSON**: JavaScript Object Notation, format for data storage and exchange
- **FPS (Frames Per Second)**: Measure of rendering performance
- **LOD (Level of Detail)**: Technique for optimizing rendering of distant objects
- **Pathfinding**: Algorithm for finding optimal route between two points
- **A* Algorithm**: Popular pathfinding algorithm
- **Object Pooling**: Memory optimization technique for reusing objects
- **Seamless Tiling**: Texture pattern that tiles seamlessly without visible edges

### Art Style Terms

- **Sumi-e**: Traditional Japanese ink wash painting technique
- **Ukiyo-e**: Japanese woodblock print style
- **Kanji**: Japanese writing system characters
- **Tenshu**: Main keep or tower of a Japanese castle
- **Yagura**: Corner tower or turret of a Japanese castle
- **Sensu**: Traditional Japanese folding fan
- **Asanoha**: Traditional Japanese hemp leaf pattern
- **Seigaiha**: Traditional Japanese geometric pattern

### Weapon Terms

- **Katana**: Traditional Japanese sword
- **Yumi**: Japanese longbow
- **Naginata**: Japanese polearm with curved blade
- **Yari**: Japanese spear

---

**Document Version**: 1.0
**Last Updated**: 2025-01-11
