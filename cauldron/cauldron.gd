extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_groups().has("Essence"):
		body.passed_gate = true
		#body.set_gravity_scale(0.1)
