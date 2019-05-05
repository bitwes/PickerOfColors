extends Node2D

onready var _picker = get_node("PickerOfColors")
const CUSTOM_FILE = 'user://test_custom_colors.cfg'
const PICKER_FILE = 'user://test_picker_file.cfg'
var PickerOfColors = load('res://addons/PickerOfColors/picker_of_colors.gd')

onready var _ctrls = {
	panel = get_node("Controls"),
	txt_selected = get_node("Controls/txtSelectedIndex"),
	lbl_color_info = get_node("Controls/lblColorInfo"),
	height_slider = get_node("Controls/HeightSlider"),
	width_slider = get_node("Controls/WidthSlider"),

	cell_width_slider = get_node("SettingsPanel/CellWidthSlider"),
	cell_height_slider = get_node("SettingsPanel/CellHeightSlider"),
	config_info = get_node("SettingsPanel/ConfigInfoLabel"),
	step_spinner = get_node("SettingsPanel/StepSpinBox"),

	picker_of_color = get_node("ColorSampleScroll/PickerOfColor")
}

var _color = null

func _on_panel_draw():
	if(_color != null):
		_ctrls.panel.draw_rect(Rect2(233, 30, 30, 30), _color)

func _ready():
	$ColorButton.set_the_color(Color(1, 1, 0))
	
	
	_picker.set_cell_size(Vector2(40, 60))
	#_picker.set_custom_slots(10)
	_picker.load_default_presets(.2)
	# _picker.connect('selected', self, '_on_picker_selected')
	_ctrls.panel.connect('draw', self, '_on_panel_draw')
	_ctrls.cell_width_slider.connect('value_changed', self, '_on_cell_slider_changed')
	_ctrls.cell_height_slider.connect('value_changed', self, '_on_cell_slider_changed')
	_ctrls.height_slider.connect('value_changed', self, '_on_size_slider_changed')
	_ctrls.width_slider.connect('value_changed', self, '_on_size_slider_changed')
	_update_config_display()
	_update_size_sliders()

	for i in range(20):
		_ctrls.picker_of_color.add_color(1,1,1)
		_ctrls.picker_of_color.add_color(0,0,0)
		_ctrls.picker_of_color.add_color(1,0,0)
		_ctrls.picker_of_color.add_color(0,1,0)
		_ctrls.picker_of_color.add_color(0,0,1)

func _update_size_sliders():
	_ctrls.width_slider.set_value(_picker.get_size().x)
	_ctrls.height_slider.set_value(_picker.get_size().y)
	print(_picker.get_size())

func _on_PickerOfColors_selected( color ):
	if(color != null):
		var txt = str('r = ', color.r, "\ng = ", color.g, "\nb = ", color.b, "\n", color.to_html())
		_ctrls.lbl_color_info.set_text(txt)
		_color = color
		_ctrls.panel.update()
		_ctrls.txt_selected.set_text(str(_picker.get_active_picker().get_selected_index()))

func _on_Add10Colors_pressed():
	for i in range(10):
		_picker.get_active_picker().add_color(null)
	_picker._ctrls.preset_scroll.queue_sort()

func _update_config_display():
	var txt = str("Cell Size = ", _picker.get_cell_size(), "\nColor Step = ", _ctrls.step_spinner.get_value())
	_ctrls.config_info.set_text(txt)

func _on_SaveCustom_pressed():
	_picker.get_custom_picker().saveit(CUSTOM_FILE)

func _on_LoadCustom_pressed():
	_picker.get_custom_picker().clear()
	_picker.load_custom_colors(CUSTOM_FILE)

func _on_cell_slider_changed(value):
	var s = Vector2(_ctrls.cell_width_slider.get_value(), _ctrls.cell_height_slider.get_value())
	_picker.set_cell_size(s)
	_ctrls.picker_of_color.set_cell_size(s)
	_update_config_display()

func _on_StepSpinBox_value_changed( value ):
	_picker.get_presets_picker().clear()
	_picker.load_default_presets(value)
	_update_config_display()

func _on_btnSetSelected_pressed():
	_picker.get_presets_picker().set_selected_index(int(_ctrls.txt_selected.get_text()))

func _on_SaveAll_pressed():
	_picker.saveit(PICKER_FILE)

func _on_LoadAll_pressed():
	_picker.loadit(PICKER_FILE)
	_on_PickerOfColors_selected(_picker.get_selected_color())

func _on_ClearPicker_pressed():
	var s = _picker.get_size()
	var p = _picker.get_position()
	_picker.queue_free()
	_picker = PickerOfColors.new()
	add_child(_picker)
	_picker.set_size(s)
	_picker.set_position(p)
	#_picker.connect('selected', self, '_on_picker_selected')
	_update_config_display()
	_update_size_sliders()

func _on_size_slider_changed(value):
	_picker.set_size(Vector2(_ctrls.width_slider.get_value(), _ctrls.height_slider.get_value()))

