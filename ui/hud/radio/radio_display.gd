extends Control

@export_custom(PROPERTY_HINT_INPUT_NAME, "") var tune_up_input : String = "tune_radio_up"
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var tune_down_input : String = "tune_radio_down"


@onready var arrow: TextureRect = $PanelContainer/MarginContainer/Arrow
@onready var dial: TextureRect = $PanelContainer/MarginContainer/Dial
@export var dial_turn_speed : float = 10.0
var dial_atlas : Array[Rect2] = [Rect2(0, 16, 138, 133), Rect2(144, 19, 133, 127), 
								Rect2(283, 17, 136, 132), Rect2(425, 17, 137, 132), 
								Rect2(568, 19, 133, 137), Rect2(707, 16, 138, 133),
								Rect2(0, 199, 138, 133), Rect2(144, 202, 133, 127), 
								Rect2(283, 200, 136, 132), Rect2(425, 200, 137, 132), 
								Rect2(568, 202, 133, 127), Rect2(707, 199, 138, 133)]


var radio_ref : Radio
# min arrow offset = 25, max = 261
func _process(delta: float) -> void:
	# absolute code gore right here but fuck it
	if not is_instance_valid(radio_ref):
		radio_ref = get_tree().get_first_node_in_group("radio")
		return
	var tune = Input.get_axis(tune_down_input, tune_up_input)
	if tune:
		dial.texture.region = dial_atlas[int(radio_ref.frequency - 88) % 12]
		# TODO Move Arrow along radio display (need to fix size first for most accuracy
		arrow.offset_transform_position.x = ((radio_ref.frequency -88) * 11.8) + 25
