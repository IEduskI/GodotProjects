extends Node

const GAME = preload("res://Scenes/Game/Game.tscn")
const MAIN = preload("res://Scenes/Main/Main.tscn")

func loadGameScene() -> void:
	get_tree().change_scene_to_packed(GAME)

func loadMainScene() -> void:
	get_tree().change_scene_to_packed(MAIN)
