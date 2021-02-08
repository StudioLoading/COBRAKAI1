extends Node2D

var step = 0
var d_step_0
var d_step_1
var d_step_2
var d_step_3
var d_step_4
var i

onready var FLEX_COMPLETED = 10
onready var JAB_COMPLETED = 20
onready var RAWS_COMPLETED = 10
onready var BREATH_FLEX_DECREASE = 5
onready var BREATH_JAB_DECREASE = 7
onready var SCORE_FLEX = 5
onready var SCORE_JAB = 10
onready var SCORE_RAW = 20

onready var STAGE_NUMBER = 2
onready var STAGE_TIMER  = 90

onready var efx_fantoccio_hit = preload("res://sound/effects/train_fantoccio.wav")
onready var efx_fantoccio_boom = preload("res://sound/effects/train_fantoccio_boom.wav")
onready var pause_efx = preload('res://sound/effects/pause.ogg')

onready var item_scene = preload("res://item.tscn")

enum PLAYER_STATES {PERFORMING, GOING_TO_SENSEI, TALKING, DEAD}
onready var player_state = PLAYER_STATES.GOING_TO_SENSEI

onready var NO_TIME_STAGE = false

func _ready():
	prepare_dialogs()
	$GUI/cl/s.hide()
	$GUI/player/f.hide()
	init_miguel()
	$GUI/player.show()
	$bgm.play()
	$bg/step_info/blinkin_msg.play('sensei')
	$bg/step_info/blinkin_msg2.play('sensei')
	$bg/step_info/h.hide()
	pass # Replace with function body.

func init_miguel():
	$YSort/miguel.connect('player_been_hit', self, 'player_been_hit')
	$YSort/miguel.connect('hit', self, '_on_johnny_hit')
	$YSort/miguel.connect('player_down', self, '_on_player_down')
	$YSort/miguel.connect('update_control_gui', $GUI/player, '_on_update_control_gui')
	$YSort/miguel.connect('on_select', $GUI/player, '_on_select')
	$GUI/player.connect('gameover', self, '_on_gameover')
	$GUI/player.config($YSort/miguel, STAGE_TIMER, NO_TIME_STAGE)
	for pausable in get_tree().get_nodes_in_group('pausable'):
		$YSort/miguel.connect('on_pause_resume', pausable, 'pause_resume')

func _on_miguel_hit(action, effect_stream):
	get_tree().call_group("group_enemies", 'hit', action, $YSort/johnny.global_position, $YSort/johnny/AnimatedSprite.flip_h, effect_stream)
	get_tree().call_group("group_spawners", 'hit', action)
	pass # Replace with function body.

func player_been_hit(player_hp, player_hp_max):
	if player_hp < 0:
		$GUI/player.decrease_up()
		player_state = PLAYER_STATES.DEAD

func _on_player_down():
	if player_state == PLAYER_STATES.DEAD:
		$bgm.stop()
		var lifes = $GUI/player.get_lifes()
#		print('stage2 player going down, new lifes ', lifes)
		if $GUI/player/time.stage_time_left <= 0:
			get_tree().reload_current_scene()
			return
		$GUI/player/h_up/score_life/life/beerxn.text = str("%02d" % int(round(lifes)))
		$YSort/miguel.global_position = $YSort/johnny2/facing_pos.global_position
		$YSort/miguel.reinit()
	#	$YSort/johnny.on_blink()
		init_miguel()
		$GUI/player.blink_lifes()

func _on_gameover():
	#disconnect onplayerdown
	$YSort/miguel.disconnect("player_down", self, "_on_player_down")
	#wait for on player down
	yield($YSort/miguel, "player_down")
	ProjectSettings.set_setting("gameover_msg", 'There\'s no tappin on karate !')
	get_tree().change_scene("res://gameover.tscn")
	return

