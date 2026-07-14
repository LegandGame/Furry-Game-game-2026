extends Control

@export_custom(PROPERTY_HINT_INPUT_NAME, "") var tune_up_input : String = "tune_radio_up"
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var tune_down_input : String = "tune_radio_down"


@onready var arrow: TextureRect = $PanelContainer/MarginContainer/Arrow
@onready var dial: TextureRect = $PanelContainer/MarginContainer/Dial
@export var dial_turn_speed : float = 10.0

@onready var radio_ref = get_tree().get_first_node_in_group("radio")

func _process(delta: float) -> void:
	var tune = Input.get_axis(tune_down_input, tune_up_input)
	if tune:
		dial.offset_transform_rotation += dial_turn_speed * tune * delta
		# TODO Move Arrow along radio display (need to fix size first for most accuracy
