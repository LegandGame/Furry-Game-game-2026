class_name RadioListener extends Area2D

@export_range(88, 108, 1, "or_less", "or_greater") var target_frequency : int = 100
var radio_ref : Radio = null
@export var check_time : float = 0.5	## in seconds
@onready var check_time_timer : float = check_time

signal aligned	## use this signal for all your radio listening needs

func _init() -> void:
	area_entered.connect(_on_radio_entered)
	area_exited.connect(_on_radio_exited)

func _process(delta: float) -> void:
	if radio_ref and _compare_frequency():
		check_time_timer -= delta
		if check_time_timer <= 0.0:
			aligned.emit()
			_on_radio_exited(radio_ref)
	else:
		check_time_timer = move_toward(check_time_timer, check_time, delta)

func _compare_frequency() -> bool:
	if roundf(radio_ref.frequency) == target_frequency:
		return true
	if floorf(radio_ref.frequency) == target_frequency:
		return true
	return false

func _on_radio_entered(area : Area2D) -> void:
	radio_ref = area
func _on_radio_exited(area : Area2D) -> void:
	if area is not Radio:
		return
	radio_ref = null
