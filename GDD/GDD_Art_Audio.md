# Way of Shogun - Art & Audio Specifications

## 1. Art Style Guide

### 1.1 Visual Style References

**Primary Style: Sumi-e (Ink Wash)**:
- Traditional Japanese ink wash painting technique
- Black ink on parchment or paper background
- Minimalist aesthetic with subtle details
- Monochromatic base with accent colors (red, gold, blue)

**Secondary Style: Ukiyo-e**:
- Woodblock print style
- Flat colors, bold outlines
- Character portraits and UI elements
- Traditional Japanese motifs

**Color Palette**:
- **Faction Colors**:
  - Azure Dragon: #1E90FF (blue)
  - Crimson Phoenix: #DC143C (red)
  - Gold (Neutral): #FFD700 (gold)
- **Natural Colors**:
  - Plains: #90EE90 (light green)
  - Forest: #228B22 (dark green)
  - Mountains: #808080 (grey)
  - Rivers: #4169E1 (blue)
  - Parchment: #F5DEB3 (tan)
- **UI Colors**:
  - Text: #000000 (black) on parchment
  - Borders: #2C1810 (dark brown)
  - Highlights: #FFD700 (gold)
  - Shadows: #1A0F18 (dark grey)

### 1.2 Art Style Guidelines

**Map Tiles**:
- Sumi-e style with minimalism
- Seamless tiling (no visible edges)
- Consistent lighting (sun from top-left)
- Subtle texture variations

**Character Sprites**:
- Ukiyo-e inspired character portraits
- Clear outlines for visibility
- Distinct faction colors
- 8-directional animation frames

**Army Icons**:
- Stylized kanji characters
- Traditional Japanese military banners
- High contrast for visibility
- Faction color coding

**UI Elements**:
- Semi-transparent backgrounds (70% opacity)
- Traditional Japanese patterns (asanoha, seigaiha)
- Clear, readable fonts
- Muted color palette

---

## 2. AI Art Generation Prompts

### 2.1 Map Tiles

**Plains Tile**:
```
Prompt: "Traditional Japanese ink wash style, feudal Japan grassland, minimalist, 2D game art, 64x64 pixels, seamless tiling, soft green tones, subtle grass texture variation"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw
Alternative (DALL-E): "Sumi-e style grassland, feudal Japan, 64x64 pixel art, seamless tile, minimalism"
Alternative (Stable Diffusion): "Use ControlNet for consistency, sumi-e style, grassland, seamless tiling"
```

**Forest Tile**:
```
Prompt: "Japanese ink wash forest with stylized pine trees, feudal Japan, 2D game art, 64x64 pixels, seamless tiling, dark green tones, subtle depth with tree layering"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --no trees (to avoid 3D trees)
Alternative (DALL-E): "Sumi-e style forest, pine trees, feudal Japan, 64x64 pixel art, seamless tile"
Alternative (Stable Diffusion): "Use ControlNet, sumi-e style, pine forest, seamless tiling, dark green"
```

**Mountains Tile**:
```
Prompt: "Sumi-e style mountain ranges, traditional Japanese art, feudal Japan, 2D game art, 64x64 pixels, seamless tiling, grey tones, minimal detail, distant peak effect"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --no realistic (to avoid 3D mountains)
Alternative (DALL-E): "Ink wash mountains, feudal Japan, 64x64 pixel art, seamless tile"
Alternative (Stable Diffusion): "Use ControlNet, sumi-e style, mountain ranges, seamless tiling, grey"
```

**River Tile**:
```
Prompt: "Japanese ink wash river, flowing water, feudal Japan, 2D game art, 64x64 pixels, seamless tiling, blue tones, subtle water texture, bank details"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --no photorealistic
Alternative (DALL-E): "Sumi-e style river, feudal Japan, 64x64 pixel art, seamless tile"
Alternative (Stable Diffusion): "Use ControlNet, sumi-e style, river, seamless tiling, blue"
```

**Castle Tile**:
```
Prompt: "Traditional Japanese castle architecture, tenshu and yagura towers, feudal Japan, 2D game art, 96x96 pixels, sumi-e style, stone walls, wooden structures, faction colors"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --no modern
Alternative (DALL-E): "Japanese castle, feudal Japan, 96x96 pixel art, tenshu, yagura, traditional architecture"
Alternative (Stable Diffusion): "Use ControlNet, Japanese castle, traditional architecture, stone and wood"
```

