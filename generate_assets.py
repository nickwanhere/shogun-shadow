#!/usr/bin/env python3

import os
from PIL import Image, ImageDraw
import math
import random

def generate_all_assets():
    print("Generating procedural assets...")
    
    os.makedirs("assets/tiles", exist_ok=True)
    os.makedirs("assets/sprites", exist_ok=True)
    os.makedirs("assets/ui", exist_ok=True)
    os.makedirs("assets/backgrounds", exist_ok=True)
    os.makedirs("assets/audio", exist_ok=True)
    
    generate_map_tiles()
    generate_character_sprites()
    generate_army_icons()
    generate_ui_elements()
    generate_backgrounds()
    
    print("All procedural assets generated!")

def generate_map_tiles():
    print("Generating map tiles...")
    
    create_plains_tile()
    create_forest_tile(1)
    create_forest_tile(2)
    create_mountains_tile(1)
    create_mountains_tile(2)
    create_river_tile()
    
    print("Map tiles generated!")

def create_plains_tile():
    image = Image.new('RGBA', (64, 64), (143, 238, 143, 255))
    pixels = image.load()
    
    for x in range(64):
        for y in range(64):
            noise = (math.sin(x * 0.2) + math.cos(y * 0.2)) * 0.1
            color = (143, 238, 143)
            pixels[x, y] = (
                max(0, min(255, int(color[0] + noise * 50))),
                max(0, min(255, int(color[1] + noise * 50))),
                max(0, min(255, int(color[2] + noise * 50))),
                255
            )
    
    image.save("assets/tiles/plains.png")

def create_forest_tile(variation):
    image = Image.new('RGBA', (64, 64), (34, 139, 34, 255))
    pixels = image.load()
    
    for i in range(3 + variation):
        tree_x = 10 + i * 15 + variation * 5
        tree_y = 10 + variation * 8
        draw_simple_tree(pixels, tree_x, tree_y, (26, 102, 26))
    
    filename = f"assets/tiles/forest_0{variation}.png"
    image.save(filename)

def draw_simple_tree(pixels, x, y, color):
    trunk_color = (102, 67, 33)
    
    for ty in range(20, 30):
        for tx in range(-2, 3):
            if 0 <= x + tx < 64 and 0 <= y + ty < 64:
                pixels[x + tx, y + ty] = trunk_color
    
    for py in range(-10, 20):
        for px in range(-8, 9):
            if 0 <= x + px < 64 and 0 <= y + py < 64:
                distance = math.sqrt(px * px + py * py)
                if distance < 8:
                    noise = random.random() * 0.1
                    pixels[x + px, y + py] = (
                        max(0, min(255, int(color[0] * (1 + noise)))),
                        max(0, min(255, int(color[1] * (1 + noise)))),
                        max(0, min(255, int(color[2] * (1 + noise)))),
                        255
                    )

def create_mountains_tile(variation):
    image = Image.new('RGBA', (64, 64), (128, 128, 128, 255))
    pixels = image.load()
    
    offset = variation * 10
    for x in range(64):
        mountain_height = int(20 + math.sin(x * 0.1 + offset) * 15 + math.sin(x * 0.2) * 5)
        for y in range(mountain_height, 64):
            shade = (y - mountain_height) / 64.0
            base_color = (128, 128, 128)
            pixels[x, y] = (
                max(0, min(255, int(base_color[0] - shade * 50))),
                max(0, min(255, int(base_color[1] - shade * 50))),
                max(0, min(255, int(base_color[2] - shade * 50))),
                255
            )
    
    filename = f"assets/tiles/mountains_0{variation}.png"
    image.save(filename)

def create_river_tile():
    image = Image.new('RGBA', (64, 64), (143, 238, 143, 255))
    pixels = image.load()
    
    bank_color = (143, 238, 143)
    water_color = (65, 105, 137)
    
    for x in range(64):
        river_center_y = 32 + math.sin(x * 0.15) * 5
        for y in range(64):
            distance = abs(y - river_center_y)
            if distance < 8:
                blend = 1.0 - (distance / 8.0)
                flow = math.sin(x * 0.2 + y * 0.1) * 0.1
                final_color = (
                    int(bank_color[0] * (1 - blend) + water_color[0] * blend),
                    int(bank_color[1] * (1 - blend) + water_color[1] * blend),
                    int(bank_color[2] * (1 - blend) + water_color[2] * blend),
                    255
                )
                pixels[x, y] = final_color
    
    image.save("assets/tiles/river.png")

