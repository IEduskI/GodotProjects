extends Node

signal on_plane_died
signal on_point_scored

# This is only for quit the warning
func emitOnPlaneDied() -> void:
	on_plane_died.emit()

func emitOnPointScored() -> void:
	on_point_scored.emit()
