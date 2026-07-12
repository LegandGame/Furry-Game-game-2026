class_name Chaser extends CharacterBody2D

@onready var vision_area: Area2D = $VisionArea
@onready var radio_listener: RadioListener = $RadioListener

@export var wander_speed : float = 150.0
@export var chase_speed : float = 400.0

enum STATE{WANDER, INVESTIGATE, CHASE, STUNNED}
var cur_state : STATE = STATE.WANDER
var player_ref : Player

var last_known_location : Vector2
var wander_location : Vector2 = Vector2.INF
var wander_timer : float = 10.0	## in seconds
var chase_timer : float = 30.0	## time before chase, in seconds
var stun_timer : float
var health := 3


func _ready() -> void:
	vision_area.body_entered.connect(_on_body_entered)
	vision_area.body_entered.connect(_on_body_exited)
	radio_listener.monitoring = false
	radio_listener.aligned.connect(take_damage)

func _physics_process(delta: float) -> void:
	match cur_state:
		STATE.WANDER:
			_wander_process(delta)
		STATE.INVESTIGATE:
			_investigate_process(delta)
		STATE.CHASE:
			_chase_process(delta)
		STATE.STUNNED:
			_stun_process(delta)
	move_and_slide()

func _wander_process(delta : float) -> void:
	if wander_location == Vector2.INF:	# using Vector2.INF to represent an invalid wander_location
		var x = randf_range(self.position.x - 500, self.position.x + 500)
		var y = randf_range(self.position.y - 500, self.position.y + 500)
		wander_location = Vector2(x, y)
		wander_timer = 10.0
	
	velocity = self.global_position.direction_to(wander_location) * wander_speed
	
	wander_timer -= delta
	if wander_timer <= 0.0 or global_position.distance_to(wander_location) <= 10.0:
		wander_location = Vector2.INF

func _investigate_process(delta : float) -> void:
	if player_ref:
		velocity = self.global_position.direction_to(player_ref.global_position) * wander_speed
		chase_timer -= delta * self.global_position.distance_to(player_ref.global_position)
		if chase_timer <= 0.0:
			cur_state = STATE.CHASE
	else:
		velocity = self.global_position.direction_to(last_known_location) * wander_speed
		if global_position.distance_to(last_known_location) <= 10.0:
			cur_state = STATE.WANDER

func _chase_process(_delta: float) -> void:
	if not radio_listener.monitoring:
		radio_listener.set_deferred("monitoring", true)
	velocity = self.global_position.direction_to(player_ref.global_position) * chase_speed
	# TODO figure out how to damage player

func _stun_process(delta: float) -> void:
	stun_timer -= delta
	if stun_timer <= 0.0:
		if health > 0:
			cur_state = STATE.CHASE
		else:
			cur_state = STATE.WANDER
			player_ref = null
			health = 3

func _on_body_entered(body : Node2D) -> void:
	if body is not Player:
		return
	player_ref = body
	match cur_state:
		STATE.WANDER:
			cur_state = STATE.INVESTIGATE
func _on_body_exited(body : Node2D) -> void:
	if body is not Player:
		return
	match cur_state:
		STATE.INVESTIGATE:
			last_known_location = body.global_position
			player_ref = null
		STATE.CHASE:
			return

func take_damage() -> void:
	health -= 1
	if health <= 0:
		stun_timer = 10.0
	else:
		stun_timer = 0.5
	radio_listener.set_deferred("monitoring", false)
	cur_state = STATE.STUNNED