**Village Tile**:
```
Prompt: "Traditional Japanese village, rural houses, rice paddies, feudal Japan, 2D game art, 64x64 pixels, sumi-e style, wooden structures, green fields, faction flags"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --no modern
Alternative (DALL-E): "Japanese village, feudal Japan, 64x64 pixel art, traditional houses, rice paddies"
Alternative (Stable Diffusion): "Use ControlNet, Japanese village, traditional houses, rice paddies"
```

### 2.2 Character Sprites

**Shogun General Portrait**:
```
Prompt: "Ukiyo-e style samurai portrait, feudal Japan, minimalist, 2D game character, 96x96 pixels, facing forward, traditional armor, katana at hip, noble expression, faction colors (blue or red)"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5 (Japanese art style)
Alternative (DALL-E): "Ukiyo-e style samurai portrait, feudal Japan, 96x96 pixel art, facing forward, traditional armor"
Alternative (Stable Diffusion): "Use ControlNet, ukiyo-e style, samurai portrait, traditional armor, katana"
```

**Infantry Sprite**:
```
Prompt: "Stylized Japanese foot soldier, feudal Japan, 2D game sprite, 64x64 pixels, 8-directional animation, traditional armor, spear or sword, faction colors, clear outlines"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5 --multiple (for variations)
Alternative (DALL-E): "Japanese infantry soldier, feudal Japan, 64x64 pixel art, 8-directional, traditional armor"
Alternative (Stable Diffusion): "Use ControlNet, Japanese infantry, traditional armor, spear, 8 directions"
```

**Cavalry Sprite**:
```
Prompt: "Japanese cavalry, feudal Japan, 2D game sprite, 64x64 pixels, 8-directional animation, horse with rider, traditional armor, faction colors, clear outlines"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5 --multiple
Alternative (DALL-E): "Japanese cavalry, feudal Japan, 64x64 pixel art, 8-directional, horse with rider"
Alternative (Stable Diffusion): "Use ControlNet, Japanese cavalry, horse with rider, 8 directions"
```

**Archer Sprite**:
```
Prompt: "Japanese archer, feudal Japan, 2D game sprite, 64x64 pixels, 8-directional animation, traditional armor, yumi longbow, faction colors, clear outlines"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5 --multiple
Alternative (DALL-E): "Japanese archer, feudal Japan, 64x64 pixel art, 8-directional, yumi bow"
Alternative (Stable Diffusion): "Use ControlNet, Japanese archer, traditional armor, yumi bow, 8 directions"
```

**Scout Sprite**:
```
Prompt: "Japanese scout, feudal Japan, 2D game sprite, 64x64 pixels, 8-directional animation, light armor, stealthy appearance, faction colors, clear outlines"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5 --multiple
Alternative (DALL-E): "Japanese scout, feudal Japan, 64x64 pixel art, 8-directional, light armor"
Alternative (Stable Diffusion): "Use ControlNet, Japanese scout, light armor, stealthy, 8 directions"
```

### 2.3 Army Icons (Chess-Style)

**Infantry Icon**:
```
Prompt: "Traditional Japanese kanji banner, feudal Japan, minimalist, 2D game icon, 64x64 pixels, kanji for 'infantry' (歩兵), faction colors (blue or red), simple bold design"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5 --no realistic
Alternative (DALL-E): "Japanese kanji banner, feudal Japan, 64x64 pixel art, 歩兵 kanji, minimalism"
Alternative (Stable Diffusion): "Use ControlNet, Japanese kanji, 歩兵, minimalist, faction colors"
```

**Cavalry Icon**:
```
Prompt: "Traditional Japanese kanji banner, feudal Japan, minimalist, 2D game icon, 64x64 pixels, kanji for 'cavalry' (騎兵), faction colors (blue or red), simple bold design"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5 --no realistic
Alternative (DALL-E): "Japanese kanji banner, feudal Japan, 64x64 pixel art, 騎兵 kanji, minimalism"
Alternative (Stable Diffusion): "Use ControlNet, Japanese kanji, 騎兵, minimalist, faction colors"
```

**Archer Icon**:
```
Prompt: "Traditional Japanese kanji banner, feudal Japan, minimalist, 2D game icon, 64x64 pixels, kanji for 'archer' (弓兵), faction colors (blue or red), simple bold design"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5 --no realistic
Alternative (DALL-E): "Japanese kanji banner, feudal Japan, 64x64 pixel art, 弓兵 kanji, minimalism"
Alternative (Stable Diffusion): "Use ControlNet, Japanese kanji, 弓兵, minimalist, faction colors"
```

