extends "res://addons/gut/test.gd"

var PickerOfColors = load('res://PickerOfColors.tscn')
const TEMP_FILE = 'user://__test_picker_of_color__.txt'
var gr = {
	poc = null
}

# #############
# Seutp/Teardown
# #############
func setup():
	gr.poc = PickerOfColors.instance()
	gr.poc.set_size(Vector2(300, 300))
	add_child(gr.poc)

func teardown():
	gr.poc.queue_free()
	gut.file_delete(TEMP_FILE)

# #############
# Tests
# #############
func test_can_get_set_custom_slots():
	assert_get_set_methods(gr.poc, 'custom_slots', 0, 10)

func test_can_get_selected_color():
	pending()

func test_can_get_presets():
	pending()

func test_can_get_customs():
	pending()

func test_has_selected_signal():
	assert_has_signal(gr.poc, 'selected')

func test_can_get_set_cell_size():
	assert_get_set_methods(gr.poc, 'cell_size', Vector2(30,30), Vector2(50, 50))

func test_setting_cell_size_sets_custom_cell_size():
	gr.poc.set_cell_size(Vector2(100, 100))
	assert_eq(gr.poc.get_custom_picker().get_cell_size(), Vector2(100, 100))