func on_stage_timeout():
	print('timeout!')
	if step == 4:
		print('STAGE COMPLETE! even if time is left!')
		$YSort/miguel.set_process(false)
		$YSort/miguel/AnimatedSprite.animation = 'walk'
		$tween_timeout.interpolate_property($YSort/miguel, "global_position",  $YSort/miguel.global_position, Vector2($YSort/johnny2/face_johnny/c.global_position.x, $YSort/johnny2/face_johnny/c.global_position.y-10), 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$tween_timeout.start()
#		emit_signal('play_outro')
	else:
		print('ricomincia livello')
		$YSort/miguel.on_stage_timeout()

func prepare_dialogs():
	i = 0
	d_step_0 = []
	d_step_1 = []
	d_step_2 = []
	d_step_3 = []
	d_step_4 = []
	d_step_0.append({'psg': 'johnny', 'd': 'Lesson one ...'})
	d_step_0.append({'psg': 'johnny_jab', 'd': '*punch*'})
	d_step_0.append({'psg': 'johnny', 'd': 'STRIKE FIRST!'})
	d_step_0.append({'psg': 'johnny', 'd': 'Give me some push ups\non your knuckles!!'})
	d_step_0.append({'psg': 'johnny', 'd': 'NOW !!'})
	d_step_0.append({'psg': 'miguel', 'd': 'Yes sensei.'})
	
	d_step_1.append({'psg': 'johnny', 'd': 'Lesson two ...'})
	d_step_1.append({'psg': 'johnny', 'd': 'STRIKE HARD'})
	d_step_1.append({'psg': 'johnny', 'd': 'go to that son\nof a bitch and use\nyour jab punch'})
	d_step_1.append({'psg': 'miguel', 'd': 'Yes sensei.'})
	d_step_2.append({'psg': 'johnny', 'd': 'Go down there and\nshow me'})

	d_step_2.append({'psg': 'johnny', 'd': 'a combo-punch like \njab-jab-straight'})
	d_step_2.append({'psg': 'johnny', 'd': 'care about buttons\npressure timing!'})
	d_step_2.append({'psg': 'johnny', 'd': 'and remember\nthe less is the breath\nthe slow you will act!'})
	d_step_2.append({'psg': 'johnny', 'd': 'care about buttons\npressure timing!'})
	d_step_2.append({'psg': 'johnny', 'd': 'Now go.'})
	d_step_2.append({'psg': 'miguel', 'd': 'Yes sensei.'})
	
	d_step_3.append({'psg': 'johnny', 'd': 'Where are we,\na yoga class?!'})
	d_step_3.append({'psg': 'johnny', 'd': 'More score!!'})
	d_step_3.append({'psg': 'miguel', 'd': 'Yes sensei.'})
	
	d_step_4.append({'psg': 'johnny', 'd': 'ENOUGH !!'})
	d_step_4.append({'psg': 'johnny', 'd': 'Class \'s dismissed.'})
	d_step_4.append({'psg': 'miguel', 'd': 'Yes sensei.'})
	d_step_4.append({'psg': 'johnny', 'd': 'You know you\ndon\'t have to'})
	d_step_4.append({'psg': 'johnny', 'd': 'call me sensei everytime'})
	d_step_4.append({'psg': 'miguel', 'd': 'Yes sensei.'})
	d_step_4.append({'psg': 'miguel', 'd': 'I mean... bye.'})

func toggle_player_state():
	print('current player state ', player_state)
	if player_state == PLAYER_STATES.PERFORMING:
		player_state = PLAYER_STATES.GOING_TO_SENSEI
	elif player_state == PLAYER_STATES.GOING_TO_SENSEI:
		player_state = PLAYER_STATES.TALKING
	elif player_state == PLAYER_STATES.TALKING:
		player_state = PLAYER_STATES.PERFORMING
	match player_state:
		PLAYER_STATES.PERFORMING:
			pass
		PLAYER_STATES.GOING_TO_SENSEI:
			$GUI/player/f.hide()
			$efx.stream = load("res://sound/effects/life_picked.ogg")
			$efx.play()
			$breath_increase.paused = true
			$breath_increase.stop()
	#		$YSort/flex/c.set_deferred("disabled", true)
			$YSort/miguel/AnimatedSprite.animation = 'stand'
			$YSort/miguel/AnimatedSprite.stop()
			$GUI/player/f.hide()
			$YSort/miguel.on_train = false
			match step:
				0:
					$YSort/miguel.global_position.x -= 10
					$YSort/miguel.disconnect("flex", self, 'on_miguel_flex')
					$YSort/miguel.disconnect("flex_completed", self, 'on_miguel_train_completed')
				1: 
					$YSort/miguel.disconnect("jab", self, 'on_miguel_jab')
					$YSort/miguel.disconnect("jab_completed", self, 'on_miguel_train_completed')
			step += 1
			$YSort/miguel.set_process(true)

func _on_face_johnny_body_entered(body):
	if body.is_in_group("player") and !body.playing_ko and player_state == PLAYER_STATES.GOING_TO_SENSEI:
		toggle_player_state()
#		$GUI/player/time/stage_timer.paused = true
#		$GUI/player/time.hide()
#		$GUI/player.hide()
		$YSort/miguel.set_process(false)
		$YSort/miguel/AnimatedSprite.animation = 'stand'
		$YSort/miguel/AnimatedSprite.flip_h = true
		$GUI/cl/s.show()
		show_diag()
	pass # Replace with function body.

func show_diag():
	print('stage2:_on_Tween_tween_all_completed dialogs start showing')
	var face
	var speak
	var animation = 'default'
	$GUI/cl/s.show()
	var dialog
	$YSort/miguel.pause_resume(false)
	match step:
		0:
			dialog = d_step_0
			$bg/step_info/blinkin_msg.play('training')
			$bg/step_info/blinkin_msg2.play('training')
		1:
			dialog = d_step_1
			$bg/step_info/blinkin_msg.play('training')
			$bg/step_info/blinkin_msg2.play('training')
		2:
			dialog = d_step_2
			$bg/step_info/blinkin_msg.play('training')
			$bg/step_info/blinkin_msg2.play('training')
		3:
			dialog = d_step_3
			$bg/step_info/blinkin_msg.play('training')
			$bg/step_info/blinkin_msg2.play('training')
		4:
			dialog = d_step_4
	$YSort/miguel.state = $YSort/miguel.STATES.TALKING
	while i < dialog.size():
		match dialog[i]['psg']:
			'johnny':
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
			'miguel':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
		if dialog[i]['psg'] == 'johnny_jab':
			$YSort/johnny2.animation = 'jab'
			$YSort/johnny2.play()
			$YSort/miguel/AnimatedSprite.animation = 'dead'
			$YSort/miguel/AnimatedSprite.play()
			yield($YSort/johnny2, "animation_finished")
			$YSort/johnny2.animation = 'guard'
			$YSort/johnny2.play()
		$GUI/cl/s/m/hb/ccf/face.texture = face
		$GUI/cl/s/m/hb/ccf/face/speak.frames = speak
		$GUI/cl/s/m/hb/ccf/face/speak.animation = animation
		$GUI/cl/s/m/hb/ccf/face/speak.play()
		$GUI/cl/s/m/hb/cct/text.text = dialog[i]['d']
		var wait_diag = int(dialog[i]['d'].length() / 10)
		i += 1
		yield(get_tree().create_timer(wait_diag), "timeout")
	print('stage2:_on_Tween_tween_all_completed dialogs all showed')
	i = 0
	$GUI/cl/s/m/hb/cct/text.text = ''
	$YSort/miguel/AnimatedSprite.animation = 'stand'
	$YSort/miguel/AnimatedSprite.play()
	$YSort/miguel/AnimatedSprite.flip_h = false
	$YSort/miguel.set_process(true)
	$GUI/cl/s.hide()
	$blink.paused = false
	$blink.start()
#	$GUI/player/time/stage_time-r.paused = false
#	$GUI/player/time.show()
	$GUI/player.show()
	$YSort/miguel.state = null
	$YSort/miguel.pause_resume(false)
	if step == 4:
		play_outro()
	else:
		toggle_player_state()
	pass # Replace with function body.

func _on_flex_body_entered(body):
	if body.name == 'miguel' and player_state == PLAYER_STATES.PERFORMING:
		$blink.paused=true
		$YSort/flex/flex.show()
		$YSort/miguel.set_process(false)
		$bg/step_info/h/vi/h/n.text = '00'
		$YSort/flex/c.set_deferred("disabled", true)
		$YSort/miguel/AnimatedSprite.flip_h = false
		$YSort/miguel/AnimatedSprite.animation = 'flex'
		$YSort/miguel/AnimatedSprite.frame = 3
		$YSort/miguel/AnimatedSprite.play()
		$YSort/miguel/AnimatedSprite.stop()
		$YSort/miguel.global_position = $YSort/flex/pos.global_position
		$GUI/player/f.show()
		$GUI/player/f/breath.value = $GUI/player/f/breath.max_value
		$bg/step_info/h/vi/h/ntot.text = str(FLEX_COMPLETED)
		$breath_increase.start()
		$YSort/miguel.on_train = true
		$YSort/miguel.step_train = 'flex'
		$YSort/miguel.connect("flex", self, 'on_miguel_flex')
		$YSort/miguel.connect("flex_completed", self, 'on_miguel_train_completed')
		$YSort/miguel.set_process(true)
		toggle_camera()
	pass # Replace with function body.

func on_miguel_flex():
	$GUI/player/f/breath.value -= BREATH_FLEX_DECREASE
	var current_frame = $YSort/miguel/AnimatedSprite.frame
	var next_frame = current_frame + 1
	$YSort/miguel/AnimatedSprite.frame = next_frame % 5
	$GUI/player.add_score(SCORE_FLEX)
	
func on_miguel_jab():
	print('stage2 on miguel jab signal')
	$GUI/player/f/breath.value -= BREATH_JAB_DECREASE
	match step:
		1:
#			$YSort/fantoccio/fantoccio.animation = 'hit'
#			print('stage2 playing fantoccio hit animation')
			$YSort/fantoccio/fantoccio.frame = 0
			$YSort/fantoccio/fantoccio.play('hit')
			$GUI/player.add_score(SCORE_JAB)
			var j = int($bg/step_info/h/vi/h/n.text)
			j += 1
			$bg/step_info/h/vi/h/n.text = str(j)
			if j == JAB_COMPLETED:
				on_miguel_train_completed()
		2,3:
			$YSort/fantoccio2/fantoccio2.frame = 0
			$YSort/fantoccio2/fantoccio2.play('hit')
	$efx.stream = efx_fantoccio_hit
	$efx.play()

func  on_miguel_raw():
	on_miguel_jab()
	$GUI/player.add_score(SCORE_RAW)
	$efx.stream = efx_fantoccio_boom
	$efx.play()
	var j = int($bg/step_info/h/vi/h/n.text)
	j += 1
	$bg/step_info/h/vi/h/n.text = str(j)
	if j == RAWS_COMPLETED:
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
			focus = JAB_COMPLETED
			spawn_item_time()
		2:
			focus = RAWS_COMPLETED
			spawn_item_time()
		3:
			focus = RAWS_COMPLETED
	print('stage2:on_miguel_train_completed completed ', t, '/', focus) 
	if t >= focus:
		toggle_camera()
		toggle_player_state()

func _on_breath_increase_timeout():
	$YSort/miguel/timer_input_freq.wait_time = (1/$GUI/player/f.breath_plusone())*10

func _on_fantoccio_body_entered(body):
	match step:
		1:
			if body.is_in_group('player') and player_state == PLAYER_STATES.PERFORMING:
				$blink.paused=true
				$YSort/fantoccio/fantoccio.show()
				$YSort/miguel.set_process(false)
				$bg/step_info/h/vi/i.text = 'JABS'
				$bg/step_info/h/vi/h/n.text = '00'
				$bg/step_info/h/vi/h/ntot.text = str(JAB_COMPLETED)
				$YSort/flex/c.set_deferred("disabled", true)
				$YSort/miguel/AnimatedSprite.flip_h= false
				$YSort/miguel/AnimatedSprite.animation = 'guard'
				$YSort/miguel/AnimatedSprite.play()
				$YSort/miguel.global_position = $YSort/fantoccio/fantoccio/pos.global_position
				$GUI/player/f.show()
				$GUI/player/f/breath.value = $GUI/player/f/breath.max_value
				$breath_increase.paused = false
				$breath_increase.start()
				$YSort/miguel.on_train = true
				$YSort/miguel.step_train = 'jabs'
				$YSort/miguel.last_three_inputs.clear()
				$YSort/miguel.connect("jab", self, 'on_miguel_jab')
				$YSort/miguel.set_process(true)
				toggle_camera()
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
				$bg/step_info/h/vi/h/ntot.text = str(RAWS_COMPLETED)
				$YSort/flex/c.set_deferred("disabled", true)
				$YSort/miguel/AnimatedSprite.flip_h= false
				$YSort/miguel/AnimatedSprite.animation = 'guard'
				$YSort/miguel/AnimatedSprite.play()
				$YSort/miguel.global_position = $YSort/fantoccio2/fantoccio2/pos.global_position
				$GUI/player/f.show()
				$GUI/player/f/breath.value = $GUI/player/f/breath.max_value
				$breath_increase.paused = false
				$breath_increase.start()
				$YSort/miguel.on_train = true
				$YSort/miguel.step_train = 'raws'
				$YSort/miguel.connect("raw", self, 'on_miguel_raw')
				$YSort/miguel.connect("jab", self, 'on_miguel_jab')
				$YSort/miguel.last_three_inputs.clear()
				$YSort/miguel.set_process(true)
				toggle_camera()
	pass # Replace with function body.

func _on_blink_timeout():
	match step:
		0:
			if $YSort/flex/flex.visible:
				$YSort/flex/flex.hide()
			else:
				$YSort/flex/flex.show()
		1:
			if $YSort/fantoccio/fantoccio.visible:
				$YSort/fantoccio/fantoccio.hide()
			else:
				$YSort/fantoccio/fantoccio.show()
		2,3:
			if $YSort/fantoccio2/fantoccio2.visible:
				$YSort/fantoccio2/fantoccio2.hide()
			else:
				$YSort/fantoccio2/fantoccio2.show()
	pass # Replace with function body.
	
func play_outro():
	
	$GUI/player.hide()
	$GUI/cl/s.hide()
	$bgm.stop()
	$efx.pause_mode = true
	var life = $YSort/miguel.HP
	var time = $GUI/player.get_time()
	var score = $GUI/player.get_score()
	ProjectSettings.set_setting("stage", STAGE_NUMBER)
	ProjectSettings.set_setting("life", life)
	ProjectSettings.set_setting("time", time)
	ProjectSettings.set_setting("score", score)
	#get_tree().change_scene("res://stage_complete.tscn")
	$YSort/miguel.set_process(false)
	var stage_complete_scene = load("res://stage_complete.tscn")
	var stage_complete_instance = stage_complete_scene.instance()
	$YSort/miguel.add_child(stage_complete_instance)
	pass

func spawn_item_combo():
	yield(get_tree().create_timer(1), "timeout")
	var item = item_scene.instance()
	item.config($YSort/miguel, item.TYPES.COMBO)
	item.connect('picked_up', $GUI/player, 'item_picked_up')
	$efx.stream = load("res://sound/effects/item_spawner_trigger.ogg")
	$efx.play()
	item.position = $YSort/spawn_item_combo.position
	add_child(item)

func spawn_item_time():
	yield(get_tree().create_timer(1), "timeout")
	var item = item_scene.instance()
	item.config($YSort/miguel, item.TYPES.TIME)
	item.connect('picked_up', $GUI/player, 'item_picked_up')
	$efx.stream = load("res://sound/effects/item_spawner_trigger.ogg")
	$efx.play()
	item.position = $YSort/spawn_item_time.position
	add_child(item)

func toggle_camera():
	print('toggle camera')
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


func pause_resume(paused, with_paused_menu):
#	print('pausing bgm and efx ', paused)
	if paused and with_paused_menu:
		$bgm.stream_paused = paused
		$efx.stream = pause_efx
		$efx.play()
	else:
		$bgm.stream_paused = false
