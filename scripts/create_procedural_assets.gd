extends Node

func _ready() -> void:
	generate_all_assets()

func generate_all_assets() -> void:
	print("Generating procedural assets...")
	
	generate_map_tiles()
	generate_character_sprites()
	generate_army_icons()
	generate_ui_elements()
	generate_backgrounds()
	
	print("All procedural assets generated!")

func generate_map_tiles() -> void:
	DirAccess.make_dir_absolute("res://assets/tiles/")
	
	# Plains (1 variation)
	create_plains_tile()
	
	# Forest (2 variations)
	create_forest_tile(1)
	create_forest_tile(2)
	
	# Mountains (2 variations)
	create_mountains_tile(1)
	create_mountains_tile(2)
	
	# Rivers (1 variation)
	create_river_tile()
	
	print("Map tiles generated!")

func create_plains_tile() -> void:
	var image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	var color = Color(0.56, 0.93, 0.56)
	image.fill(color)
	
	for x in range(64):
		for y in range(64):
			var noise = (sin(x * 0.2) + cos(y * 0.2)) * 0.1
			image.set_pixel(x, y, color + Color(noise, noise, noise))
	
	save_image(image, "res://assets/tiles/plains.png")

func create_forest_tile(variation: int) -> void:
	var image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.13, 0.54, 0.13)
	image.fill(base_color)
	
	for i in range(3 + variation):
		var tree_x = 10 + i * 15 + variation * 5
		var tree_y = 10 + variation * 8
		
		draw_simple_tree(image, tree_x, tree_y, Color(0.1, 0.4, 0.1))
	
	save_image(image, "res://assets/tiles/forest_" + ("01" if variation == 1 else "02") + ".png")

func draw_simple_tree(image: Image, x: int, y: int, color: Color) -> void:
	var trunk_color = Color(0.4, 0.26, 0.13)
	
	for ty in range(20, 30):
		for tx in range(-2, 3):
			if x + tx >= 0 and x + tx < 64 and y + ty >= 0 and y + ty < 64:
				image.set_pixel(x + tx, y + ty, trunk_color)
	
	for py in range(-10, 20):
		for px in range(-8, 9):
			if x + px >= 0 and x + px < 64 and y + py >= 0 and y + py < 64:
				var distance = sqrt(px * px + py * py)
				if distance < 8:
					var noise = randf() * 0.1
					image.set_pixel(x + px, y + py, color + Color(noise, noise, noise))

func create_mountains_tile(variation: int) -> void:
	var image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.5, 0.5, 0.5)
	image.fill(base_color)
	
	var offset = variation * 10
	for x in range(64):
		var mountain_height = int(20 + sin(x * 0.1 + offset) * 15 + sin(x * 0.2) * 5)
		for y in range(mountain_height, 64):
			var shade = float(y - mountain_height) / 64.0
			var color = base_color - Color(shade * 0.2, shade * 0.2, shade * 0.2)
			image.set_pixel(x, y, color)
	
	save_image(image, "res://assets/tiles/mountains_" + ("01" if variation == 1 else "02") + ".png")

func create_river_tile() -> void:
	var image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	var bank_color = Color(0.56, 0.93, 0.56)
	var water_color = Color(0.25, 0.41, 0.88)
	image.fill(bank_color)
	
	for x in range(64):
		var river_center_y = 32 + sin(x * 0.15) * 5
		for y in range(64):
			var distance = abs(float(y) - river_center_y)
			if distance < 8:
				var blend = 1.0 - (distance / 8.0)
				var flow = sin(x * 0.2 + y * 0.1) * 0.1
				var final_color = bank_color.lerp(water_color, blend)
				image.set_pixel(x, y, final_color + Color(0, 0, flow))
	
	save_image(image, "res://assets/tiles/river.png")

