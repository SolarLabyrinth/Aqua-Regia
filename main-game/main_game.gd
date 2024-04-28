extends Node2D

const SCORE_TO_LOSE = 0
const SCORE_TO_WIN = 14

static var RNG = RandomNumberGenerator.new()

const ESSENCE = preload("res://essence/essence.tscn")
const PURITY = preload("res://purity-shards/PurityShard.tscn")
const IMPURITY = preload("res://purity-shards/ImpurityShard.tscn")

const RED = preload("res://essence/red.png")
const GREEN = preload("res://essence/green.png")
const YELLOW = preload("res://essence/yellow.png")
const BROWN = preload("res://essence/brown.png")
const WHITE = preload("res://essence/white.png")
const BLACK = preload("res://essence/black.png")

var next_essence_type
var next_essence
var purity = 7

func _init():
	#RNG.seed = 12345
	pass

func _ready():
	%Music.play()
	
	if %Music.playing:
		%MusicUnchecedColor1.hide()
		%MusicUnchecedColor2.hide()
	else:
		%MusicUnchecedColor1.show()
		%MusicUnchecedColor2.show()
	
	Events.purity.connect(on_purity)
	Events.impurity.connect(on_impurity)
	Events.pot_overflowed.connect(on_overflow)
	setup_game()

func setup_game():
	Events.destroy_essences.emit()
	set_purity(7)
	next_essence_type = generate_essence_type()
	update_next_essence_graphic()

func set_purity(amount: int):
	purity = amount
	%ProgressBar.frame = clampi(purity ,SCORE_TO_LOSE,SCORE_TO_WIN)

func modify_purity(amount: int):
	set_purity(purity + amount)
	if purity >= SCORE_TO_WIN:
		show_win_screen()
	if purity <= SCORE_TO_LOSE:
		show_loss_screen()

func on_purity(midpoint):
	var newEssence = PURITY.instantiate()
	newEssence.global_position = midpoint 
	add_child(newEssence)
	modify_purity(1)

func on_impurity(midpoint):
	var newEssence = IMPURITY.instantiate()
	newEssence.global_position = midpoint 
	add_child(newEssence)
	modify_purity(-1)

func create_essence(type, position):
	var newEssence = ESSENCE.instantiate()
	newEssence.global_position = position 
	newEssence.type = next_essence_type
	return newEssence

var last_i = -1

func generate_essence_type():
	var i = RNG.randi_range(0, 5)
	while last_i == i:
		i = RNG.randi_range(0, 5)
	last_i = i
	return ['ignis','aether','aqua','terra','umbra','ventus'][i]

func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("spawn_essence", true) and event.is_pressed():
		%PlopPlayer.play()
		spawn_next_essence(event.position)

func spawn_next_essence(position: Vector2):
	if next_essence: next_essence.queue_free()
	
	var newEssence = create_essence(next_essence_type, position) 
	add_child(newEssence)
	
	next_essence_type = generate_essence_type() 
	update_next_essence_graphic() 

func update_next_essence_graphic():
	if next_essence_type == 'ignis':
		%NextColorSprite.texture =  RED
	elif next_essence_type == 'aqua':
		%NextColorSprite.texture =  GREEN
	elif next_essence_type == 'ventus':
		%NextColorSprite.texture =  WHITE
	elif next_essence_type == 'terra':
		%NextColorSprite.texture =  BROWN
	elif next_essence_type == 'aether':
		%NextColorSprite.texture =  YELLOW
	elif next_essence_type == 'umbra':
		%NextColorSprite.texture =  BLACK 

func show_win_screen() -> void:
	%WinScreen.show()
	$InGameMenu.hide()
	$Game.hide()
	$MainMenu.hide()
	%FailScreen.hide()
	%Overflow.hide()
func show_loss_screen() -> void:
	%FailScreen.show()
	$InGameMenu.hide()
	$Game.hide()
	$MainMenu.hide()
	%WinScreen.hide()
	%Overflow.hide()
func show_main_menu() -> void:
	$MainMenu.show()
	$InGameMenu.hide()
	$Game.hide()
	%WinScreen.hide()
	%FailScreen.hide()
	%Overflow.hide()
func show_overflow() -> void:
	%Overflow.show()
	$MainMenu.hide()
	$InGameMenu.hide()
	$Game.hide()
	%WinScreen.hide()
	%FailScreen.hide()
func show_in_game_menu() -> void:
	$InGameMenu.show()
	$Game.hide()
	$MainMenu.hide()
	%WinScreen.hide()
	%FailScreen.hide()
	%Overflow.hide()
func show_game() -> void:
	$Game.show()
	$InGameMenu.hide()
	$MainMenu.hide()
	%WinScreen.hide()
	%FailScreen.hide()
	%Overflow.hide()

func _on_options_button_pressed() -> void:
	if !$ClickPlayer.playing: $ClickPlayer.play()
	
	if %Music.playing:
		%MusicUnchecedColor1.hide()
		%MusicUnchecedColor2.hide()
	else:
		%MusicUnchecedColor1.show()
		%MusicUnchecedColor2.show()
	
	show_in_game_menu()
func _on_game_start_pressed() -> void:
	if !$ClickPlayer.playing: $ClickPlayer.play()
	show_game()
func _on_resume_pressed() -> void:
	if !$ClickPlayer.playing: $ClickPlayer.play()
	show_game()
func _on_restart_game() -> void:
	if !$ClickPlayer.playing: $ClickPlayer.play()
	setup_game()
	show_game()
func on_overflow():
	show_overflow()

func _on_sound_toggle() -> void:
	if !$ClickPlayer.playing: $ClickPlayer.play()
	
	if %Music.playing:
		%Music.stop()
		%MusicUnchecedColor1.show()
		%MusicUnchecedColor2.show()
	else:
		%Music.play()
		%MusicUnchecedColor1.hide()
		%MusicUnchecedColor2.hide()


func on_glass_pressed() -> void:
	%GlassPlayer.play()

