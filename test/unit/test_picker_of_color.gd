extends "res://addons/gut/test.gd"

var PickerOfColor = load('res://addons/PickerOfColors/picker_of_color.gd')
const TEMP_FILE = 'user://__test_picker_of_color__.txt'
var gr = {
	poc = null
}
class HasPosition:
	var _pos = Vector2(0,0)
	func get_position():
		return _pos
	func set_position(pos):
		_pos = pos
	func get_global_position():
		return _pos
	func _init(x, y):
		_pos = Vector2(x, y)
# #############
# Seutp/Teardown
# #############
func setup():
	gr.poc = PickerOfColor.new()
	gr.poc.set_size(Vector2(300, 300))
	add_child(gr.poc)

func teardown():
	remove_child(gr.poc)
	gut.file_delete(TEMP_FILE)

# #############
# Tests
# #############
func test_can_get_set_cell_size():
	assert_accessors(gr.poc, 'cell_size', Vector2(30,30), Vector2(40, 40))

func test_can_add_color_with_rgb():
	gr.poc.add_color(1,1,1)
	assert_eq(gr.poc.get_colors()[0], Color(1,1,1))

func test_can_add_color_with_Color():
	gr.poc.add_color(Color(1,2,3))
	assert_eq(gr.poc.get_colors()[0], Color(1,2,3))

func test_can_clear_colors():
	for i in range(10):
		gr.poc.add_color(1,1,1)
	gr.poc.clear()
	assert_eq(gr.poc.get_colors().size(), 0)

func test_add_unique_color_filters_out_duplicates():
	gr.poc.add_unique_color(1,1,1)
	gr.poc.add_unique_color(1,1,1)
	gr.poc.add_unique_color(2,2,2)
	gr.poc.add_unique_color(2,2,2)
	gr.poc.add_unique_color(2,2,2)
	gr.poc.add_unique_color(3,3,3)
	gr.poc.add_unique_color(3,3,3)
	assert_eq(gr.poc.get_colors().size(), 3)

func test_can_add_null_colors():
	gr.poc.add_color(null)
	assert_eq(gr.poc.get_colors()[0], null)

func test_can_set_color_for_index():
	gr.poc.add_color(1,1,1)
	gr.poc.add_color(2,2,2)
	gr.poc.set_color_at(0, Color(3,3,3))
	assert_eq(gr.poc.get_colors()[0], Color(3,3,3))

func test_setting_cell_size_causes_vertical_resize():
	gr.poc.set_size(Vector2(100,100))
	gr.poc.add_color(1,1,1)
	gr.poc.add_color(2,2,2)
	gr.poc.add_color(3,3,3)
	# This size should cause one per line for a total size of 300
	gr.poc.set_cell_size(Vector2(75, 100))
	yield(yield_for(.5, 'wait to paint'), YIELD)
	assert_eq(gr.poc.get_size().y, 300.0)

func test_adding_colors_causes_vertical_resize():
	gr.poc.set_size(Vector2(100, 50))
	gr.poc.set_cell_size(Vector2(75, 100))
	gr.poc.add_color(1,1,1)
	gr.poc.add_color(2,2,2)
	yield(yield_for(.5, 'wait to paint'), YIELD)
	assert_eq(gr.poc.get_size().y, 300.0)

# ########
# Selecting things
# ########

func test_can_get_set_selected_index():
	for i in range(10):
		gr.poc.add_color(1,1,1)
	assert_accessors(gr.poc, 'selected_index', -1, 5)

func test_cannot_select_index_that_does_not_exist():
	# nothing in here so it should fail
	gr.poc.set_selected_index(5)
	assert_eq(gr.poc.get_selected_index(), -1)

func test_can_get_selected_color():
	gr.poc.add_color(1,1,1)
	gr.poc.add_color(2,2,2)
	gr.poc.set_selected_index(1)
	assert_eq(gr.poc.get_selected_color(), Color(2,2,2))

func test_get_selected_color_returns_null_when_nothing_selected():
	assert_eq(gr.poc.get_selected_color(), null)

func test_can_set_selected_color():
	gr.poc.add_color(1,1,1)
	gr.poc.add_color(2,2,2)
	gr.poc.set_selected_color(Color(2,2,2))
	assert_eq(gr.poc.get_selected_index(), 1)

func test_setting_selected_color_sets_nothing_if_color_does_not_exist():
	gr.poc.add_color(1,1,1)
	gr.poc.add_color(2,2,2)
	gr.poc.set_selected_index(0)
	gr.poc.set_selected_color(Color(3,3,3))
	assert_eq(gr.poc.get_selected_index(), 0)

# ###############
# signals
# ###############
func test__signal_seleted__fires_when_clicking_item():
	watch_signals(gr.poc)
	gr.poc.add_color(1,1,1)
	gr.poc._handle_click(HasPosition.new(1,1))
	assert_signal_emitted(gr.poc, 'selected')

func test__signal_selected__sends_selected_color():
	watch_signals(gr.poc)
	gr.poc.add_color(1,1,1)
	gr.poc._handle_click(HasPosition.new(1,1))
	assert_signal_emitted_with_parameters(gr.poc, 'selected', [Color(1,1,1)])

# ###############
# Save load
# ###############
func test_can_save_load_colors():
	gr.poc.add_color(1,1,1)
	gr.poc.saveit(TEMP_FILE)

	var other = PickerOfColor.new()
	other.loadit(TEMP_FILE)
	assert_eq(other.get_colors()[0], Color(1,1,1))

func test_gets_empty_array_when_file_does_not_exist():
	gr.poc.add_color(1,1,1)
	gr.poc.loadit('user://_some_non_existant_file__2q34asd')
	assert_eq(gr.poc.get_colors().size(), 0)