func generate_character_sprites() -> void:
	DirAccess.make_dir_absolute("res://assets/sprites/")
	
	# Shogun General (8 sprites)
	for faction in ["blue", "red"]:
		for direction in ["n", "s", "e", "w"]:
			for frame in [1, 2]:
				create_shogun_sprite(faction, direction, frame)
	
	# Infantry (16 sprites)
	for faction in ["blue", "red"]:
		for direction in ["n", "s", "e", "w"]:
			for frame in [1, 2]:
				create_infantry_sprite(faction, direction, frame)
	
	# Cavalry (16 sprites)
	for faction in ["blue", "red"]:
		for direction in ["n", "s", "e", "w"]:
			for frame in [1, 2]:
				create_cavalry_sprite(faction, direction, frame)
	
	print("Character sprites generated!")

func create_shogun_sprite(faction: String, direction: String, frame: int) -> void:
	var image = Image.create(96, 96, false, Image.FORMAT_RGBA8)
	image.clear()
	
	var faction_color = Color(0.12, 0.56, 1.0) if faction == "blue" else Color(0.86, 0.08, 0.24)
	var armor_color = Color(0.3, 0.3, 0.3)
	var helmet_color = Color(0.5, 0.5, 0.5)
	
	draw_body_base(image, 96, 96, faction_color, armor_color)
	draw_helmet(image, 48, 25, helmet_color, faction_color)
	
	if frame == 2:
		var offset = 2 if direction in ["n", "s"] else 1
		add_animation_offset(image, offset)
	
	var filename = "shogun_" + faction + "_" + direction + "_0" + str(frame) + ".png"
	save_image(image, "res://assets/sprites/" + filename)

func create_infantry_sprite(faction: String, direction: String, frame: int) -> void:
	var image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	image.clear()
	
	var faction_color = Color(0.12, 0.56, 1.0) if faction == "blue" else Color(0.86, 0.08, 0.24)
	var armor_color = Color(0.4, 0.4, 0.4)
	
	draw_body_base(image, 64, 64, faction_color, armor_color)
	draw_spear(image, 32, 32, direction)
	
	if frame == 2:
		add_animation_offset(image, 1)
	
	var filename = "infantry_" + faction + "_" + direction + "_0" + str(frame) + ".png"
	save_image(image, "res://assets/sprites/" + filename)

func create_cavalry_sprite(faction: String, direction: String, frame: int) -> void:
	var image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	image.clear()
	
	var faction_color = Color(0.12, 0.56, 1.0) if faction == "blue" else Color(0.86, 0.08, 0.24)
	var armor_color = Color(0.4, 0.4, 0.4)
	var horse_color = Color(0.6, 0.5, 0.3)
	
	draw_horse(image, 32, 40, horse_color)
	draw_body_base(image, 64, 64, faction_color, armor_color, 32, 20)
	
	if frame == 2:
		add_animation_offset(image, 1)
	
	var filename = "cavalry_" + faction + "_" + direction + "_0" + str(frame) + ".png"
	save_image(image, "res://assets/sprites/" + filename)

func draw_body_base(image: Image, width: int, height: int, faction_color: Color, armor_color: Color, ox: int = 0, oy: int = 0) -> void:
	var center_x = width / 2
	var center_y = height / 2
	
	for y in range(height):
		for x in range(width):
			var dx = x - center_x
			var dy = y - center_y
			var distance = sqrt(dx * dx + dy * dy)
			
			if distance < 15:
				image.set_pixel(x + ox, y + oy, armor_color)
			elif distance < 20 and abs(dx) < 8:
				image.set_pixel(x + ox, y + oy, faction_color)

func draw_helmet(image: Image, x: int, y: int, color: Color, accent_color: Color) -> void:
	for dy in range(-10, 0):
		for dx in range(-6, 7):
			var dist = sqrt(dx * dx + dy * dy)
			if dist < 6:
				image.set_pixel(x + dx, y + dy, color)
	
	image.set_pixel(x, y - 5, accent_color)

func draw_spear(image: Image, x: int, y: int, direction: String) -> void:
	var spear_color = Color(0.8, 0.7, 0.5)
	var length = 20
	var dx = 0
	var dy = 0
	
	match direction:
		"n": dy = -1
		"s": dy = 1
		"e": dx = 1
		"w": dx = -1
	
	for i in range(length):
		var px = x + dx * i
		var py = y + dy * i
		if px >= 0 and px < 64 and py >= 0 and py < 64:
			image.set_pixel(px, py, spear_color)

