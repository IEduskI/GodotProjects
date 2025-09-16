extends Control

@onready var attempts_label: Label = $MarginContainer/VBoxContainer/AttemptsLabel
@onready var vb_game_over: VBoxContainer = $MarginContainer/VBGameOver
@onready var music: AudioStreamPlayer = $Music
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel

var _attempts: int = 0

func _ready() -> void:
	_attempts = 0
	level_label.text = "Level  %s" % ScoreManager.level_selected

func _enter_tree() -> void:
	SignalHub.on_attempt_made.connect(on_attempt_made)
	SignalHub.on_cup_destroyed.connect(on_cup_destroyed)

func on_attempt_made() -> void:
	_attempts += 1
	attempts_label.text = "Attempt  %d" % _attempts

func on_cup_destroyed(remainig_cups: int) -> void:
	if remainig_cups == 0:
		vb_game_over.show()
		music.play()
		ScoreManager.set_score_for_level(
			ScoreManager.level_selected,
			_attempts
		)
