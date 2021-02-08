extends "res://scripts/stage_father.gd"

onready var bg_4 = preload("res://asset/stage4/boss/bg_intro.png")
onready var bg_6 = preload("res://asset/stage6/boss/bg_intro.png")
onready var bg_7 = preload("res://asset/stage7/boss/bg_intro.png")
onready var miguel_skel_anim = preload("res://animations/Miguel_skel.tres")
onready var johnny_gi_anim = preload("res://animations/Johnny_gi.tres")
onready var stage_number

func _ready():
	stage_number = ProjectSettings.get_setting("stage")
	if stage_number == null:
		stage_number = 4
	match stage_number:
		4:
			$env/bg.texture = bg_4
			$YSort/player/AnimatedSprite.frames = miguel_skel_anim
		6:
			$env/bg.texture = bg_6
		7:
			$env/bg.texture = bg_7
			var p = $YSort/player
			$YSort.remove_child(p)
			var johnny = load("res://Johnny.tscn").instance()
			johnny.get_node("AnimatedSprite").frames = johnny_gi_anim
			johnny.name = 'player'
			$YSort.add_child(johnny)
	$p_exit.global_position = $p_exit_stage.global_position
	$bgm.stream = bg_zone_boss
	$bgm.play()
	ProjectSettings.set_setting("stage", str(str(stage_number)+"boss_intro"))
	$YSort/spawn_player.global_position = $YSort/spawn_player_stage.global_position
	reset_player_position()
	init_player()
	

func play_outro():
	$efx.pause_mode = true
	var life = $YSort/player.HP
	var time = $GUI/player.get_time()
	var score = $GUI/player.get_score()
	var up = $GUI/player.get_lifes()
	ProjectSettings.set_setting("stage", STAGE_NUMBER)
	ProjectSettings.set_setting("life", life)
	ProjectSettings.set_setting("time", time)
	ProjectSettings.set_setting("score", score)
	ProjectSettings.set_setting("up", up)
	yield(get_tree().create_timer(2), "timeout")
	#get_tree().change_scene("res://stage4_boss_intro.tscn")


func _on_back_to_stage_body_entered(body):
	if body.is_in_group('player'):
		$YSort/player.set_process(false)
		$bgm.stop()
		yield(get_tree().create_timer(0.3), "timeout")
		get_tree().change_scene(str("res://stage"+str(stage_number)+".tscn"))
	pass # Replace with function body.

func _on_exit_body_entered(body):
	if body.is_in_group('player'):
		$YSort/player.set_process(false)
		$bgm.stop()
		yield(get_tree().create_timer(0.3), "timeout")
		get_tree().change_scene(str("res://stage"+str(stage_number)+"_boss.tscn"))
	pass # Replace with function body.
