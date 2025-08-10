extends Node2D

class_name Game

const EXPLODE = preload("res://assets/explode.wav")
const GEM = preload("res://Scenes/Gem/gem.tscn")
const MARGIN: float = 70.0

@onready var spawnTimer: Timer = $SpawnTimer
@onready var paddle: Area2D = $Paddle
@onready var scoreSound: AudioStreamPlayer2D = $ScoreSound
@onready var sound: AudioStreamPlayer = $Sound
@onready var scoreLabel: Label = $ScoreLabel

static var viewportRect: Rect2

static func get_vpr() -> Rect2:
	return viewportRect

func _ready() -> void:
	update_viewport()
	get_viewport().size_changed.connect(update_viewport)
	spawn_gem()

func update_viewport() -> void:
	viewportRect = get_viewport_rect()

func spawn_gem() -> void:
	var newGem: Gem = GEM.instantiate()
	var xPos: float = randf_range(
		viewportRect.position.x + MARGIN,
		viewportRect.end.x - MARGIN
	)
	newGem.position = Vector2(xPos, -50.0)
	newGem.gem_off_screen.connect(_on_gem_off_screen)
	add_child(newGem)

func stop_all() -> void:
	sound.stop()
	sound.stream = EXPLODE
	sound.play()
	spawnTimer.stop()
	paddle.set_process(false)
	for child in get_children():
		if child is Gem:
			child.set_process(false)

func addPoint() -> void:
	var points: int
	points += scoreLabel.text.to_int() + 1
	scoreLabel.text = "%03d" % points

func _on_paddle_area_entered(area:Area2D) -> void:
	print("Paddle area entered: ", area)
	addPoint()
	if scoreSound.playing == false:
		scoreSound.position = area.position
		scoreSound.play()

func _on_gem_off_screen() -> void:
	stop_all()

func _on_timer_timeout() -> void:
	spawn_gem()
