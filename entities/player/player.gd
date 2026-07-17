class_name Player extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var footsteps : AudioStreamPlayer = $AudioStreamPlayer


@export var top_speed : float = 300.0
@export var accel : float = 1000.0

func _ready() -> void:
	footsteps.volume_db = AppSettings.get_bus_volume(3) - 10.0

func _physics_process(delta: float) -> void:
	_movement(delta)

func _movement(delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_animate(dir)
	velocity = velocity.move_toward(dir * top_speed, delta * accel)
	if velocity.length() >= 10.0:
		if not footsteps.playing:
			footsteps.play()
	
	move_and_slide()

func _animate(move_dir : Vector2) -> void:
	if move_dir.length() <= 0.2:
		sprite_2d.play("Idle")
	elif move_dir.dot(Vector2.DOWN) >= 0.8:
		sprite_2d.play("Walk_Down")
	elif move_dir.dot(Vector2.RIGHT) >= 0.8:
		sprite_2d.flip_h = false
		sprite_2d.play("Walk_LR")
	elif move_dir.dot(Vector2.LEFT) >= 0.8:
		sprite_2d.flip_h = true
		sprite_2d.play("Walk_LR")
	elif move_dir.dot(Vector2.UP) >= 0.8:
		sprite_2d.play("Walk_Up")
