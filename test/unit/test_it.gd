extends "res://addons/gut/test.gd"

var PickerOfColors = load('res://ColorPicker.tscn')

var gr = {}


# #############
# Seutp/Teardown
# #############
func prerun_setup():
	pass

func setup():
	pass

func teardown():
	pass

# #############
# Tests
# #############
func test_pending():
	var p = PickerOfColors.instance()
	add_child(p)
	pending()