**Faction Banner Icon**:
```
Prompt: "Traditional Japanese fan (sensu) banner, feudal Japan, minimalist, 2D game icon, 64x64 pixels, faction colors (blue or red), simple elegant design"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5 --no realistic
Alternative (DALL-E): "Japanese fan banner, feudal Japan, 64x64 pixel art, sensu fan, minimalism"
Alternative (Stable Diffusion): "Use ControlNet, Japanese fan banner, sensu, minimalist, faction colors"
```

### 2.4 UI Elements

**Perch Interface Panel**:
```
Prompt: "Semi-transparent traditional Japanese UI panel, ink wash aesthetic, feudal Japan, 2D game UI, muted colors, parchment background, subtle texture, traditional Japanese patterns (asanoha, seigaiha), 70% opacity"
Tool: Midjourney
Parameters: --ar 16:9 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese UI panel, feudal Japan, 2D game UI, semi-transparent, parchment, asanoha pattern"
Alternative (Stable Diffusion): "Use ControlNet, Japanese UI panel, parchment, asanoha pattern, semi-transparent"
```

**Button Design**:
```
Prompt: "Traditional Japanese button design, asanoha pattern, minimalist, 2D game UI, muted colors, subtle texture, clear text area, gold or dark border"
Tool: Midjourney
Parameters: --ar 2:1 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese button, feudal Japan, 2D game UI, asanoha pattern, minimalism"
Alternative (Stable Diffusion): "Use ControlNet, Japanese button, asanoha pattern, minimalist"
```

**Information Card**:
```
Prompt: "Japanese parchment style, ink wash aesthetic, feudal Japan, 2D game UI, information card, subtle texture, traditional paper, dark text area, gold or brown border"
Tool: Midjourney
Parameters: --ar 3:2 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese parchment card, feudal Japan, 2D game UI, information display, minimalism"
Alternative (Stable Diffusion): "Use ControlNet, Japanese parchment, traditional paper, ink wash, information card"
```

**Skill Icon**:
```
Prompt: "Traditional Japanese skill icon, feudal Japan, minimalist, 2D game UI, circular or square design, faction colors, subtle texture, clear symbol"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5 --multiple
Alternative (DALL-E): "Japanese skill icon, feudal Japan, 2D game UI, minimalist, circular"
Alternative (Stable Diffusion): "Use ControlNet, Japanese skill icon, minimalist, faction colors"
```

**Health/Mana Bar**:
```
Prompt: "Traditional Japanese health/mana bar design, feudal Japan, minimalist, 2D game UI, horizontal bar, faction colors, subtle texture, elegant borders"
Tool: Midjourney
Parameters: --ar 3:1 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese health bar, feudal Japan, 2D game UI, minimalist, horizontal"
Alternative (Stable Diffusion): "Use ControlNet, Japanese health bar, minimalist, faction colors"
```

**Timer Interface**:
```
Prompt: "Traditional Japanese timer interface, feudal Japan, minimalist, 2D game UI, circular or linear progress, faction colors, subtle texture, clear numbers"
Tool: Midjourney
Parameters: --ar 2:1 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese timer, feudal Japan, 2D game UI, minimalist, circular"
Alternative (Stable Diffusion): "Use ControlNet, Japanese timer, minimalist, faction colors"
```

**Selection Indicator**:
```
Prompt: "Traditional Japanese selection indicator, feudal Japan, minimalist, 2D game UI, glowing border or highlight, gold color, subtle texture, clear visibility"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese selection indicator, feudal Japan, 2D game UI, gold glow"
Alternative (Stable Diffusion): "Use ControlNet, Japanese selection indicator, gold glow, minimalist"
```

**Status Display**:
```
Prompt: "Traditional Japanese status display, feudal Japan, minimalist, 2D game UI, information layout, faction colors, subtle texture, readable text"
Tool: Midjourney
Parameters: --ar 3:2 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese status display, feudal Japan, 2D game UI, minimalist, information layout"
Alternative (Stable Diffusion): "Use ControlNet, Japanese status display, minimalist, readable"
```

**Movement Preview**:
```
Prompt: "Traditional Japanese movement preview, feudal Japan, minimalist, 2D game UI, dotted line or path, faction colors, subtle texture, clear visibility"
Tool: Midjourney
Parameters: --ar 3:2 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese movement path, feudal Japan, 2D game UI, dotted line, minimalist"
Alternative (Stable Diffusion): "Use ControlNet, Japanese movement path, dotted line, minimalist"
```

**Damage Indicator**:
```
Prompt: "Traditional Japanese damage indicator, feudal Japan, minimalist, 2D game UI, floating text or icon, red color, subtle texture, clear visibility"
Tool: Midjourney
Parameters: --ar 1:1 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese damage indicator, feudal Japan, 2D game UI, red floating text"
Alternative (Stable Diffusion): "Use ControlNet, Japanese damage indicator, red, minimalist"
```

