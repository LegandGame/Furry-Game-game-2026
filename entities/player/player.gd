class_name Player extends CharacterBody2D

@export var top_speed : float = 300.0
@export var accel : float = 1000.0

func _physics_process(delta: float) -> void:
	_movement(delta)

func _movement(delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = velocity.move_toward(dir * top_speed, delta * accel)
	
	move_and_slide()
