extends GutTest

var fog_visualizer: FogOfWarVisualizer

func before_each() -> void:
    fog_visualizer = FogOfWarVisualizer.new()
    add_child_autofree(fog_visualizer)

func test_fog_initialization() -> void:
    assert_eq(fog_visualizer.map_size, Vector2i(50, 50), "Map size should be 50x50")
    assert_eq(fog_visualizer.fog_data.size(), 50, "Should have 50 columns")

func test_fog_all_hidden_initially() -> void:
    for x in range(50):
        for y in range(50):
            assert_false(fog_visualizer.fog_data[x][y]["visible"], "All tiles should be initially hidden")
            assert_false(fog_visualizer.fog_data[x][y]["explored"], "All tiles should be initially unexplored")

func test_reveal_area() -> void:
    fog_visualizer.reveal_area(Vector2i(25, 25), 5)
    assert_true(fog_visualizer.is_visible(Vector2i(25, 25)), "Center tile should be visible")
    assert_true(fog_visualizer.is_explored(Vector2i(25, 25)), "Center tile should be explored")

func test_reveal_radius() -> void:
    fog_visualizer.reveal_area(Vector2i(25, 25), 5)
    
    var visible_count = 0
    for x in range(20, 31):
        for y in range(20, 31):
            if fog_visualizer.is_visible(Vector2i(x, y)):
                visible_count += 1
    
    assert_true(visible_count > 50, "Should reveal multiple tiles")

func test_explored_percentage() -> void:
    var initial_percent = fog_visualizer.get_exploration_percentage()
    assert_eq(initial_percent, 0.0, "Initial exploration should be 0%")
    
    fog_visualizer.reveal_area(Vector2i(25, 25), 10)
    var new_percent = fog_visualizer.get_exploration_percentage()
    assert_true(new_percent > initial_percent, "Exploration percentage should increase")

func test_hide_area() -> void:
    fog_visualizer.reveal_area(Vector2i(25, 25), 5)
    assert_true(fog_visualizer.is_visible(Vector2i(25, 25)), "Should be visible")
    
    fog_visualizer.hide_area(Vector2i(25, 25), 5)
    assert_false(fog_visualizer.is_visible(Vector2i(25, 25)), "Should be hidden after hide")
    assert_true(fog_visualizer.is_explored(Vector2i(25, 25)), "Should remain explored")

func test_out_of_bounds() -> void:
    var visible = fog_visualizer.is_visible(Vector2i(-1, -1))
    assert_false(visible, "Out of bounds should return false")

func test_exploration_degradation() -> void:
    fog_visualizer.reveal_area(Vector2i(25, 25), 5)
    var explored = fog_visualizer.is_explored(Vector2i(25, 25))
    assert_true(explored, "Should be explored immediately after reveal")

func test_multiple_reveals() -> void:
    fog_visualizer.reveal_area(Vector2i(10, 10), 5)
    fog_visualizer.reveal_area(Vector2i(40, 40), 5)
    
    assert_true(fog_visualizer.is_visible(Vector2i(10, 10)), "First area should be visible")
    assert_true(fog_visualizer.is_visible(Vector2i(40, 40)), "Second area should be visible")
    assert_false(fog_visualizer.is_visible(Vector2i(25, 25)), "Unrevealed area should be hidden")