### 2.5 Backgrounds

**Menu Background**:
```
Prompt: "Traditional Japanese landscape, Mount Fuji, ink wash style, feudal Japan, 2D game art, 1920x1080 pixels, minimalist, serene atmosphere, soft colors, subtle clouds, distant mountains"
Tool: Midjourney
Parameters: --ar 16:9 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese landscape, Mount Fuji, feudal Japan, 1920x1080, sumi-e style, minimalist"
Alternative (Stable Diffusion): "Use ControlNet, Japanese landscape, Mount Fuji, sumi-e style, minimalist"
```

**Combat Background**:
```
Prompt: "Battlefield scene, feudal Japan, minimalist, ink wash style, 2D game art, 1920x1080 pixels, plains or forest terrain, subtle movement, faction colors present, atmospheric"
Tool: Midjourney
Parameters: --ar 16:9 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese battlefield, feudal Japan, 1920x1080, sumi-e style, minimalist"
Alternative (Stable Diffusion): "Use ControlNet, Japanese battlefield, sumi-e style, minimalist"
```

**Meeting Background**:
```
Prompt: "Traditional Japanese meeting room, feudal Japan, minimalist, ink wash style, 2D game art, 1920x1080 pixels, tatami mats, shoji screens, subtle lighting, peaceful atmosphere"
Tool: Midjourney
Parameters: --ar 16:9 --v 6 --style raw --niji 5
Alternative (DALL-E): "Japanese meeting room, feudal Japan, 1920x1080, sumi-e style, minimalist"
Alternative (Stable Diffusion): "Use ControlNet, Japanese meeting room, tatami, shoji screens, minimalist"
```

---

## 3. Recommended AI Tools

### 3.1 Midjourney

**Best For**: Landscapes, backgrounds, textures
**Parameters**:
- `--ar 1:1` for square tiles (64×64, 96×96)
- `--ar 16:9` for backgrounds (1920×1080)
- `--ar 2:1` for UI elements
- `--v 6` for quality
- `--style raw` for minimal AI interpretation
- `--niji 5` for Japanese art style

**Workflow**:
1. Generate multiple variations
2. Select best result
3. Upscale if needed
4. Post-process in image editor for exact dimensions

### 3.2 DALL-E 3

**Best For**: UI elements, icons, character portraits
**Parameters**:
- Specify exact dimensions in prompt
- Clear description of art style
- Request multiple variations if needed

**Workflow**:
1. Generate with specific dimensions
2. Review and refine prompt
3. Generate final version
4. Post-process for consistency

### 3.3 Stable Diffusion

**Best For**: Consistent character sprites, tile sets
**Parameters**:
- Use ControlNet for consistency
- Custom models for Japanese art style
- Inpainting for variations

**Workflow**:
1. Train custom model on Japanese art style
2. Use ControlNet for consistent dimensions
3. Generate batch variations
4. Inpaint for consistency fixes
5. Post-process for final polish

---

## 4. MVP Asset List (Streamlined)

### 4.1 Map Tiles (6 total)

- **Plains**: 1 variation
- **Forest**: 2 variations (dense, sparse)
- **Mountains**: 2 variations (low, high)
- **Rivers**: 1 variation (straight, with转弯)

**Total**: 6 tiles × 64×64 pixels

### 4.2 Character Sprites (40 total)

**Shogun General**: 1 character × 4 directions × 2 frames = 8 sprites
**Infantry**: 1 type × 2 factions × 4 directions × 2 frames = 16 sprites
**Cavalry**: 1 type × 2 factions × 4 directions × 2 frames = 16 sprites

**Total**: 40 sprites × 64×64 pixels (or 96×96 for General)

### 4.3 Army Icons (4 total)

- **Infantry Icon**: 2 factions = 2 icons
- **Cavalry Icon**: 2 factions = 2 icons

**Total**: 4 icons × 64×64 pixels

### 4.4 UI Elements (10 total)

- **Perch Interface Panel**: 1 variation
- **Button Design**: 1 variation
- **Information Card**: 1 variation
- **Skill Icon**: 1 variation
- **Health/Mana Bar**: 1 variation
- **Timer Interface**: 1 variation
- **Selection Indicator**: 1 variation
- **Status Display**: 1 variation
- **Movement Preview**: 1 variation
- **Damage Indicator**: 1 variation

**Total**: 10 UI elements (varying dimensions)

### 4.5 Backgrounds (3 total)

- **Menu Background**: 1 variation
- **Combat Background**: 1 variation
- **Meeting Background**: 1 variation

