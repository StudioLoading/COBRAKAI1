extends Node2D
#il kick attiva la combo, non deve assolutamente
#il breath non cambia la frequenza del kick, deve assolutamente
#sullo stage2 l\'avevo fatto giusto.
onready var step = 0
onready var d_step_0 = []
onready var d_step_1 = []
onready var d_step_2 = []
onready var d_step_3 = []
onready var d_step_4 = []
onready var i = 0

onready var FLEX_COMPLETED = 10
onready var KICK_COMPLETED = 20
onready var BACKKICK_COMPLETED = 10
onready var BREATH_FLEX_DECREASE = 5
onready var BREATH_KICK_DECREASE = 9

onready var efx_legno_hit = preload("res://sound/effects/train_fantoccio.wav")
onready var efx_legno_boom= preload("res://sound/effects/train_fantoccio_boom.wav")

onready var SCORE_FLEX = 5
onready var SCORE_KICK = 10
onready var SCORE_BACKKICK = 20

onready var STAGE_TIMER = 85

onready var item_scene = preload("res://item.tscn")


enum PLAYER_STATES {PERFORMING, GOING_TO_SENSEI, TALKING, DEAD}
onready var player_state = PLAYER_STATES.GOING_TO_SENSEI


func _ready():
	prepare_dialogs()
#	$bg/step_info.hide()
	$cl/player/f.hide()
	$cl/s.hide()
	init_miguel()
	$cl/player.show()
	$bgm.play()
	$bg/step_info/blinkin_msg.play('sensei')
	$bg/step_info/blinkin_msg2.play('sensei')
	$bg/step_info/h.hide()
	pass # Replace with function body.

func init_miguel():
	$YSort/miguel.connect('player_been_hit', self, 'player_been_hit')
	$YSort/miguel.connect('hit', self, '_on_johnny_hit')
	$YSort/miguel.connect('player_down', self, '_on_player_down')
	$YSort/miguel.connect('on_select', $cl/player, '_on_select')
	$YSort/miguel.connect('update_control_gui', $cl/player, '_on_update_control_gui')
	$cl/player.config($YSort/miguel, STAGE_TIMER, false)
	$cl/player/time.connect('stage_timeout', self, 'on_stage_timeout')
	$cl/player.connect('gameover', self, '_on_gameover')
	$YSort/miguel.global_position = $YSort/miguel_initial_pos.global_position

func player_been_hit(player_hp, player_hp_max):
	if player_hp < 0:
		$cl/player.decrease_up()
		player_state = PLAYER_STATES.DEAD

func _on_gameover():
	#disconnect onplayerdown
	$YSort/miguel.disconnect("player_down", self, "_on_player_down")
	#wait for on player down
	yield($YSort/miguel, "player_down")
	ProjectSettings.set_setting("gameover_msg", 'There\'s no tappin on karate !')
	get_tree().change_scene("res://gameover.tscn")
	return

func _on_player_down():
	if $cl/player/time.stage_time_left <= 0:
		get_tree().reload_current_scene()
		return
	if player_state == PLAYER_STATES.DEAD:
		$bgm.stop()
		var lifes = $cl/player.get_lifes()
#		print('stage2 player going down, new lifes ', lifes)
		$cl/player/h_up/score_life/life/beerxn.text = str("%02d" % int(round(lifes)))
		$YSort/miguel.global_position = $YSort/johnny2/facing_pos.global_position
		$YSort/miguel.reinit()
	#	$YSort/johnny.on_blink()
		init_miguel()
		$cl/player.blink_lifes()

func prepare_dialogs():
	d_step_0.append({'psg': 'johnny', 'd': 'Give me some push ups\non your knuckles!!'})
	d_step_0.append({'psg': 'johnny', 'd': '\nNOW !!'})
	d_step_0.append({'psg': 'miguel', 'd': 'Yes sensei.'})
	d_step_1.append({'psg': 'johnny', 'd': 'STRIKE HARD'})
	d_step_1.append({'psg': 'johnny', 'd': 'go to that wood\nand start kickin'})
	d_step_1.append({'psg': 'miguel', 'd': 'Yes sensei.'})
	d_step_2.append({'psg': 'johnny', 'd': 'GOOD\nshow me\na combo-kick'})
	d_step_2.append({'psg': 'johnny', 'd': 'kick-kick-spinnin kick'})
	d_step_2.append({'psg': 'miguel', 'd': 'But, sensi, I\ndon\'t know how'})
	d_step_2.append({'psg': 'johnny', 'd': '!! QUIET !!'})
	d_step_3.append({'psg': 'johnny', 'd': 'Where are we,\na yoga class?!'})
	d_step_3.append({'psg': 'johnny', 'd': 'More score!!'})
	d_step_3.append({'psg': 'miguel', 'd': 'Yes sensei.'})
	d_step_4.append({'psg': 'johnny', 'd': 'ENOUGH !!'})
	d_step_4.append({'psg': 'johnny', 'd': 'Class \'s dismissed.'})
	d_step_4.append({'psg': 'miguel', 'd': 'Yes sensei.'})