func draw_horse(image: Image, x: int, y: int, color: Color) -> void:
	for dy in range(-10, 15):
		for dx in range(-12, 13):
			var dist = sqrt(dx * dx + dy * dy)
			if dist < 12 and dy > -5:
				image.set_pixel(x + dx, y + dy, color)
	
	image.set_pixel(x + 10, y - 8, Color.BLACK)
	image.set_pixel(x - 10, y - 8, Color.BLACK)

func add_animation_offset(image: Image, offset: int) -> void:
	var temp_image = image.duplicate()
	image.fill(Color.TRANSPARENT)
	
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var new_y = y + offset
			if new_y < image.get_height():
				var pixel = temp_image.get_pixel(x, y)
				if pixel.a > 0:
					image.set_pixel(x, new_y, pixel)

func generate_army_icons() -> void:
	DirAccess.make_dir_absolute("res://assets/ui/")
	
	create_kanji_icon("歩兵", "infantry_blue", Color(0.12, 0.56, 1.0))
	create_kanji_icon("歩兵", "infantry_red", Color(0.86, 0.08, 0.24))
	create_kanji_icon("騎兵", "cavalry_blue", Color(0.12, 0.56, 1.0))
	create_kanji_icon("騎兵", "cavalry_red", Color(0.86, 0.08, 0.24))
	
	print("Army icons generated!")

func create_kanji_icon(kanji: String, name: String, color: Color) -> void:
	var image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	image.clear()
	
	image.fill(Color(0.96, 0.87, 0.7))
	
	var center_x = 32
	var center_y = 32
	
	for angle in range(0, 360, 45):
		var rad = deg_to_rad(angle)
		var x = center_x + cos(rad) * 25
		var y = center_y + sin(rad) * 25
		image.set_pixel(int(x), int(y), color)
	
	for i in range(10):
		var x = center_x + cos(deg_to_rad(i * 36)) * 15
		var y = center_y + sin(deg_to_rad(i * 36)) * 15
		image.set_pixel(int(x), int(y), color)
	
	image.set_pixel(center_x, center_y, color)
	
	var filename = name + ".png"
	save_image(image, "res://assets/ui/" + filename)

func generate_ui_elements() -> void:
	DirAccess.make_dir_absolute("res://assets/ui/")
	
	# Perch Interface Panel
	create_perch_interface()
	
	# Buttons
	create_button("button_normal")
	create_button("button_hover")
	create_button("button_pressed")
	
	# Health/Mana bars
	create_bar("health_bar", Color(1.0, 0.0, 0.0))
	create_bar("mana_bar", Color(0.0, 0.5, 1.0))
	
	print("UI elements generated!")

func create_perch_interface() -> void:
	var image = Image.create(350, 600, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0.96, 0.87, 0.7, 0.7)
	image.fill(bg_color)
	
	var border_color = Color(0.17, 0.09, 0.06)
	
	for x in range(350):
		for y in range(600):
			if x < 3 or x > 346 or y < 3 or y > 596:
				image.set_pixel(x, y, border_color)
	
	for i in range(0, 600, 20):
		var shade = float(i) / 600.0
		for x in range(10, 340):
			image.set_pixel(x, i, bg_color * (1.0 - shade * 0.2))
	
	save_image(image, "res://assets/ui/perch_interface.png")

func create_button(name: String) -> void:
	var image = Image.create(150, 50, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0.96, 0.87, 0.7, 0.9)
	image.fill(bg_color)
	
	var border_color = Color(0.17, 0.09, 0.06)
	
	for x in range(150):
		image.set_pixel(x, 0, border_color)
		image.set_pixel(x, 49, border_color)
	
	for y in range(50):
		image.set_pixel(0, y, border_color)
		image.set_pixel(149, y, border_color)
	
	var pattern_color = Color(0.17, 0.09, 0.06, 0.1)
	for i in range(0, 150, 10):
		for j in range(0, 50, 10):
			if (i + j) % 20 == 0:
				image.set_pixel(i, j, pattern_color)
	
	save_image(image, "res://assets/ui/" + name + ".png")

