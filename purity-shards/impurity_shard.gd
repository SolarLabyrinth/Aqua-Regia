extends RigidBody2D

func _ready():
	Events.destroy_essences.connect(on_destroy_essences)
func _exit_tree() -> void:
	Events.destroy_essences.disconnect(on_destroy_essences)

func on_destroy_essences():
	queue_free()
