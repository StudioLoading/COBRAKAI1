extends "res://scripts/stage_father.gd"

onready var bgm_boss_talk = preload("res://sound/stageboss_final_talk.ogg")
onready var bgm_boss_stage = preload("res://sound/stage4.boss.ogg")
onready var final_token_pos = null

func _ready():
	STAGE_TIMER = 59
	STAGE_NUMBER = ProjectSettings.get_setting("stage")
	if STAGE_NUMBER == null:
		STAGE_NUMBER = 7
	elif 'boss_intro' in STAGE_NUMBER:
		STAGE_NUMBER = STAGE_NUMBER.substr(0,1)
	STAGE_NUMBER = int(STAGE_NUMBER)
	match STAGE_NUMBER:
		4:
			$env/bg.texture = load("res://asset/stage4/boss/stage4_boss.png")
			$env/bg/token.texture = load("res://asset/GUI/combo/combo.1.png")
			final_token_pos = $GUI/player/h_down/c/c/combo0/p.global_position
		6:
			$env/bg.texture = load("res://asset/stage6/boss/bg.png")
			$env/bg/token.texture = load("res://asset/GUI/combo/combo.2.png")
			bgm_boss_talk = preload("res://sound/vidal.ogg")
			bgm_boss_stage = preload("res://sound/stage2.ogg")
			final_token_pos = $GUI/player/h_down/c/c/combo1/p.global_position
		7:
			$env/bg.texture = load("res://asset/stage7/boss/bg.png")
			$env/bg/token.texture = load("res://asset/GUI/combo/combo.3.png")
			bgm_boss_talk = preload("res://sound/vidal.ogg")
			bgm_boss_stage = preload("res://sound/stage2.ogg")
			final_token_pos = $GUI/player/h_down/c/c/combo2/p.global_position
	print('final_token_pos=',final_token_pos)
	print('expected 0: ', $GUI/player/h_down/c/c/combo0/p.global_position)
	print('combo1.p: ', $GUI/player/h_down/c/c/combo1/p.global_position)
	print('combo2.p: ', $GUI/player/h_down/c/c/combo2/p.global_position)
	ProjectSettings.set_setting("stage", str(str(STAGE_NUMBER)+"boss"))
	$YSort/spawn_player.global_position = $YSort/spawn_player_stage.global_position
	reset_player_position()
	init_player()
	init_enemy('boss')
	init_boss()
	$bgm.stream = bgm_boss_talk
	$bgm.volume_db = -6
	
func init_boss():
	for c in $env.get_children():
		if c is Position2D and 'p0' in c.name:
			$YSort/boss.add_position(c)
	$YSort/boss.connect("boss_defeated", self, 'on_boss_defeated')
	
func init_player_child():
	$YSort/player/Camera2D.current =false
	$Camera2D.current = true
	play_intro()

func play_intro():
	var d = []
	var d0 = {'psg': 'ky', 'd': '!! GRAB HIM !!'}
	d.append(d0)
	$GUI/cl/s.show()
	$bgm.stream = bgm_boss_talk
	$bgm.play()
	next_dialog(d, 0)
	yield(get_tree().create_timer(4), "timeout")
	$GUI/cl/s.hide()
	$bgm.stream = bgm_boss_stage
	$bgm.play()
	$YSort/boss.move($YSort/boss.STATES.REACHING_PLAYER, null, null, null, null)

func _on_Area2D_body_entered(body):
	if body.is_in_group('group_enemies') and body.is_in_group('boss'):
		$YSort/boss.next_position()
	pass # Replace with function body.

func enemy_dead(enemy):
	print('stage_father_boss TODO stoppa il tempo')
	$GUI/player/time.pause_resume(true,false)
	$GUI/enemy.hide()
	$bgm.stop()

