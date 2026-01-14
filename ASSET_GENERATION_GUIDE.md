# Way of Shogun - AI Art Generation Guide

**Step 7: AI Art Generation & Integration**
**Date**: January 14, 2026
**Status**: ✅ READY FOR AI ART GENERATION

---

## Overview

This guide provides comprehensive AI art generation prompts and integration instructions for all game assets. All assets follow a traditional Japanese aesthetic (Sumi-e/Ukiyo-e styles).

---

## Asset Requirements Summary

### Total Assets to Generate: 63 items

1. **Map Tiles**: 6 variations (64x64px)
2. **Character Sprites**: 40 total (64x64px)
   - Shogun General: 8 sprites (4 directions × 2 frames × 2 factions)
   - Infantry: 16 sprites (4 directions × 2 frames × 2 factions)
   - Cavalry: 16 sprites (4 directions × 2 frames × 2 factions)
3. **Army Icons**: 4 total (64x64px)
4. **UI Elements**: 10 total (various sizes)
5. **Backgrounds**: 3 total (1920x1080px)

---

## Color Palette

### Faction Colors
- Azure Dragon: `#1E90FF` (blue)
- Crimson Phoenix: `#DC143C` (red)
- Gold (Neutral): `#FFD700` (gold)

### Natural Colors
- Plains: `#90EE90` (light green)
- Forest: `#228B22` (dark green)
- Mountains: `#808080` (grey)
- Rivers: `#4169E1` (blue)
- Parchment: `#F5DEB3` (tan)

### UI Colors
- Text: `#000000` (black) on parchment
- Borders: `#2C1810` (dark brown)
- Highlights: `#FFD700` (gold)
- Shadows: `#1A0F18` (dark grey)

---

## 1. Map Tiles (6 total)

### 1.1 Plains Tile (1 variation)
- **Size**: 64x64 pixels
- **Style**: Sumi-e (ink wash)
- **Prompt**:
  ```
  "Traditional Japanese ink wash style, feudal Japan grassland, minimalist, 
  2D game art, 64x64 pixels, seamless tiling, soft green tones, 
  subtle grass texture variation"
  ```
- **Midjourney Parameters**: `--ar 1:1 --v 6 --style raw`
- **Output**: `assets/tiles/plains.png`

### 1.2 Forest Tile (2 variations)
- **Size**: 64x64 pixels
- **Style**: Sumi-e with stylized pine trees
- **Prompt**:
  ```
  "Japanese ink wash forest with stylized pine trees, feudal Japan, 
  2D game art, 64x64 pixels, seamless tiling, dark green tones, 
  subtle depth with tree layering"
  ```
- **Midjourney Parameters**: `--ar 1:1 --v 6 --style raw --no trees`
- **Output**: `assets/tiles/forest_01.png`, `assets/tiles/forest_02.png`

### 1.3 Mountains Tile (2 variations)
- **Size**: 64x64 pixels
- **Style**: Sumi-e mountain ranges
- **Prompt**:
  ```
  "Sumi-e style mountain ranges, traditional Japanese art, feudal Japan, 
  2D game art, 64x64 pixels, seamless tiling, grey tones, 
  minimal detail, distant peak effect"
  ```
- **Midjourney Parameters**: `--ar 1:1 --v 6 --style raw --no realistic`
- **Output**: `assets/tiles/mountains_01.png`, `assets/tiles/mountains_02.png`

### 1.4 Rivers Tile (1 variation)
- **Size**: 64x64 pixels
- **Style**: Sumi-e flowing water
- **Prompt**:
  ```
  "Japanese ink wash river, flowing water, feudal Japan, 2D game art, 
  64x64 pixels, seamless tiling, blue tones, subtle water texture, 
  bank details"
  ```
- **Midjourney Parameters**: `--ar 1:1 --v 6 --style raw --no photorealistic`
- **Output**: `assets/tiles/river.png`

---

## 2. Character Sprites (40 total)

### 2.1 Shogun General (8 sprites)
- **Size**: 96x96 pixels
- **Style**: Ukiyo-e portrait style
- **Prompt**:
  ```
  "Ukiyo-e style samurai portrait, feudal Japan, minimalist, 2D game character, 
  96x96 pixels, facing forward, traditional armor, katana at hip, 
  noble expression, faction colors (blue or red)"
  ```
- **Midjourney Parameters**: `--ar 1:1 --v 6 --style raw --niji 5`
- **Directions**: North, South, East, West (4 directions × 2 animation frames)
- **Factions**: Blue (player), Red (enemy)
- **Output**: `assets/sprites/shogun_blue_n_01.png`, etc.

### 2.2 Infantry (16 sprites)
- **Size**: 64x64 pixels
- **Style**: Stylized foot soldier
- **Prompt**:
  ```
  "Stylized Japanese foot soldier, feudal Japan, 2D game sprite, 
  64x64 pixels, 8-directional animation, traditional armor, 
  spear or sword, faction colors, clear outlines"
  ```
- **Midjourney Parameters**: `--ar 1:1 --v 6 --style raw --niji 5 --multiple`
- **Directions**: 8 directions × 2 frames
- **Factions**: Blue, Red
- **Output**: `assets/sprites/infantry_blue_n_01.png`, etc.

### 2.3 Cavalry (16 sprites)
- **Size**: 64x64 pixels
- **Style**: Horse with rider
- **Prompt**:
  ```
  "Japanese cavalry, feudal Japan, 2D game sprite, 64x64 pixels, 
  8-directional animation, horse with rider, traditional armor, 
  faction colors, clear outlines"
  ```
