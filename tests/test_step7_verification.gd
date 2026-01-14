extends GutTest

var procedural_asset_generator

func before_each() -> void:
	procedural_asset_generator = preload("res://scripts/create_procedural_assets.gd").new()
	add_child_autofree(procedural_asset_generator)

func test_step7_map_tiles_generated() -> void:
	var tiles = [
		"plains.png",
		"forest_01.png",
		"forest_02.png",
		"mountains_01.png",
		"mountains_02.png",
		"river.png"
	]
	
	for tile in tiles:
		var path = "res://assets/tiles/" + tile
		var file = FileAccess.open(path, FileAccess.READ)
		assert_true(file != null, "Tile should exist: " + tile)
		if file:
			file.close()

func test_step7_character_sprites_generated() -> void:
	var factions = ["blue", "red"]
	var directions = ["n", "s", "e", "w"]
	var types = ["shogun", "infantry", "cavalry"]
	
	var total_sprites = 0
	for type in types:
		for faction in factions:
			for direction in directions:
				var file = FileAccess.open("res://assets/sprites/" + type + "_" + faction + "_" + direction + "_01.png", FileAccess.READ)
				if file:
					total_sprites += 1
					file.close()
	
	assert_true(total_sprites >= 12, "At least 12 character sprites should be generated")

func test_step7_army_icons_generated() -> void:
	var icons = [
		"infantry_blue.png",
		"infantry_red.png",
		"cavalry_blue.png",
		"cavalry_red.png"
	]
	
	for icon in icons:
		var path = "res://assets/ui/" + icon
		var file = FileAccess.open(path, FileAccess.READ)
		assert_true(file != null, "Icon should exist: " + icon)
		if file:
			file.close()

func test_step7_ui_elements_generated() -> void:
	var ui_elements = [
		"perch_interface.png",
		"button_normal.png",
		"button_hover.png",
		"button_pressed.png",
		"health_bar.png",
		"mana_bar.png"
	]
	
	for element in ui_elements:
		var path = "res://assets/ui/" + element
		var file = FileAccess.open(path, FileAccess.READ)
		assert_true(file != null, "UI element should exist: " + element)
		if file:
			file.close()

func test_step7_backgrounds_generated() -> void:
	var backgrounds = [
		"menu.png",
		"combat.png",
		"meating.png"
	]
	
	for bg in backgrounds:
		var path = "res://assets/backgrounds/" + bg
		var file = FileAccess.open(path, FileAccess.READ)
		assert_true(file != null, "Background should exist: " + bg)
		if file:
			file.close()

func test_step7_asset_dimensions() -> void:
	var tiles_file = FileAccess.open("res://assets/tiles/plains.png", FileAccess.READ)
	if tiles_file:
		tiles_file.close()
		var image = Image.load_from_file("res://assets/tiles/plains.png")
		if image:
			assert_eq(image.get_width(), 64, "Tiles should be 64px wide")
			assert_eq(image.get_height(), 64, "Tiles should be 64px tall")

func test_step7_ui_transparency() -> void:
	var ui_file = FileAccess.open("res://assets/ui/perch_interface.png", FileAccess.READ)
	if ui_file:
		ui_file.close()
		var image = Image.load_from_file("res://assets/ui/perch_interface.png")
		if image:
			assert_true(image.get_format() == Image.FORMAT_RGBA8, "UI should have alpha channel")

func test_step7_color_palette() -> void:
	var infantry_file = FileAccess.open("res://assets/ui/infantry_blue.png", FileAccess.READ)
	if infantry_file:
		infantry_file.close()
		var image = Image.load_from_file("res://assets/ui/infantry_blue.png")
		if image:
			var center_pixel = image.get_pixel(32, 32)
			assert_true(center_pixel.r > 0.0, "Should have visible colors")

func test_step7_directory_structure() -> void:
	var dir = DirAccess.open("res://")
	assert_true(dir.dir_exists("assets"), "Assets directory should exist")
	assert_true(dir.dir_exists("assets/tiles"), "Tiles directory should exist")
	assert_true(dir.dir_exists("assets/sprites"), "Sprites directory should exist")
	assert_true(dir.dir_exists("assets/ui"), "UI directory should exist")
	assert_true(dir.dir_exists("assets/backgrounds"), "Backgrounds directory should exist")

func test_step7_asset_count() -> void:
	var total_assets = 0
	
	var tile_dir = DirAccess.open("res://assets/tiles/")
	if tile_dir:
		tile_dir.list_dir_begin()
		var file = tile_dir.get_next()
		while file != "":
			total_assets += 1
			file = tile_dir.get_next()
	
	assert_true(total_assets >= 6, "Should have at least 6 tile assets")

func test_step7_guide_exists() -> void:
	var guide_file = FileAccess.open("res://ASSET_GENERATION_GUIDE.md", FileAccess.READ)
	assert_true(guide_file != null, "Asset generation guide should exist")
	if guide_file:
		guide_file.close()

func test_step7_generator_script_exists() -> void:
	var script_file = FileAccess.open("res://scripts/create_procedural_assets.gd", FileAccess.READ)
	assert_true(script_file != null, "Procedural asset generator should exist")
	if script_file:
		script_file.close()

func test_step7_faction_colors() -> void:
	var blue_icon = FileAccess.open("res://assets/ui/infantry_blue.png", FileAccess.READ)
	var red_icon = FileAccess.open("res://assets/ui/infantry_red.png", FileAccess.READ)
	
	if blue_icon and red_icon:
		blue_icon.close()
		red_icon.close()
		var blue_image = Image.load_from_file("res://assets/ui/infantry_blue.png")
		var red_image = Image.load_from_file("res://assets/ui/infantry_red.png")
		
		if blue_image and red_image:
			var blue_pixel = blue_image.get_pixel(32, 32)
			var red_pixel = red_image.get_pixel(32, 32)
			assert_true(blue_pixel.b > red_pixel.b, "Blue icon should have more blue")
			assert_true(red_pixel.r > blue_pixel.r, "Red icon should have more red")
