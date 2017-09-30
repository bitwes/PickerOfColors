extends "res://addons/gut/test.gd"

var PickerOfColor = load('res://picker_of_color.gd')

var gr = {
	poc = null
}


# #############
# Seutp/Teardown
# #############
func setup():
	gr.poc = PickerOfColor.new()
	add_child(gr.poc)

func teardown():
	remove_child(gr.poc)

# #############
# Tests
# #############
func test_pending():
	pending()