- **Midjourney Parameters**: `--ar 1:1 --v 6 --style raw --niji 5 --multiple`
- **Directions**: 8 directions × 2 frames
- **Factions**: Blue, Red
- **Output**: `assets/sprites/cavalry_blue_n_01.png`, etc.

---

## 3. Army Icons (4 total)

### 3.1 Infantry Icon (2 factions)
- **Size**: 64x64 pixels
- **Style**: Kanji banner
- **Prompt**:
  ```
  "Traditional Japanese kanji banner, feudal Japan, minimalist, 2D game icon, 
  64x64 pixels, kanji for 'infantry' (歩兵), faction colors (blue or red), 
  simple bold design"
  ```
- **Output**: `assets/ui/icon_infantry_blue.png`, `assets/ui/icon_infantry_red.png`

### 3.2 Cavalry Icon (2 factions)
- **Size**: 64x64 pixels
- **Style**: Kanji banner
- **Prompt**:
  ```
  "Traditional Japanese kanji banner, feudal Japan, minimalist, 2D game icon, 
  64x64 pixels, kanji for 'cavalry' (騎兵), faction colors (blue or red), 
  simple bold design"
  ```
- **Output**: `assets/ui/icon_cavalry_blue.png`, `assets/ui/icon_cavalry_red.png`

---

## 4. UI Elements (10 total)

### 4.1 Perch Interface Panel
- **Size**: 350x600 pixels
- **Style**: Semi-transparent traditional Japanese
- **Prompt**:
  ```
  "Semi-transparent traditional Japanese UI panel, ink wash aesthetic, 
  feudal Japan, 2D game UI, muted colors, parchment background, 
  subtle texture, traditional Japanese patterns (asanoha, seigaiha), 70% opacity"
  ```
- **Midjourney Parameters**: `--ar 1:2 --v 6 --style raw --niji 5`
- **Output**: `assets/ui/perch_interface.png`

### 4.2 Button Design
- **Size**: 150x50 pixels
- **Prompt**:
  ```
  "Traditional Japanese button design, asanoha pattern, minimalist, 
  2D game UI, muted colors, subtle texture, clear text area, 
  gold or dark border"
  ```
- **Output**: `assets/ui/button_normal.png`, `assets/ui/button_hover.png`, `assets/ui/button_pressed.png`

### 4.3 Health/Mana Bar
- **Size**: 200x30 pixels
- **Prompt**:
  ```
  "Traditional Japanese health/mana bar design, feudal Japan, minimalist, 
  2D game UI, horizontal bar, faction colors, subtle texture, 
  elegant borders"
  ```
- **Output**: `assets/ui/health_bar.png`, `assets/ui/mana_bar.png`

---

## 5. Backgrounds (3 total)

### 5.1 Menu Background
- **Size**: 1920x1080 pixels
- **Prompt**:
  ```
  "Traditional Japanese landscape, Mount Fuji, ink wash style, feudal Japan, 
  2D game art, 1920x1080 pixels, minimalist, serene atmosphere, 
  soft colors, subtle clouds, distant mountains"
  ```
- **Midjourney Parameters**: `--ar 16:9 --v 6 --style raw --niji 5`
- **Output**: `assets/backgrounds/menu.png`

### 5.2 Combat Background
- **Size**: 1920x1080 pixels
- **Prompt**:
  ```
  "Battlefield scene, feudal Japan, minimalist, ink wash style, 
  2D game art, 1920x1080 pixels, plains or forest terrain, 
  subtle movement, faction colors present, atmospheric"
  ```
- **Output**: `assets/backgrounds/combat.png`

### 5.3 Meeting Background
- **Size**: 1920x1080 pixels
- **Prompt**:
  ```
  "Traditional Japanese meeting room, feudal Japan, minimalist, ink wash style, 
  2D game art, 1920x1080 pixels, tatami mats, shoji screens, 
  subtle lighting, peaceful atmosphere"
  ```
- **Output**: `assets/backgrounds/meeting.png`

---

## Integration Steps

### 1. Generate Assets
Use the prompts above with your preferred AI tool:
- **Midjourney**: `--ar X:Y --v 6 --style raw --niji 5`
- **DALL-E 3**: Direct prompt usage
- **Stable Diffusion**: Use ControlNet for consistency

### 2. Post-Processing
1. Resize to exact dimensions
2. Ensure PNG format with transparency
3. Apply consistent color grading
4. Verify seamless tiling for tiles

### 3. Import to Godot
1. Place generated assets in `assets/` folders
2. Godot will auto-import
3. Verify in Project tab
4. Update sprite references in code

### 4. Code Integration
Update texture references in scripts:
- `create_placeholder_texture()` calls → Load from assets
- TileMap atlas source → Use generated tiles
- Sprite textures → Use character sprites
- UI backgrounds → Use generated UI elements

---

## Quality Checklist

For each generated asset, verify:
- [ ] Matches specified dimensions
- [ ] Follows Japanese aesthetic (Sumi-e/Ukiyo-e)
- [ ] Uses correct faction colors
- [ ] Has transparent background (where needed)
- [ ] Clear and readable
- [ ] Seamless tiling (tiles)
- [ ] PNG format

---

## Alternative: Procedural Placeholders

If AI generation is unavailable, run `create_procedural_assets.gd` to generate placeholder assets matching the color palette and style guidelines.

---

**Document Version**: 1.0
**Last Updated**: January 14, 2026
**Next Step**: Step 8 - Integration & Testing
