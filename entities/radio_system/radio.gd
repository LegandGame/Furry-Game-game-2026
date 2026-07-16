class_name Radio extends Area2D

signal frequency_changed(new_frequency)

@export var frequency_min : float = 88.0
@export var frequency_max : float = 108.0
var frequency : float = 88.0 :
	set(value):
		frequency = clampf(value, frequency_min, frequency_max)
		frequency_changed.emit(frequency)
@export var tuning_speed : float = 10.0
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var tune_up_input : String = "tune_radio_up"
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var tune_down_input : String = "tune_radio_down"

func _process(delta: float) -> void:
	var tune = Input.get_axis(tune_down_input, tune_up_input)
	if tune:
		frequency += tune * tuning_speed * delta