func _on_face_johnny_body_entered(body):
	if body.name == 'miguel' and player_state == PLAYER_STATES.GOING_TO_SENSEI:
		$cl/player/time/stage_timer.paused = true
		$cl/player/time.hide()
		$cl/player.hide()
		$YSort/miguel.set_process(false)
		$YSort/miguel/AnimatedSprite.animation = 'stand'
		$YSort/miguel/AnimatedSprite.flip_h = true
		show_diag()
#		$Tween.start()
	pass # Replace with function body.

func show_diag():
	$cl/s.show()
	var face
	var speak
	var animation = 'default'
	var dialog
	match step:
		0:
			dialog = d_step_0
			$bg/step_info/blinkin_msg.play('training')
			$bg/step_info/blinkin_msg2.play('training')
		1:
			dialog = d_step_1
			$YSort/kick/kick.play('default')
			$bg/step_info/blinkin_msg.play('training')
			$bg/step_info/blinkin_msg2.play('training')
		2:
			dialog = d_step_2
			$YSort/kick/kick.play('default')
			$bg/step_info/blinkin_msg.play('training')
			$bg/step_info/blinkin_msg2.play('training')
		3:
			dialog = d_step_3
			$YSort/kick/kick.play('default')
			$bg/step_info/blinkin_msg.play('training')
			$bg/step_info/blinkin_msg2.play('training')
		4:
			dialog = d_step_4
	i=0
	while i < dialog.size():
		match dialog[i]['psg']:
			'johnny':
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
			'miguel':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
		$cl/s/m/hb/ccf/face.texture = face
		$cl/s/m/hb/ccf/face/speak.frames = speak
		$cl/s/m/hb/ccf/face/speak.animation = animation
		$cl/s/m/hb/ccf/face/speak.play()
		$cl/s/m/hb/cct/text.text = dialog[i]['d']
		i += 1
		yield(get_tree().create_timer(2), "timeout")
	$cl/s/m/hb/cct/text.text = ''
	$cl/s.hide()
	$YSort/miguel/AnimatedSprite.animation = 'stand'
	$YSort/miguel/AnimatedSprite.play()
	$YSort/miguel/AnimatedSprite.flip_h = false
	$YSort/miguel.set_process(true)
	$blink.paused = false
	$blink.start()
	$cl/player/time/stage_timer.paused = false
	$cl/player/time.show()
	$cl/player.show()
	toggle_player_state()
	if step == 4:
		play_outro()
	pass # Replace with function body.

func _on_flex_body_entered(body):
	if body.name == 'miguel':
		$blink.paused=true
		$YSort/flex/flex.show()
		$YSort/miguel.set_process(false)
		$bg/step_info.show()
		$bg/step_info/h/vi/h/n.text = '00'
		$YSort/flex/c.set_deferred("disabled", true)
		$YSort/miguel/AnimatedSprite.flip_h = false
		$YSort/miguel/AnimatedSprite.animation = 'flex'
		$YSort/miguel/AnimatedSprite.frame = 3
		$YSort/miguel/AnimatedSprite.play()
		$YSort/miguel/AnimatedSprite.stop()
		$YSort/miguel.global_position = $YSort/flex/pos.global_position
		$cl/player/f.show()
		$cl/player/f/breath.value = $cl/player/f/breath.max_value
		$bg/step_info/h/vi/h/ntot.text = str(FLEX_COMPLETED)
		$breath_decrease.start()
		$YSort/miguel.on_train = true
		$YSort/miguel.step_train = 'flex'
		$YSort/miguel.connect("flex", self, 'on_miguel_flex')
		$YSort/miguel.connect("flex_completed", self, 'on_miguel_train_completed')
		toggle_camera()
		$YSort/miguel.set_process(true)
	pass # Replace with function body.

