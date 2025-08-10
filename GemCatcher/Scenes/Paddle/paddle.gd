extends Area2D

const SPEED: float = 300.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var movement: float = Input.get_axis("move_left", "move_right")
	position.x += SPEED * delta * movement

	position.x = clampf(
		position.x,
		Game.get_vpr().position.x,
		Game.get_vpr().end.x
	)
