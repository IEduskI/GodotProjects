extends Area2D

class_name Gem

const SPEED: float = 200.0

signal gem_off_screen

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.y += SPEED * delta
	if position.y > Game.get_vpr().size.y:
		print("Gem has left the screen")
		gem_off_screen.emit()
		die()

func _on_area_entered(area:Area2D) -> void:
	print("Gem hits paddle")
	die()

func die() -> void:
	set_process(false)
	queue_free()
