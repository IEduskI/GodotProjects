extends Node2D

const ANIMAL = preload("res://Scenes/Animal/Animal.tscn")
const MAIN = preload("res://Scenes/Main/Main.tscn")

@onready var animal_start: Marker2D = $AnimalStart

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().change_scene_to_packed(MAIN)
		Cup._num_cups = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnParrot()

func _enter_tree() -> void:
	SignalHub.on_animal_died.connect(spawnParrot)

func spawnParrot() -> void:
	var parrot = ANIMAL.instantiate()
	parrot.position = Vector2(
		animal_start.position.x,
		animal_start.position.y
	)
	add_child(parrot)
