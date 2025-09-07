extends Node

const SCORES_PATH: String = "user://tappy.tres"

var actualScore: int = 0

var highScore: int:
	get:
		return actualScore
	set(value):
		if value > actualScore:
			actualScore = value
			saveHighScore()

func _ready() -> void:
	loadHighScore()

func loadHighScore() -> void:
	if ResourceLoader.exists(SCORES_PATH) == true:
		var hsr: HighScoreResource = load(SCORES_PATH)
		if hsr:
			actualScore = hsr.high_score

func saveHighScore() -> void:
	var hsr: HighScoreResource = HighScoreResource.new()
	hsr.high_score = actualScore
	ResourceSaver.save(hsr, SCORES_PATH)