**Total**: 3 backgrounds × 1920×1080 pixels

---

## 5. Audio Style & References

### 5.1 Music Style

**Traditional Japanese Instruments**:
- **Koto**: 13-string zither, gentle melodies
- **Shakuhachi**: Bamboo flute, atmospheric tones
- **Taiko Drums**: Percussion, battle intensity
- **Shamisen**: Three-stringed lute, dramatic moments

**Minimalist Approach**:
- Simple melodies, not overly complex
- Ambient layers for atmosphere
- Dynamic intensity based on gameplay state
- Seamless looping

**Dynamic Music**:
- **Exploration**: Gentle koto/shakuhachi, peaceful
- **Combat**: Taiko drums, intense shakuhachi, aggressive
- **Meeting**: Gentle koto, calm, meditative
- **Victory**: Celebratory taiko, triumphant
- **Defeat**: Somber shakuhachi, melancholic

**Reference Tracks**:
- Akira Kosemura's samurai film scores
- Nier: Automata (Japanese tracks)
- Ghost of Tsushima (Japanese-inspired)
- Traditional Japanese music compilations

### 5.2 Sound Effects

**Weapon Sounds**:
- **Katana**: Sharp metallic slash, woosh sounds
- **Yumi**: Bow string twang, arrow flight
- **Naginata**: Polearm swoosh, wooden impact
- **Yari**: Spear thrust, metallic clink

**Environmental Sounds**:
- **Nature Ambience**: Wind through trees, birds, water flowing
- **Battlefield Noise**: Shouting, clashing weapons, horses
- **Weather Effects**: Rain, thunder, wind

**UI Sounds**:
- **Button Clicks**: Subtle wooden click or paper rustle
- **Confirmation**: Soft chime
- **Error**: Low wooden thud
- **Selection**: Gentle tap

**Voice Acting** (Optional):
- **Character Grunts**: Japanese-inspired battle cries
- **Command Voices**: Shout orders in Japanese
- **Meeting Announcements**: Formal Japanese speech

### 5.3 Audio Generation Guidelines

**Free Sound Libraries**:
- **Freesound.org**: CC-BY licensed sounds
- **OpenGameArt.org**: Free game audio
- **ZapSplat**: Free sound effects

**AI Audio Tools**:
- **Suno**: Music generation (traditional Japanese style)
- **ElevenLabs**: Voice acting (if needed)
- **Soundraw**: AI sound effect generation

**Recording Custom Sounds** (Recommended):
- Use traditional instruments for authenticity
- Record in proper environment (reverb, echo)
- Clean audio with Audacity or similar
- Export as Ogg Vorbis for Godot

---

## 6. UI/UX Design Principles

### 6.1 Perch-Style Interface

**Semi-Transparent Overlays**:
- Background opacity: 70%
- Blur effect: Slight blur on game behind interface
- Borders: Traditional Japanese patterns

**Information Hierarchy**:
- **Central Perch**: Most important information (40% width)
- **Left Perch**: Context information (30% width)
- **Right Perch**: Decision options (30% width)
- **Bottom**: Status and timer (full width)

### 6.2 Visual Feedback

**Active States**:
- Golden glow for selected units
- Red outline for enemies
- Blue tint for fog of war areas
- Animated icons for active skills

**Information Accuracy**:
- Color grading based on accuracy:
  - 90-100%: Clear, sharp display
  - 70-89%: Slightly blurred
  - 50-69%: Moderately blurred
  - <50%: Heavily blurred, question marks

**Decision Consequences**:
- Show numerical changes (+/-)
- Color code: Green for positive, red for negative
- Duration indicators for temporary effects

### 6.3 Responsive Design

**Resolution Scaling**:
- Minimum: 1280×720
- Target: 1920×1080
- Maximum: 4K (2560×1440)
- Integer scaling for pixel-perfect rendering

**Accessibility**:
- Colorblind modes (protanopia, deuteranopia, tritanopia)
- Text scaling options (100%, 125%, 150%)
- High contrast mode (black/white or yellow/blue)
- Customizable opacity for UI panels

### 6.4 Polish Requirements

**Animations**:
- Smooth transitions between UI states (0.2-0.3 seconds)
- Hover effects on buttons (subtle scale or brightness)
- Click animations (slight scale down then up)
- Damage numbers floating upward (1-2 seconds)

**Typography**:
- Traditional Japanese-inspired fonts
- Clear, readable at all sizes
- 16px body text, 20px headers, 24px titles
- High contrast for readability

---

**Document Version**: 1.0
**Last Updated**: 2025-01-11
**Next Review**: After Step 7 completion
