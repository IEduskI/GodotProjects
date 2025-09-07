extends Control

const GAME_OVER = preload("res://assets/audio/game_over.wav")

@onready var game_over_label: Label = $GameOverLabel
@onready var timer: Timer = $Timer
@onready var press_space_label: Label = $PressSpaceLabel
@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var sound: AudioStreamPlayer = $Sound

var canPress: bool = false
var score: int = 0

func _ready() -> void:
	score = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		GameManager.loadMainScene()
	elif canPress and event.is_action_pressed("jump"):
		ScoreManager.highScore = score
		GameManager.loadMainScene()

func _enter_tree() -> void:
	SignalHub.on_point_scored.connect(on_point_scored)
	SignalHub.on_plane_died.connect(onPlayerDied)

func on_point_scored() -> void:
	sound.play()
	score += 1
	score_label.text = "%04d" % score

func onPlayerDied() -> void:
	sound.stop()
	sound.stream = GAME_OVER
	sound.play()
	game_over_label.show()
	timer.start()

func _on_timer_timeout() -> void:
	game_over_label.hide()
	press_space_label.show()
	canPress = true
