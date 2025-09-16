extends Area2D

@onready var splash_sound: AudioStreamPlayer2D = $SplashSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	splash_sound.position = body.position
	splash_sound.play()
