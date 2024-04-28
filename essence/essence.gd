extends RigidBody2D

@export var type: String 
var is_dead = false
var passed_gate = false

@onready var ignis = %Ignis
@onready var aether = %Aether
@onready var aqua = %Aqua
@onready var terra = %Terra
@onready var umbra = %Umbra
@onready var ventus = %Ventus

func enable_sprite():
	if type == 'ignis':
		ignis.show()
	elif type == 'aether':
		aether.show()
	elif type == 'aqua':
		aqua.show()
	elif type == 'terra':
		terra.show()
	elif type == 'umbra':
		umbra.show()
	elif type == 'ventus':
		ventus.show()
	else:
		print("invalid type", type)
		queue_free()

func _ready():
	enable_sprite()
	Events.destroy_essences.connect(on_destroy_essences)

func _exit_tree() -> void:
	Events.destroy_essences.disconnect(on_destroy_essences)
	
func on_destroy_essences():
	queue_free()

#func set_gravity_scale(a):
	#gravity_scale = a

func collision(body): 
	is_dead = true
	body.is_dead = true
	queue_free()
	body.queue_free()

func positive_collision(body):
	if !is_dead && !body.is_dead:
		var midpoint = lerp(global_position, body.global_position, 0.5)
		Events.purity.emit(midpoint)
		collision(body)

func negative_collision(body):
	if !is_dead && !body.is_dead:
		var midpoint = lerp(global_position, body.global_position, 0.5)
		Events.impurity.emit(midpoint)
		collision(body)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if "type" in body:
		if type == 'aether':
			if body.type == 'terra' or body.type == 'umbra':
				negative_collision(body)
			if body.type == 'ignis':
				positive_collision(body)
		if type == 'ignis':
			if body.type == 'aqua' or body.type == 'ventus':
				negative_collision(body)
			if body.type == 'aether':
				positive_collision(body)
		if type == 'terra':
			if body.type == 'aether' or body.type == 'ventus':
				negative_collision(body)
			if body.type == 'aqua':
				positive_collision(body)
		if type == 'aqua':
			if body.type == 'ignis' or body.type == 'umbra':
				negative_collision(body)
			if body.type == 'terra':
				positive_collision(body)
		if type == 'ventus':
			if body.type == 'terra' or body.type == 'ignis':
				negative_collision(body)
			if body.type == 'umbra':
				positive_collision(body)
		if type == 'umbra':
			if body.type == 'aether' or body.type == 'aqua':
				negative_collision(body)
			if body.type == 'ventus':
				positive_collision(body)


func _on_timer_timeout() -> void:
	if !passed_gate:
		Events.pot_overflowed.emit()
