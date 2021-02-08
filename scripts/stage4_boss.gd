extends "res://scripts/stage_father_boss.gd"

func _ready():
	STAGE_NUMBER = 4
	ProjectSettings.set_setting("stage", STAGE_NUMBER)
	var bg_4 = preload("res://asset/stage4/boss/stage4_boss.png")
	var miguel_skel_anim = preload("res://animations/Miguel_skel.tres")
	var bg_zone_boss = preload("res://sound/stage4.boss.ogg")
	$env/bg.texture = bg_4
	$YSort/player/AnimatedSprite.frames = miguel_skel_anim
	$p_exit.global_position = $p_exit_stage.global_position
	$bgm.stream = bg_zone_boss
	$bgm.play()
	var boss_pos = $YSort/boss.global_position
	$YSort.remove_child($YSort/boss)
	var boss = preload("res://enemy_boss_kyler.tscn").instance()
	boss.name = 'boss'
	boss.global_position = boss_pos
	$YSort.add_child(boss)
	init_enemy('boss')
	init_boss()
	$YSort/boss.status = $YSort/boss.STATES.WAITING_FOR_PLAYER
	$YSort/boss/AnimatedSprite.play('guard')
