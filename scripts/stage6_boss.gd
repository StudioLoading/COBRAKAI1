extends "res://scripts/stage_father_boss.gd"


func _ready():
	STAGE_TIMER = 99
	init_player()
	#instantiate the $YSort/boss node
	var boss_pos = $YSort/boss.global_position
	$YSort.remove_child($YSort/boss)
	var boss = preload("res://enemy_boss_vidal.tscn").instance()
	boss.name = 'boss'
	boss.global_position = boss_pos
	$YSort.add_child(boss)
	init_enemy('boss')
	init_boss()
	$YSort/boss.status = $YSort/boss.STATES.WAITING_FOR_PLAYER
	$YSort/boss/AnimatedSprite.play('guard')
	play_intro()

func init_player_child():
	$YSort/player/Camera2D.current =false
	$Camera2D.current = true

func play_intro():
	$bgm.stream = bgm_boss_talk
	$bgm.play()
	var d = []
	var d0 = {'psg': 'vidal', 'd': 'So you want to\nlearn some more karate?\nLearn the Crane Kick!'}
	d.append(d0)
	$GUI/cl/s.show()
	next_dialog(d, 0)
	yield(get_tree().create_timer(3), "timeout")
	var d1 = {'psg': 'vidal', 'd': 'Watch and Learn!\n FIGHT ME!'}
	d.append(d1)
	next_dialog(d, 1)
	yield(get_tree().create_timer(2), "timeout")
	$GUI/cl/s.hide()
	$bgm.stream = bgm_boss_stage
	$bgm.play()
	$YSort/boss/AnimatedSprite.play('kick')
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


func on_boss_defeated():
	print('BGM changes to trophy')
	print('BGM waiting for the thiumph sound to end')
	print('Boss talks')
	var d = []
	var d0 = {'psg': 'vidal', 'd': 'You are a good student.'}
	var d1 = {'psg': 'vidal', 'd': 'I can still remember\nyour sensei at that\ntournament.'}
	var d2 = {'psg': 'miguel', 'd': '... You fought ?'}
	var d3 = {'psg': 'vidal', 'd': '.. and a very good\nfight it was!\nAnd now...'}
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
	yield(get_tree().create_timer(4), "timeout")
	next_dialog(d, 4)
	yield(get_tree().create_timer(2), "timeout")
	next_dialog(d, 3)
	yield(get_tree().create_timer(4), "timeout")
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
	$YSort/boss/AnimatedSprite.play('jab')
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
#	$GUI/player._on_select()
#	$GUI/player._on_select()
#	$GUI/player._on_select()
#	$GUI/player._on_select()
	$YSort/player.set_process(false)
	$YSort/player/AnimatedSprite.disconnect('animation_finished', $YSort/player, '_on_AnimatedSprite_animation_finished')
	$YSort/player/AnimatedSprite.frames = load("res://animations/Miguel.tres")
	$YSort/player/AnimatedSprite.play('kick')
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player/AnimatedSprite.play('guard')
	$YSort/player.global_position.y -= 4
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player.global_position.y += 4
	yield(get_tree().create_timer(0.5), "timeout")
	$YSort/player/AnimatedSprite.play('kick')
	$YSort/player/kiai.frame = 0
	$YSort/player/kiai.play()
	$YSort/player/AnimatedSprite.play('cranekick')
	yield($YSort/player/AnimatedSprite, "animation_finished")
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