func create_bar(name: String, fill_color: Color) -> void:
	var image = Image.create(200, 30, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0.96, 0.87, 0.7, 0.7)
	image.fill(bg_color)
	
	var border_color = Color(0.17, 0.09, 0.06)
	
	for x in range(200):
		image.set_pixel(x, 0, border_color)
		image.set_pixel(x, 29, border_color)
	
	for y in range(30):
		image.set_pixel(0, y, border_color)
		image.set_pixel(199, y, border_color)
	
	var fill_width = 150
	for x in range(2, fill_width):
		for y in range(2, 28):
			var gradient = 1.0 - (float(x) / fill_width) * 0.3
			image.set_pixel(x, y, fill_color * gradient)
	
	save_image(image, "res://assets/ui/" + name + ".png")

func generate_backgrounds() -> void:
	DirAccess.make_dir_absolute("res://assets/backgrounds/")
	
	create_menu_background()
	create_combat_background()
	create_meeting_background()
	
	print("Backgrounds generated!")

func create_menu_background() -> void:
	var image = Image.create(1920, 1080, false, Image.FORMAT_RGBA8)
	var sky_color = Color(0.95, 0.95, 0.98)
	var mountain_color = Color(0.5, 0.5, 0.55)
	image.fill(sky_color)
	
	for x in range(1920):
		var mountain_height = 400 + sin(x * 0.005) * 100 + sin(x * 0.01) * 50
		for y in range(mountain_height, 1080):
			var shade = float(y - mountain_height) / 680.0
			var color = mountain_color - Color(shade * 0.2, shade * 0.2, shade * 0.2)
			image.set_pixel(x, y, color)
	
	for x in range(1920):
		var cloud_x = (x + Time.get_ticks_msec() * 0.001) % 1920
		for y in range(100, 200):
			var dist = sqrt(pow(x - cloud_x, 2) + pow(y - 150, 2))
			if dist < 50:
				image.set_pixel(x, y, Color.WHITE)
	
	save_image(image, "res://assets/backgrounds/menu.png")

func create_combat_background() -> void:
	var image = Image.create(1920, 1080, false, Image.FORMAT_RGBA8)
	var ground_color = Color(0.56, 0.93, 0.56)
	image.fill(ground_color)
	
	for x in range(1920):
		for y in range(540, 1080):
			var noise = (sin(x * 0.1) + cos(y * 0.1)) * 0.05
			image.set_pixel(x, y, ground_color + Color(noise, noise, noise))
	
	for i in range(20):
		var tree_x = randi() % 1920
		var tree_y = 600 + randi() % 300
		draw_simple_tree(image, tree_x, tree_y, Color(0.13, 0.54, 0.13))
	
	save_image(image, "res://assets/backgrounds/combat.png")

func create_meeting_background() -> void:
	var image = Image.create(1920, 1080, false, Image.FORMAT_RGBA8)
	var tatami_color = Color(0.85, 0.65, 0.45)
	image.fill(tatami_color)
	
	var wood_color = Color(0.6, 0.4, 0.2)
	
	for x in range(1920):
		if x % 100 < 10:
			for y in range(1080):
				image.set_pixel(x, y, wood_color)
	
	var shoji_color = Color(0.95, 0.95, 0.9)
	for x in range(100, 800):
		for y in range(50, 800):
			image.set_pixel(x, y, shoji_color)
	
	for x in range(1120, 1820):
		for y in range(50, 800):
			image.set_pixel(x, y, shoji_color)
	
	save_image(image, "res://assets/backgrounds/meeting.png")

func save_image(image: Image, path: String) -> void:
	var error = image.save_png(path)
	if error != OK:
		print("Error saving image: ", path, " Error: ", error)
	else:
		print("Saved: ", path)
