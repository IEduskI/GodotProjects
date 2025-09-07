extends Node

const GAME = preload("res://Scenes/Game/Game.tscn")
const MAIN = preload("res://Scenes/Main/Main.tscn")
const SIMPLE_TRANSITION = preload("res://Scenes/SimpleTransition/SimpleTransition.tscn")
const COMPLEX_TRANSITION = preload("res://Scenes/ComplexTransition/ComplexTransition.tscn")

var nextScene: PackedScene

func add_complex() -> void:
	var ct = COMPLEX_TRANSITION.instantiate()
	add_child(ct)

func loadGameScene() -> void:
	nextScene = GAME
	add_complex()
	#get_tree().change_scene_to_packed(SIMPLE_TRANSITION)

func loadMainScene() -> void:
	nextScene = MAIN
	add_complex()
	#get_tree().change_scene_to_packed(SIMPLE_TRANSITION)
