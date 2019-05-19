extends Node2D

func _ready():
	_setup_picker($PickerOfColors1)
	_setup_picker($PickerOfColors2)
	_setup_picker($PickerOfColors3)


func _setup_picker(picker):
	picker.set_cell_size(Vector2(40, 60))
	picker.set_custom_slots(10)
	picker.load_default_presets(.2)


func _show_picker(picker):
	$PickerOfColors1.hide()
	$PickerOfColors2.hide()
	$PickerOfColors3.hide()
	picker.show()


func _on_Show1_pressed():
	_show_picker($PickerOfColors1)


func _on_Show2_pressed():
	_show_picker($PickerOfColors2)


func _on_Show3_pressed():
	_show_picker($PickerOfColors3)


func _on_PickerOfColors1_selected(color):
	$Show1.set_modulate(color)


func _on_PickerOfColors2_selected(color):
	$Show2.set_modulate(color)


func _on_PickerOfColors3_selected(color):
	$Show3.set_modulate(color)
