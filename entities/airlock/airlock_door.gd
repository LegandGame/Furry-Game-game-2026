extends StaticBody2D

@onready var radio_listener: RadioListener = $RadioListener
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_open_door: AudioStreamPlayer2D = $SfxOpenDoor


func _ready() -> void:
	radio_listener.aligned.connect(_on_listener_aligned)
	radio_listener.target_frequency = randi_range(88, 108)
	radio_listener.check_time = randf_range(0.7, 1.4)
	radio_listener.check_time_timer = radio_listener.check_time
	# sanitation check
	disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	radio_listener.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE

func _on_listener_aligned() -> void:
	sfx_open_door.play()
	animated_sprite_2d.play("Opening")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("Open")
	self.process_mode = Node.PROCESS_MODE_DISABLED
