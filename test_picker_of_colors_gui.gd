onready var _picker = get_node("Picker")
const CUSTOM_FILE = 'user://test_custom_colors.txt'
onready var _ctrls = {
	panel = get_node("Controls"),
	txt_selected = get_node("Controls/txtSelectedIndex"),
	lbl_color_info = get_node("Controls/lblColorInfo"),
	cell_width_slider = get_node("Controls/CellWidthSlider"),
	cell_height_slider = get_node("Controls/CellHeightSlider"),
	config_info = get_node("Controls/ConfigInfoLabel"),
	step_spinner = get_node("Controls/StepSpinBox")
}
var _color = null

func _on_panel_draw():
	if(_color != null):
		_ctrls.panel.draw_rect(Rect2(233, 30, 30, 30), _color)

func _ready():
	_picker.set_cell_size(Vector2(40, 60))
	_picker.set_custom_slots(10)
	_picker.load_default_presets()
	_picker.connect('selected', self, '_on_picker_selected')
	_ctrls.panel.connect('draw', self, '_on_panel_draw')
	_ctrls.cell_width_slider.connect('value_changed', self, '_on_cell_slider_changed')
	_ctrls.cell_height_slider.connect('value_changed', self, '_on_cell_slider_changed')
	_update_config_display()

func _on_picker_selected(color):
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
	_picker.get_custom_picker().loadit(CUSTOM_FILE)

func _on_cell_slider_changed(value):
	_picker.set_cell_size(Vector2(_ctrls.cell_width_slider.get_value(), _ctrls.cell_height_slider.get_value()))
	_update_config_display()

func _on_StepSpinBox_value_changed( value ):
	_picker.get_presets_picker().clear()
	_picker.load_default_presets(value)
	_update_config_display()

func _on_btnSetSelected_pressed():
	_picker.get_presets_picker().set_selected_index(int(_ctrls.txt_selected.get_text()))
