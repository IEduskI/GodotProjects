extends Control

@onready var highscore_text: Label = $MarginContainer/HighscoreText

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		GameManager.loadGameScene()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	highscore_text.text = "%04d" % ScoreManager.highScore