func on_miguel_flex():
	$cl/player/f/breath.value -= BREATH_FLEX_DECREASE
	var current_frame = $YSort/miguel/AnimatedSprite.frame
	var next_frame = current_frame + 1
	$YSort/miguel/AnimatedSprite.frame = next_frame % 5
	$cl/player.add_score(SCORE_FLEX)
	
func on_miguel_kick():
	print('stage3 on miguel kick signal')
	$cl/player/f/breath.value -= BREATH_KICK_DECREASE
	$efx.stream = efx_legno_hit
	$efx.play()
	match step:
		1:
			$cl/player.add_score(SCORE_KICK)
			var j = int($bg/step_info/h/vi/h/n.text)
			j += 1
			$bg/step_info/h/vi/h/n.text = str(j)
			if j == KICK_COMPLETED:
				on_miguel_train_completed()
		2,3:
			$YSort/fantoccio2/fantoccio2.frame = 0
			$YSort/fantoccio2/fantoccio2.play('hit')

func on_miguel_rwheelkick():
	on_miguel_kick()
	$cl/player.add_score(SCORE_BACKKICK)
	$efx.stream = efx_legno_boom
	$efx.play()
	var j = int($bg/step_info/h/vi/h/n.text)
	j += 1
	$bg/step_info/h/vi/h/n.text = str(j)
	if j == BACKKICK_COMPLETED:
		on_miguel_train_completed()
	pass

func on_miguel_train_completed():
#	print('train step ', step)
	var t = int($bg/step_info/h/vi/h/n.text)
	t += 1
	$bg/step_info/h/vi/h/n.text = str(t)
	var focus = 0
	match step:
		0:
			focus = FLEX_COMPLETED
			
		1:
			focus = KICK_COMPLETED
			spawn_item_time()
			$YSort/kick/kick.play('broken')
		2:
			focus = BACKKICK_COMPLETED
			spawn_item_time()
			$YSort/kick/kick.play('broken')
		3:
			focus = BACKKICK_COMPLETED
			$YSort/kick/kick.play('broken')
#	print('flex completed ', t, '/', focus) 
	if t >= focus:
		toggle_player_state()
		$cl/player/f.hide()
		$efx.stream = load("res://sound/effects/life_picked.ogg")
		$efx.play()
		$breath_decrease.paused = true
		$breath_decrease.stop()
		$bg/step_info.hide()
#		$YSort/flex/c.set_deferred("disabled", true)
		$YSort/miguel/AnimatedSprite.animation = 'stand'
		$YSort/miguel/AnimatedSprite.stop()
		$cl/player/f.hide()
		$YSort/miguel.on_train = false
		match step:
			0:
				$YSort/miguel.global_position.x -= 10
				$YSort/miguel.disconnect("flex", self, 'on_miguel_flex')
				$YSort/miguel.disconnect("flex_completed", self, 'on_miguel_train_completed')
			1: 
				$YSort/miguel.disconnect("jab", self, 'on_miguel_kick')
				$YSort/miguel.disconnect("KICK_COMPLETED", self, 'on_miguel_train_completed')
		step += 1
		toggle_camera()
		$YSort/miguel.set_process(true)

func _on_breath_decrease_timeout():
	var i = 0
	if $cl/player/f/breath.value > 0 and $cl/player/f/breath.value < $cl/player/f/breath.max_value:
		i = 1
		$YSort/miguel/timer_input_freq.wait_time = (1/$cl/player/f/breath.value)*10
#		print('new wait time: ', $YSort/miguel/timer_input_freq.wait_time)
	$cl/player/f.update_bar(i)
	pass # Replace with function body.

func _on_blink_timeout():
	match step:
		0:
			if $YSort/flex/flex.visible:
				$YSort/flex/flex.hide()
			else:
				$YSort/flex/flex.show()
		1:
			if $YSort/kick/kick.visible:
				$YSort/kick/kick.hide()
			else:
				$YSort/kick/kick.show()
		2,3:
			if $YSort/fantoccio2/fantoccio2.visible:
				$YSort/fantoccio2/fantoccio2.hide()
			else:
				$YSort/fantoccio2/fantoccio2.show()
	pass # Replace with function body.

