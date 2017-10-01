onready var _picker = get_node("Picker")

onready var _ctrls = {
	panel = get_node("Controls"),
	txt_selected = get_node("Controls/txtSelectedIndex"),
	lbl_color_info = get_node("Controls/lblColorInfo")
}
var _color = null

func _on_panel_draw():
	if(_color != null):
		_ctrls.panel.draw_rect(Rect2(233, 30, 30, 30), _color)

func _ready():
	_picker.set_custom_slots(10)
	_picker.load_default_presets()
	_picker.connect('selected', self, '_on_picker_selected')
	_ctrls.panel.connect('draw', self, '_on_panel_draw')

func _on_picker_selected(color):
	if(color != null):
		var txt = str('r = ', color.r, "\ng = ", color.g, "\nb = ", color.b, "\n", color.to_html())
		_ctrls.lbl_color_info.set_text(txt)
		_color = color
		_ctrls.panel.update()