def generate_character_sprites():
    print("Generating character sprites...")
    
    factions = ["blue", "red"]
    directions = ["n", "s", "e", "w"]
    
    for faction in factions:
        for direction in directions:
            for frame in [1, 2]:
                create_shogun_sprite(faction, direction, frame)
                create_infantry_sprite(faction, direction, frame)
                create_cavalry_sprite(faction, direction, frame)
    
    print("Character sprites generated!")

def create_shogun_sprite(faction, direction, frame):
    image = Image.new('RGBA', (96, 96), (0, 0, 0, 0))
    pixels = image.load()
    
    faction_color = (30, 144, 255) if faction == "blue" else (220, 20, 60)
    armor_color = (77, 77, 77)
    helmet_color = (128, 128, 128)
    
    draw_body_base(pixels, 96, 96, faction_color, armor_color)
    draw_helmet(pixels, 48, 25, helmet_color, faction_color)
    
    if frame == 2:
        offset = 2 if direction in ["n", "s"] else 1
        add_animation_offset(image, offset)
    
    filename = f"assets/sprites/shogun_{faction}_{direction}_0{frame}.png"
    image.save(filename)

def create_infantry_sprite(faction, direction, frame):
    image = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    pixels = image.load()
    
    faction_color = (30, 144, 255) if faction == "blue" else (220, 20, 60)
    armor_color = (102, 102, 102)
    
    draw_body_base(pixels, 64, 64, faction_color, armor_color)
    draw_spear(pixels, 32, 32, direction)
    
    if frame == 2:
        add_animation_offset(image, 1)
    
    filename = f"assets/sprites/infantry_{faction}_{direction}_0{frame}.png"
    image.save(filename)

def create_cavalry_sprite(faction, direction, frame):
    image = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    pixels = image.load()
    
    faction_color = (30, 144, 255) if faction == "blue" else (220, 20, 60)
    armor_color = (102, 102, 102)
    horse_color = (153, 128, 77)
    
    draw_horse(pixels, 32, 40, horse_color)
    draw_body_base(pixels, 64, 64, faction_color, armor_color, 32, 20)
    
    if frame == 2:
        add_animation_offset(image, 1)
    
    filename = f"assets/sprites/cavalry_{faction}_{direction}_0{frame}.png"
    image.save(filename)

def draw_body_base(pixels, width, height, faction_color, armor_color, ox=0, oy=0):
    center_x = width // 2
    center_y = height // 2
    
    for y in range(height):
        for x in range(width):
            dx = x - center_x
            dy = y - center_y
            distance = math.sqrt(dx * dx + dy * dy)
            
            if 0 <= x + ox < width and 0 <= y + oy < height:
                if distance < 15:
                    pixels[x + ox, y + oy] = armor_color + (255,)
                elif distance < 20 and abs(dx) < 8:
                    pixels[x + ox, y + oy] = faction_color + (255,)

def draw_helmet(pixels, x, y, color, accent_color):
    for dy in range(-10, 0):
        for dx in range(-6, 7):
            dist = math.sqrt(dx * dx + dy * dy)
            if dist < 6 and 0 <= x + dx < 96 and 0 <= y + dy < 96:
                pixels[x + dx, y + dy] = color + (255,)
    
    if 0 <= x < 96 and 0 <= y - 5 < 96:
        pixels[x, y - 5] = accent_color + (255,)

def draw_spear(pixels, x, y, direction):
    spear_color = (204, 179, 128)
    length = 20
    dx = 0
    dy = 0
    
    if direction == "n":
        dy = -1
    elif direction == "s":
        dy = 1
    elif direction == "e":
        dx = 1
    elif direction == "w":
        dx = -1
    
    for i in range(length):
        px = x + dx * i
        py = y + dy * i
        if 0 <= px < 64 and 0 <= py < 64:
            pixels[px, py] = spear_color + (255,)