func _on_fantoccio2_body_entered(body):
	match step:
		2,3:
			if body.is_in_group('player') and player_state == PLAYER_STATES.PERFORMING:
				$blink.paused=true
				$YSort/fantoccio/fantoccio.show()
				$YSort/fantoccio2/fantoccio2.show()
				$YSort/miguel.set_process(false)
				$bg/step_info/h/vi/i.text = 'COMBO'
				$bg/step_info/h/vi/h/n.text = '00'
				$bg/step_info/h/vi/h/ntot.text = str(BACKKICK_COMPLETED)
				$bg/step_info.show()
				$YSort/flex/c.set_deferred("disabled", true)
				$YSort/miguel/AnimatedSprite.flip_h= false
				$YSort/miguel/AnimatedSprite.animation = 'guard'
				$YSort/miguel/AnimatedSprite.play()
				$YSort/miguel.global_position = $YSort/fantoccio2/fantoccio2/pos.global_position
				$cl/player/f.show()
				$cl/player/f/breath.value = $cl/player/f/breath.max_value
				$breath_decrease.paused = false
				$breath_decrease.start()
				$YSort/miguel.on_train = true
				$YSort/miguel.step_train = 'backkicks'
				$YSort/miguel.connect("backkick", self, 'on_miguel_rwheelkick')
				$YSort/miguel.connect("kick", self, 'on_miguel_kick')
				toggle_camera()
				$YSort/miguel.set_process(true)
	pass # Replace with function body.

func play_outro():
	$bgm.stop()
	$cl/player.hide()
	$cl/player/time/stage_timer.paused = true
	$cl/player/time.hide()
	ProjectSettings.set_setting("stage", 3)
	ProjectSettings.set_setting("life", $YSort/miguel.HP)
	ProjectSettings.set_setting("time", int($cl/player/time/nn.text))
	ProjectSettings.set_setting("score", $cl/player.get_score())
	$YSort/miguel.set_process(false)
	var stage_complete_scene = load("res://stage_complete.tscn")
	var stage_complete_instance = stage_complete_scene.instance()
	$YSort/miguel.add_child(stage_complete_instance)
	pass

func spawn_item_time():
	var item = item_scene.instance()
	item.config($YSort/miguel, item.TYPES.TIME)
	item.connect('picked_up', $cl/player, 'item_picked_up')
	$efx.stream = load("res://sound/effects/item_spawner_trigger.ogg")
	$efx.play()
	$YSort/spawn_item_time.add_child(item)

func _on_kick_body_entered(body):
	print('_on_kick_body_entered mi aspetto step = 1 --> ', step)
	match step:
		1:
			if body.is_in_group('player'):
				$blink.paused=true
				$YSort/kick/kick.show()
				$YSort/miguel.set_process(false)
				$bg/step_info/h/vi/i.text = 'KICKS'
				$bg/step_info/h/vi/h/n.text = '00'
				$bg/step_info/h/vi/h/ntot.text = str(KICK_COMPLETED)
				$bg/step_info.show()
				$YSort/flex/c.set_deferred("disabled", true)
				$YSort/miguel/AnimatedSprite.flip_h= false
				$YSort/miguel/AnimatedSprite.animation = 'guard'
				$YSort/miguel/AnimatedSprite.play()
				$YSort/miguel.global_position = $YSort/kick/kick/pos.global_position
				$cl/player/f.reset_bar()
				$cl/player/f.show()
				$breath_decrease.paused = false
				$breath_decrease.start()
				$YSort/miguel.on_train = true
				print('set stepTrain to kicks')
				$YSort/miguel.step_train = 'kicks'
				$YSort/miguel.connect("kick", self, 'on_miguel_kick')
				toggle_camera()
				$YSort/miguel.set_process(true)
	pass # Replace with function body.

func toggle_player_state():
	print('current player state ', player_state)
	if player_state == PLAYER_STATES.PERFORMING:
		player_state = PLAYER_STATES.GOING_TO_SENSEI
	elif player_state == PLAYER_STATES.GOING_TO_SENSEI:
		player_state = PLAYER_STATES.PERFORMING

func toggle_camera():
	if $camera_train.current:
		$YSort/miguel/Camera2D.current = true
		$camera_train.current = false
		$bg/step_info/h.hide()
		$bg/step_info/blinkin_msg.show()
		$bg/step_info/blinkin_msg.play('sensei')
		$bg/step_info/blinkin_msg2.show()
		$bg/step_info/blinkin_msg2.play('sensei')
	else:
		$camera_train.current = true
		$YSort/miguel/Camera2D.current = false
		$bg/step_info/h.show()
		$bg/step_info/blinkin_msg.hide()
		$bg/step_info/blinkin_msg2.hide()
