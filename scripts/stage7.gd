extends "res://scripts/stage_father.gd"

var d = []

func _ready():
#	$ColorRect.show()
	$YSort/player.global_position = $env/miguel_start_pos.global_position
#	reset_player_position()
	$YSort/player/Camera2D.current =false
	$Camera2D.current = true
	STAGE_TIMER = 59
	STAGE_NUMBER = ProjectSettings.get_setting("stage")
	if STAGE_NUMBER == null:
		STAGE_NUMBER = 7
	ProjectSettings.set_setting("stage", str(STAGE_NUMBER))
	$YSort/spawn_player.global_position = $YSort/spawn_player_stage.global_position
	stage_bg = preload('res://sound/stage7.ogg')
	$bgm.stream = stage_bg
	$bgm.play()
	NO_TIME_STAGE = true
	yield(get_tree().create_timer(2), "timeout")
	init_player()
	
	init_enemy('bert')
	$YSort/bert/AnimatedSprite.play('guard')
	$YSort/bert.connect('defeated', self, 'bert_defeated')
	
	init_enemy('aisha')
	$YSort/aisha/AnimatedSprite.play('guard')
	$YSort/aisha.connect('defeated', self, 'aisha_defeated')
	
	init_enemy('hawk')
	$YSort/hawk/AnimatedSprite.play('guard')
	$YSort/hawk.connect('defeated', self, 'hawk_defeated')
	
	init_enemy('enemy_johnny')
	$YSort/enemy_johnny/AnimatedSprite.play('guard')
	$YSort/enemy_johnny.connect('defeated', self, 'johnny_defeated')
#	$Tween_intro.interpolate_property($ColorRect, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 3, Tween.TRANS_EXPO, Tween.EASE_IN)
#	yield($Tween_intro, "tween_all_completed")
#	print('stage7 tween_intro completed')
#	$ColorRect.queue_free()
	play_intro()
	$YSort/hp/Sprite.texture = load('res://animations/item_spawner_hp.tres')
	$YSort/hp.config($YSort/player, $YSort/hp.TYPES.HP)
	$YSort/hp.connect('picked_up', $GUI/player, 'item_picked_up')
	

func init_player_child():
	$YSort/player/AnimatedSprite/backfist.set_deferred('monitoring', true)
	$YSort/player/AnimatedSprite/backkick.set_deferred('monitoring', true)
	$YSort/player/AnimatedSprite/jab.set_deferred('monitoring', true)
	$YSort/player/AnimatedSprite/raw.set_deferred('monitoring', true)
	$YSort/player/AnimatedSprite/kick.set_deferred('monitoring', true)
	$YSort/player/Camera2D.current =false
	$Camera2D.current = true
	$YSort/player.set_process(false)

