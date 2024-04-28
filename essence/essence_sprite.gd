extends Sprite2D

enum EssenceColor { RED, GREEN, YELLOW, BROWN, WHITE, BLACK }

@export var color: EssenceColor

const RED = preload("res://essence/red.png")
const GREEN = preload("res://essence/green.png")
const YELLOW = preload("res://essence/yellow.png")
const BROWN = preload("res://essence/brown.png")
const WHITE = preload("res://essence/white.png")
const BLACK = preload("res://essence/black.png")

func create() -> void:
	set_color(color)

func set_color(color: EssenceColor):
	if color == EssenceColor.RED:
		texture = RED
	elif color == EssenceColor.GREEN:
		texture = GREEN
	elif color == EssenceColor.YELLOW:
		texture = YELLOW
	elif color == EssenceColor.BROWN:
		texture = BROWN
	elif color == EssenceColor.WHITE:
		texture = WHITE
	elif color == EssenceColor.BLACK:
		texture = BLACK 
