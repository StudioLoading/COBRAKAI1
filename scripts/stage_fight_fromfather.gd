extends "res://scripts/stage_father.gd"


signal blink

onready var johnny_skel_anim = preload("res://animations/Johnny.tres")
onready var miguel_anim = preload("res://animations/Miguel.tres")
onready var miguel_skel_anim = preload("res://animations/Miguel_skel.tres")


func _ready():
	STAGE_NUMBER = 1
	NO_TIME_STAGE = false
		
	$YSort/spawner.config($YSort/spawner.TYPES.TIME, 'park', $YSort/player, true, true, $diags)
	$YSort/bri.config($YSort/bri.TYPES.SCORE, 'bri', $YSort/player, false, false, $diags)
	
	$YSort/player/AnimatedSprite.frames = johnny_skel_anim
	$YSort/player.global_position = $YSort/spawner_player_stage.global_position
	
	init_player()
	
	init_enemy('johnny')
	init_enemy('enemy')
	
	pass # Replace with function body.


func reset_player_position():
	$YSort/player.global_position = $YSort/spawner_player_stage.global_position

func hide_enemy_on_gui(e):
	if $GUI/enemy.visible:
		$GUI/enemy.hide()