def draw_horse(pixels, x, y, color):
    for dy in range(-10, 15):
        for dx in range(-12, 13):
            dist = math.sqrt(dx * dx + dy * dy)
            if dist < 12 and dy > -5 and 0 <= x + dx < 64 and 0 <= y + dy < 64:
                pixels[x + dx, y + dy] = color + (255,)
    
    if 0 <= x + 10 < 64 and 0 <= y - 8 < 64:
        pixels[x + 10, y - 8] = (0, 0, 0, 255)
    if 0 <= x - 10 < 64 and 0 <= y - 8 < 64:
        pixels[x - 10, y - 8] = (0, 0, 0, 255)

def add_animation_offset(image, offset):
    temp = image.copy()
    pixels_new = image.load()
    pixels_old = temp.load()
    
    for y in range(image.height):
        for x in range(image.width):
            new_y = y + offset
            if new_y < image.height:
                if pixels_old[x, y][3] > 0:
                    pixels_new[x, new_y] = pixels_old[x, y]

def generate_army_icons():
    print("Generating army icons...")
    
    create_kanji_icon("歩兵", "infantry_blue", (30, 144, 255))
    create_kanji_icon("歩兵", "infantry_red", (220, 20, 60))
    create_kanji_icon("騎兵", "cavalry_blue", (30, 144, 255))
    create_kanji_icon("騎兵", "cavalry_red", (220, 20, 60))
    
    print("Army icons generated!")

def create_kanji_icon(kanji, name, color):
    image = Image.new('RGBA', (64, 64), (245, 222, 179, 255))
    draw = ImageDraw.Draw(image)
    
    center_x = 32
    center_y = 32
    
    for angle in range(0, 360, 45):
        rad = math.radians(angle)
        x = center_x + math.cos(rad) * 25
        y = center_y + math.sin(rad) * 25
        if 0 <= x < 64 and 0 <= y < 64:
            draw.point((int(x), int(y)), fill=color + (255,))
    
    for i in range(10):
        x = center_x + math.cos(math.radians(i * 36)) * 15
        y = center_y + math.sin(math.radians(i * 36)) * 15
        if 0 <= x < 64 and 0 <= y < 64:
            draw.point((int(x), int(y)), fill=color + (255,))
    
    if 0 <= center_x < 64 and 0 <= center_y < 64:
        draw.point((center_x, center_y), fill=color + (255,))
    
    filename = f"assets/ui/{name}.png"
    image.save(filename)

def generate_ui_elements():
    print("Generating UI elements...")
    
    create_perch_interface()
    create_button("button_normal")
    create_button("button_hover")
    create_button("button_pressed")
    create_bar("health_bar", (255, 0, 0))
    create_bar("mana_bar", (0, 128, 255))
    
    print("UI elements generated!")

def create_perch_interface():
    image = Image.new('RGBA', (350, 600), (245, 222, 179, 178))
    draw = ImageDraw.Draw(image)
    
    border_color = (23, 9, 6)
    
    for x in range(350):
        draw.point((x, 0), fill=border_color + (255,))
        draw.point((x, 599), fill=border_color + (255,))
    
    for y in range(600):
        draw.point((0, y), fill=border_color + (255,))
        draw.point((349, y), fill=border_color + (255,))
    
    for i in range(0, 600, 20):
        shade = i / 600.0
        for x in range(10, 340):
            bg_color = (245, 222, 179)
            draw.point((x, i), fill=(
                max(0, min(255, int(bg_color[0] * (1 - shade * 0.2)))),
                max(0, min(255, int(bg_color[1] * (1 - shade * 0.2)))),
                max(0, min(255, int(bg_color[2] * (1 - shade * 0.2)))),
                178
            ))
    
    image.save("assets/ui/perch_interface.png")

