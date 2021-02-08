extends "res://scripts/stage_father_boss.gd"

func _ready():
	var bg_7 = preload("res://asset/stage7/boss/bg.png")
	var johnny_gi_anim = preload("res://animations/Johnny_gi.tres")
	var bg_zone_boss = preload("res://sound/stage4.boss.ogg")
	var p = $YSort/player
	$YSort.remove_child(p)
	var johnny = load("res://Johnny.tscn").instance()
	johnny.get_node("AnimatedSprite").frames = johnny_gi_anim
	johnny.name = 'player'
	$YSort.add_child(johnny)
	$p_exit.global_position = $p_exit_stage.global_position
	$bgm.stream = bg_zone_boss
	$bgm.play()
	var boss_pos = $YSort/boss.global_position
	$YSort.remove_child($YSort/boss)
	var boss = preload("res://enemy_boss_daniel.tscn").instance()
	boss.name = 'boss'
	boss.global_position = boss_pos
	$YSort.add_child(boss)
	init_enemy('boss')
	init_boss()
	$YSort/boss.status = $YSort/boss.STATES.WAITING_FOR_PLAYER
	$YSort/boss/AnimatedSprite.play('guard')
	$YSort/spawn_player.global_position = $YSort/spawn_player_stage.global_position
	reset_player_position()
	init_player()