func on_boss_defeated():
	print('BGM changes to trophy')
	print('BGM waiting for the thiumph sound to end')
	print('Boss talks')
	var d = []
	var d0 = {'psg': 'ky', 'd': 'You are all right\nDiaz!'}
	var d1 = {'psg': 'ky', 'd': 'You\'ve earned\nit!'}
	var d2 = {'psg': 'miguel', 'd': 'What should I\ndo with this?'}
	var d3 = {'psg': 'ky', 'd': 'Look !'}
	d.append(d0)
	d.append(d1)
	d.append(d2)
	d.append(d3)
	$GUI/cl/s.show()
	$bgm.stream = bgm_boss_talk
	$bgm.play()
	next_dialog(d, 0)
	yield(get_tree().create_timer(2), "timeout")
	next_dialog(d, 1)
	yield(get_tree().create_timer(1), "timeout")
	$GUI/cl/s.hide()
	print('Boss goes to the trophy')
	if $YSort/boss.global_position.x < $YSort/boss_final_position.global_position.x:
		$YSort/boss/AnimatedSprite.flip_h = false
	else:
		$YSort/boss/AnimatedSprite.flip_h = true
	$YSort/boss/AnimatedSprite.play('walk')
	$Tween.interpolate_property($YSort/boss, "global_position", $YSort/boss.global_position, $YSort/boss_final_position.global_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$YSort/boss/AnimatedSprite.flip_h = true
	yield(get_tree().create_timer(1), "timeout")
	print('Boss hits the trophy')
	$YSort/boss/AnimatedSprite.play('raw')
	yield($YSort/boss/AnimatedSprite, "animation_finished")
	$bgm.playing =false
	$efx.stream = preload("res://sound/effects/boss_glass_broken.ogg")
	$efx.play()
	$env/bg/specchio.texture = load("res://asset/stage4/boss/specchio_broken.png")
	yield($efx, "finished")
	print('The trophy goes right in the selection')
	$Tween.interpolate_property($env/bg/token, "global_position", $env/bg/token.global_position, final_token_pos, 3, Tween.TRANS_LINEAR)
	$Tween.interpolate_property($env/bg/token, "scale", $env/bg/token.scale, Vector2(2,2), 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.interpolate_property($env/bg/token, "scale", Vector2(2,2), Vector2(1,1), 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 1.5)
	$Tween.start()
	$efx.stream = efx_new_combo
	$efx.play()
	print('Save the new combo')
	yield($efx, "finished")
	yield($Tween, "tween_all_completed")
	$efx.stream = load('res://sound/effects/combo_picked.ogg')
	$efx.play()
	$GUI/player.add_combo()
	print('Miguel asks what\'s for')
	$GUI/cl/s.show()
	next_dialog(d, 2)
	yield(get_tree().create_timer(2), "timeout")
	print('Boss answers')
	next_dialog(d, 3)
	yield(get_tree().create_timer(2), "timeout")
	$GUI/cl/s.hide()
	$GUI/player._on_select()
	$GUI/player._on_select()
	$GUI/player._on_select()
	$YSort/player.set_process(false)
	$YSort/player/AnimatedSprite.disconnect('animation_finished', $YSort/player, '_on_AnimatedSprite_animation_finished')
	$YSort/player/AnimatedSprite.frames = load("res://animations/Miguel.tres")
	$YSort/player/AnimatedSprite.play('jab')
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player/AnimatedSprite.play('guard')
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player/AnimatedSprite.play('jab')
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player/AnimatedSprite.play('guard')
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player/AnimatedSprite.play('raw')
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player/AnimatedSprite.play('guard')
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player/kiai.frame = 0
	$YSort/player/kiai.play()
	$YSort/player/AnimatedSprite.play('uppercut')
	print('TODO kiai audio')
	print('Save the new combo')
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player/AnimatedSprite.play('guard')
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player/AnimatedSprite.flip_h = false
	$YSort/player/AnimatedSprite.play('walk')
	$Tween.interpolate_property($YSort/player, "global_position", $YSort/player.global_position, $env/player_final_pos.global_position, 2, Tween.TRANS_LINEAR)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$YSort/player/AnimatedSprite.animation = 'guard'
	$YSort/player/AnimatedSprite.hide()
	print('Stage Complete as usual')
	play_outro()
	print(' COMBO_UNLOCKED = ', ProjectSettings.get_setting('combo_unlocked'))
	pass
	
func next_dialog(d, i):
	var face
	var speak
	var animation = 'default'
	if i < d.size():
		match d[i]['psg']:
			'ky':
				face = load("res://asset/GUI/highschool/ky_mute.png")
				speak = load("res://animations/intro_gui_ky.tres")
			'miguel':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
			'johnny':
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
#				if $bg.stream != bg_johnny:
#					$bg.stop()
#					$bg.stream = bg_johnny
#					if !$bg.playing:
#						$bg.play()
		$GUI/cl/s/m/hb/ccf/face.texture = face
		$GUI/cl/s/m/hb/ccf/face/speak.frames = speak
		$GUI/cl/s/m/hb/ccf/face/speak.animation = animation
		$GUI/cl/s/m/hb/ccf/face/speak.play()
		$GUI/cl/s/m/hb/cct/text.text = d[i]['d']

func check_stage_complete():
#	var completed = true
#	for e in $YSort.get_children():
#			if e.is_in_group('group_enemies'):
##				print(e.name,'HP=', e.HP)
#				if e.HP > 0:
#					completed=false
#	if completed:
#		print('STAGE COMPLETE! all enemies down. play_outro func commented here below')
#		play_outro_stage()
	pass

