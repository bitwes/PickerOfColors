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
	remove_child(gr.poc)
	gut.file_delete(TEMP_FILE)

# #############
# Tests
# #############
func test_can_get_selected_color():
	pending()

func test_can_get_presets():
	pending()

func test_can_get_customs():
	pending()

func test_has_selected_signal():
	assert_has_signal(gr.poc, 'selected')