def create_button(name):
    image = Image.new('RGBA', (150, 50), (245, 222, 179, 229))
    draw = ImageDraw.Draw(image)
    
    border_color = (23, 9, 6)
    
    for x in range(150):
        draw.point((x, 0), fill=border_color + (255,))
        draw.point((x, 49), fill=border_color + (255,))
    
    for y in range(50):
        draw.point((0, y), fill=border_color + (255,))
        draw.point((149, y), fill=border_color + (255,))
    
    pattern_color = (23, 9, 6, 25)
    for i in range(0, 150, 10):
        for j in range(0, 50, 10):
            if (i + j) % 20 == 0:
                draw.point((i, j), fill=pattern_color)
    
    filename = f"assets/ui/{name}.png"
    image.save(filename)

def create_bar(name, fill_color):
    image = Image.new('RGBA', (200, 30), (245, 222, 179, 178))
    draw = ImageDraw.Draw(image)
    
    border_color = (23, 9, 6)
    
    for x in range(200):
        draw.point((x, 0), fill=border_color + (255,))
        draw.point((x, 29), fill=border_color + (255,))
    
    for y in range(30):
        draw.point((0, y), fill=border_color + (255,))
        draw.point((199, y), fill=border_color + (255,))
    
    fill_width = 150
    for x in range(2, fill_width):
        for y in range(2, 28):
            gradient = 1.0 - (x / fill_width) * 0.3
            draw.point((x, y), fill=(
                max(0, min(255, int(fill_color[0] * gradient))),
                max(0, min(255, int(fill_color[1] * gradient))),
                max(0, min(255, int(fill_color[2] * gradient))),
                255
            ))
    
    filename = f"assets/ui/{name}.png"
    image.save(filename)

def generate_backgrounds():
    print("Generating backgrounds...")
    
    create_menu_background()
    create_combat_background()
    create_meeting_background()
    
    print("Backgrounds generated!")

def create_menu_background():
    image = Image.new('RGBA', (1920, 1080), (243, 243, 250, 255))
    pixels = image.load()
    
    sky_color = (243, 243, 250)
    mountain_color = (128, 128, 139)
    
    for x in range(1920):
        mountain_height = int(400 + math.sin(x * 0.005) * 100 + math.sin(x * 0.01) * 50)
        for y in range(mountain_height, 1080):
            shade = (y - mountain_height) / 680.0
            pixels[x, y] = (
                max(0, min(255, int(mountain_color[0] - shade * 50))),
                max(0, min(255, int(mountain_color[1] - shade * 50))),
                max(0, min(255, int(mountain_color[2] - shade * 50))),
                255
            )
    
    image.save("assets/backgrounds/menu.png")

def create_combat_background():
    image = Image.new('RGBA', (1920, 1080), (143, 238, 143, 255))
    pixels = image.load()
    
    ground_color = (143, 238, 143)
    
    for x in range(1920):
        for y in range(540, 1080):
            noise = (math.sin(x * 0.1) + math.cos(y * 0.1)) * 0.05
            pixels[x, y] = (
                max(0, min(255, int(ground_color[0] + noise * 50))),
                max(0, min(255, int(ground_color[1] + noise * 50))),
                max(0, min(255, int(ground_color[2] + noise * 50))),
                255
            )
    
    for i in range(20):
        tree_x = random.randint(0, 1919)
        tree_y = random.randint(600, 899)
        draw_simple_tree(pixels, tree_x, tree_y, (26, 102, 26))
    
    image.save("assets/backgrounds/combat.png")

def create_meeting_background():
    image = Image.new('RGBA', (1920, 1080), (217, 165, 69, 255))
    pixels = image.load()
    
    tatami_color = (217, 165, 69)
    wood_color = (153, 102, 51)
    shoji_color = (243, 243, 240)
    
    for x in range(1920):
        if x % 100 < 10:
            for y in range(1080):
                pixels[x, y] = wood_color + (255,)
    
    for x in range(100, 800):
        for y in range(50, 800):
            pixels[x, y] = shoji_color + (255,)
    
    for x in range(1120, 1820):
        for y in range(50, 800):
            pixels[x, y] = shoji_color + (255,)
    
    image.save("assets/backgrounds/meeting.png")

if __name__ == "__main__":
    try:
        generate_all_assets()
    except ImportError:
        print("PIL/Pillow not found. Install with: pip install Pillow")
