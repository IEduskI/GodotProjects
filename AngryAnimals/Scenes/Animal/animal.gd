extends RigidBody2D

enum AnimalState { Ready, Drag, Release }

const DRAG_LIM_MAX: Vector2 = Vector2(0,60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60,0)
const IMPULSE_MULT: float = 20.0
const IMPULSE_MAX: float = 1200.0

@onready var arrow: Sprite2D = $Arrow
@onready var debug_label: Label = $DebugLabel
@onready var strech_sound: AudioStreamPlayer2D = $StrechSound
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound
@onready var kick_sound: AudioStreamPlayer2D = $KickSound

var _state: AnimalState = AnimalState.Ready
var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _arrow_scale_x: float = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if _state == AnimalState.Drag and event.is_action_released("drag"):
		call_deferred("changeState", AnimalState.Release)

func _ready() -> void:
	septup()

func septup() -> void:
	_arrow_scale_x = arrow.scale.x
	arrow.hide()
	_start = position

func _physics_process(_delta: float) -> void:
	updateState()
	updateDebugLabel()

#region misc

func updateDebugLabel() -> void:
	var ds: String = "ST:%s SL:%s FR:%s\n" % [
		AnimalState.keys()[_state], sleeping, freeze
	]
	ds += "_drag_start:%.1f, %.1f\n" % [_drag_start.x, _drag_start.y]
	ds += "_dragged_vector:%.1f, %.1f" % [_dragged_vector.x, _dragged_vector.y]
	debug_label.text = ds

#endregion

#region state

func updateState() -> void:
	match _state:
		AnimalState.Drag:
			handleDragging()

func changeState(newState: AnimalState) -> void:
	if _state == newState:
		return
	
	_state = newState
	
	match _state:
		AnimalState.Drag:
			startDragging()
		AnimalState.Release:
			startRelease()

#endregion

#region drag

func startDragging() -> void:
	arrow.show()
	_drag_start = get_global_mouse_position()

func updateArrowScale() -> void:
	var imp_len: float = calculateImpulse().length()
	var perc: float = clamp(imp_len / IMPULSE_MAX, 0.0, 1.0)
	arrow.scale.x = lerp(_arrow_scale_x, _arrow_scale_x * 2, perc)
	arrow.rotation = (_start - position).angle()

func handleDragging() -> void:
	var new_drag_vector: Vector2 = get_global_mouse_position() - _drag_start
	
	new_drag_vector = new_drag_vector.clamp(
		DRAG_LIM_MIN, DRAG_LIM_MAX
	)
	
	var diff: Vector2 = new_drag_vector - _dragged_vector
	
	if diff.length() > 0 and strech_sound.playing == false:
		strech_sound.play()
	
	_dragged_vector = new_drag_vector
	
	position = _start + _dragged_vector
	
	updateArrowScale()

#endregion

#region release

func startRelease() -> void:
	arrow.hide()
	launch_sound.play()
	freeze = false
	apply_central_impulse(calculateImpulse())
	SignalHub.emit_on_attempt_made()

func calculateImpulse() -> Vector2:
	return _dragged_vector * -IMPULSE_MULT

#endregion

#region die

func die() -> void:
	SignalHub.emit_on_animal_died()
	queue_free()

#endregion

#region signals

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag") and _state == AnimalState.Ready:
		changeState(AnimalState.Drag)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()

func _on_sleeping_state_changed() -> void:
	if sleeping == true:
		for body in get_colliding_bodies():
			if body is Cup:
				body.die()
		call_deferred("die")

func _on_body_entered(body: Node) -> void:
	if body is Cup and !kick_sound.playing:
		kick_sound.play()

#endregion