func play_intro():
	var d0 = {'psg': 'Johnny', 'd': 'Today, we start the\ntraining for\nthe tournament!'}
	var d1 = {'psg': 'ALL', 'd': '**YES SENSEI**'}
	var d2 = {'psg': 'Johnny', 'd': 'and YOU\n(yeah, you)\nwill show us your best.'}
	var d3 = {'psg': 'Miguel', 'd': 'Yes Sensei'}
	var d4 = {'psg': 'Johnny', 'd': 'ALL THE OTHERS\nwatch and learn.'}
	var d5 = {'psg': 'Johnny', 'd': 'First you face Bert,\nthen our Aisha girl...'}
	var d6 = {'psg': 'Hawk_enters', 'd': '*dling*'}
	var d7 = {'psg': 'Johnny', 'd': 'Nice cut bro..\nHAWK!\nFall in.'}
	var d8 = {'psg': 'Hawk', 'd': 'Yes Sensei'}
	var d9 = {'psg': 'Johnny', 'd': '... And finally\nthe Hawk.'}
	var d10 = {'psg': 'Johnny', 'd': 'BERT, DIAZ\nfall in'}
	var d11 = {'psg': 'Johnny', 'd': '.. bow..'}
	var d12 = {'psg': 'Johnny', 'd': 'FIGHT!'}
	var d13 = {'psg': 'Johnny', 'd': 'Good Fight - Bert!\nDiaz, stay focused.'}
	var d14 = {'psg': 'Johnny', 'd': 'AISHA!\nFall in.'}
	var d15 = {'psg': 'Johnny', 'd': '.. bow..'}
	var d16 = {'psg': 'Johnny', 'd': 'FIGHT!'}
	var d17 = {'psg': 'Johnny', 'd': 'STOOP!!\n'}
	var d18 = {'psg': 'Johnny', 'd': 'HAWK!\nFall in.'}
	var d19 = {'psg': 'Johnny', 'd': '.. bow..'}
	var d20 = {'psg': 'Johnny', 'd': 'FIGHT!'}
	var d21 = {'psg': 'Johnny', 'd': 'GREAT !!\nwell done.\nbut it is not over.'}
	var d22 = {'psg': 'Johnny', 'd': 'Now it is my turn\nFace Me.'}
	var d23 = {'psg': 'Johnny', 'd': '.. bow ..'}
	var d24 = {'psg': 'Johnny', 'd': 'FIGHT!'}
	d.append(d0)
	d.append(d1)
	d.append(d2)
	d.append(d3)
	d.append(d4)
	d.append(d5)
	d.append(d6)
	d.append(d7)
	d.append(d8)
	d.append(d9)
	d.append(d10)
	d.append(d11)
	d.append(d12)
	d.append(d13)
	d.append(d14)
	d.append(d15)
	d.append(d16)
	d.append(d17)
	d.append(d18)
	d.append(d19)
	d.append(d20)
	d.append(d21)
	d.append(d22)
	d.append(d23)
	d.append(d24)
	$GUI/cl/s.show()
	next_dialog(d, 0)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 1)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 2)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 3)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 4)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 5)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 6)
	#Hawk enters animation
	$bgm.stop()
	$bgm.stream = preload("res://sound/hawk.ogg")
	$bgm.play()
	$YSort/hawk_anim.play('walk')
	$Tween.interpolate_property($YSort/hawk_anim, "global_position", $YSort/hawk_anim.global_position, $env/hawk_first_pos.global_position  ,0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	print('stage7 Tween start hawk to first pos')
	$Tween.start()
	print('stage7 Tween wait hawk to first pos')
	yield($Tween, "tween_all_completed")
	$YSort/hawk_anim.play('guard')
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 7)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 8)
	yield(get_tree().create_timer(3), "timeout")
	$YSort/hawk_anim.play('walk')
	$Tween.interpolate_property($YSort/hawk_anim, "global_position", $YSort/hawk_anim.global_position, $env/hawk_final_pos.global_position , 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$YSort/hawk_anim.flip_h = true
	$YSort/hawk_anim.play('guard')
	next_dialog(d, 9)
	yield(get_tree().create_timer(3), "timeout")	
	next_dialog(d, 10)
	yield(get_tree().create_timer(3), "timeout")
	$Tween.interpolate_property($YSort/player, "global_position", $YSort/player.global_position, $env/miguel_start_pos.global_position ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($YSort/bert_anim, "global_position", $YSort/bert_anim.global_position, $env/enemy_start_pos.global_position  ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$YSort/bert_anim.play('walk')
	$YSort/player/AnimatedSprite.play('walk')
	yield($Tween, "tween_all_completed")
	next_dialog(d, 11)
	$YSort/bert_anim.play('guard')
	$YSort/player/AnimatedSprite.play('guard')
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 12)
	yield(get_tree().create_timer(1), "timeout")
	$GUI/cl/s.hide()
	$bgm.stop()
	$bgm.stream = stage_bg
	$bgm.play()
	$YSort/bert/AnimatedSprite.flip_h = true
	$YSort/bert.global_position = $YSort/bert_anim.global_position
	$YSort/bert_anim.hide()
	$env/tatami/left.set_deferred('disabled', false)
	$env/tatami/right.set_deferred('disabled', false)
	$YSort/player.set_process(true)
	$YSort/bert.status = $YSort/bert.STATES.REACHING_PLAYER
	
func next_dialog(d, i):
	var face
	var speak
	var animation = 'default'
	if i < d.size():
		match d[i]['psg']:
			'Miguel':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
			'Johnny':
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
			'Hawk':
				face = load("res://asset/GUI/cobra/Hawk_mute.png")
				speak = load("res://animations/intro_gui_hawk.tres")
		$GUI/cl/s/m/hb/ccf/face.texture = face
		$GUI/cl/s/m/hb/ccf/face/speak.frames = speak
		$GUI/cl/s/m/hb/ccf/face/speak.animation = animation
		$GUI/cl/s/m/hb/ccf/face/speak.play()
		$GUI/cl/s/m/hb/cct/text.text = d[i]['d']

func bert_defeated():
	$env/tatami/right.set_deferred('disabled', true)
	$YSort/bert_anim.global_position = $YSort/bert.global_position
	$YSort/bert.queue_free()
	$YSort/bert_anim.show()
	$YSort/player.set_process(false)	
	$Tween.interpolate_property($YSort/player, "global_position", $YSort/player.global_position, $env/miguel_start_pos.global_position ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($YSort/bert_anim, "global_position", $YSort/bert_anim.global_position, $env/bert_first_pos.global_position  ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$YSort/bert_anim.play('walk')
	$YSort/player/AnimatedSprite.play('walk')
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$YSort/bert_anim.play('stand')
	$YSort/player/AnimatedSprite.play('stand')
	$GUI/cl/s.show()
	next_dialog(d, 13)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 14)
	$YSort/aisha_anim.play('walk')
	$Tween.interpolate_property($YSort/aisha_anim, "global_position", $YSort/aisha_anim.global_position, $env/enemy_start_pos.global_position  ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 15)
	$YSort/aisha_anim.play('guard')
	$YSort/player/AnimatedSprite.play('guard')
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 16)
	yield(get_tree().create_timer(1), "timeout")
	$GUI/cl/s.hide()
	$YSort/aisha/AnimatedSprite.flip_h = true
	$YSort/aisha.global_position = $YSort/aisha_anim.global_position
	$YSort/aisha_anim.hide()
	$env/tatami/right.set_deferred('disabled', false)
	$YSort/player.set_process(true)
	$YSort/aisha.status = $YSort/aisha.STATES.WAITING_FOR_PLAYER
	pass

func aisha_defeated():
	$env/tatami/right.set_deferred('disabled', true)
	$YSort/aisha_anim.global_position = $YSort/aisha.global_position
	$YSort/aisha.queue_free()
	$YSort/aisha_anim.show()
	$YSort/player.set_process(false)
	$Tween.interpolate_property($YSort/player, "global_position", $YSort/player.global_position, $env/miguel_start_pos.global_position ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($YSort/aisha_anim, "global_position", $YSort/aisha_anim.global_position, $env/aisha_first_pos.global_position  ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$YSort/aisha_anim.play('walk')
	$YSort/player/AnimatedSprite.play('walk')
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$YSort/aisha_anim.play('stand')
	$YSort/player/AnimatedSprite.play('stand')
	$GUI/cl/s.show()
	next_dialog(d, 17)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 18)
	$YSort/hawk_anim.play('walk')
	$Tween.interpolate_property($YSort/hawk_anim, "global_position", $YSort/hawk_anim.global_position, $env/enemy_start_pos.global_position  ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$bgm.stop()
	$bgm.stream = preload("res://sound/hawk.ogg")
	$bgm.play()
	$Tween.start()
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 15)
	$YSort/hawk_anim.play('guard')
	$YSort/player/AnimatedSprite.play('guard')
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 16)
	yield(get_tree().create_timer(1), "timeout")
	$GUI/cl/s.hide()
	$YSort/hawk/AnimatedSprite.flip_h = true
	$YSort/hawk.global_position = $YSort/hawk_anim.global_position
	$YSort/hawk_anim.hide()
	$env/tatami/right.set_deferred('disabled', false)
	$YSort/player.set_process(true)
	$YSort/hawk.status = $YSort/hawk.STATES.WAITING_FOR_PLAYER
	pass

func hawk_defeated():
	print('HAWK defeated !!')
	print('TODO recharge HP')
	$env/tatami/right.set_deferred('disabled', true)
	$YSort/hawk.global_position = $YSort/hawk.global_position
	$YSort/hawk.queue_free()
	$YSort/hawk_anim.show()
	$YSort/player.set_process(false)
	$Tween.interpolate_property($YSort/player, "global_position", $YSort/player.global_position, $env/miguel_start_pos.global_position ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($YSort/hawk_anim, "global_position", $YSort/hawk_anim.global_position, $env/hawk_final_pos.global_position  ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$YSort/hawk_anim.play('walk')
	$YSort/player/AnimatedSprite.play('walk')
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$YSort/hawk_anim.flip_h=true
	$YSort/hawk_anim.play('stand')
	$YSort/player/AnimatedSprite.play('stand')	
	$bgm.stop()
	$bgm.stream = stage_bg
	$bgm.play()
	$GUI/cl/s.show()
	next_dialog(d, 21)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 22)
	$Tween.interpolate_property($YSort/player, "global_position", $YSort/player.global_position, $env/miguel_start_pos.global_position ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($YSort/johnny, "global_position", $YSort/johnny.global_position, $env/enemy_start_pos.global_position  ,1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$YSort/johnny.flip_h = true
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 23)
	$YSort/johnny.play('guard')
	$YSort/player.flip_to_right()
	$YSort/player/AnimatedSprite.play('guard')
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 24)
	print("TODO drop Johnny boss")
	
	$YSort/enemy_johnny/AnimatedSprite.flip_h = true
	$YSort/enemy_johnny.global_position = $YSort/johnny.global_position
	$YSort/johnny.hide()
	$env/tatami/right.set_deferred('disabled', false)
	$YSort/player.set_process(true)
	$YSort/enemy_johnny.status = $YSort/enemy_johnny.STATES.WAITING_FOR_PLAYER
	
	yield(get_tree().create_timer(4), "timeout")
	$GUI/cl/s.hide()
	$bgm.stream = load("res://sound/stage1.ogg")
	$bgm.play()
	pass

func check_stage_complete():
	pass

func johnny_defeated(): 
	$bgm.stop()
	$bgm.stream = stage_bg
	$bgm.play()
	print('Very Good\nALL OF YOU')
	var d26 = {'psg': 'Johnny', 'd': 'ALL OF YOU\nAre you ready\nfor the tournament?'}
	var d27 = {'psg': 'all', 'd': '** YES SENSEI **'}
	var d28 = {'psg': 'Johnny', 'd': 'And YOU\nit is time for you\nto learn the\nCOBRA KAI COMBO'}
	var d29 = {'psg': 'Johnny', 'd': 'Now you know\nhow to\nSWEEP THE LEG !'}
	d.append(d26)
	d.append(d27)
	d.append(d28)
	$GUI/cl/s.show()
	next_dialog(d, 26)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 27)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 28)
	yield(get_tree().create_timer(3), "timeout")
	var final_token_pos = $GUI/player/h_down/c/c/combo2/p.global_position
	var token = Sprite.new()
	token.texture = load("res://asset/GUI/combo/combo.3.png")
	token.centered = false
	$YSort/player.add_child(token)
	$Tween.interpolate_property(token, "global_position", token.global_position, final_token_pos, 3, Tween.TRANS_LINEAR)
	$Tween.interpolate_property(token, "scale", token.scale, Vector2(2,2), 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.interpolate_property(token, "scale", Vector2(2,2), Vector2(1,1), 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 1.5)
	$efx.stream = efx_new_combo
	$Tween.start()
	$efx.play()
	yield($efx, "finished")
	yield($Tween, "tween_all_completed")
	next_dialog(d, 29)
	yield(get_tree().create_timer(3), "timeout")
	$GUI/cl/s.hide()
	play_outro()

