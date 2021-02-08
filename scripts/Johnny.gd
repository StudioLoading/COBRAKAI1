extends KinematicBody2D

onready var sspeed = 2.5
onready var attacks = ['jab', 'raw', 'uppercut', 'kick', 'backfist', 'backkick', 'cranekick', 'sweep', 'kata']
onready var breaths = [{'attack': 'jab', 'breath': 2}, {'attack': 'raw', 'breath': 8},
{'attack': 'uppercut', 'breath': 12}, {'attack': 'kick', 'breath': 4}, {'attack': 'backkick', 'breath': 6},
{'attack': 'backfist', 'breath': 12}, {'attack': 'cranekick', 'breath': 8}, {'attack': 'sweep', 'breath': 8},
 {'attack': 'kata', 'breath': 16}]
var performing_action = false

var pos_move_jab
var pos_move_uppercut
var pos_move_cranekick
var pos_move_sweep
var pos_move_kata
var shape_move_jab_a
var shape_move_jab_b
var shape_move_raw_a
var shape_move_raw_b
var shape_move_backfist_a
var shape_move_backfist_b
var shape_move_kick_a
var shape_move_kick_b

signal hit
signal player_been_hit
signal player_down
signal on_select
signal act
signal update_btn_combo

var is_hit

onready var HP = 50
onready var HP_MAX = 50
onready var TIMER_DASH = 0.4

var playing_ko
onready var KO_X = 50
onready var KO_Y = 30
var ko_y_count
var ko_y_max
var going_back_direction
var collided_going_back

onready var DOJO = 'cobra'
onready var PSGNAME='Johnny'
onready var TIMER_INPUT_FREQ = 0.1

onready var on_train = false

var buffer_velocity
var buffering

var last_four_inputs
var last_three_inputs
onready var INPUT_FREQ = 0.3

signal camera_shake_requested

enum STATES {TALKING, DASHING, GOING}
onready var state = null

onready var dash = false
signal update_control_gui

onready var efx_dash = preload("res://sound/effects/dash.ogg")
onready var efx_step = preload("res://sound/effects/step.ogg")

signal on_pause_resume

signal backfist
onready var paused = false

onready var effectCombo1 = preload("res://sound/effects/hit.combo.1.ogg")
onready var effectCombo2 = preload("res://sound/effects/hit.combo.2.ogg")
onready var effectSwish = preload("res://sound/effects/swish.ogg")

onready var combo_base = [['jab', 'jab', 'jab'], ['kick', 'kick', 'kick']]
onready var combo_base_action = ['raw', 'backkick']

onready var combo = [['jab', 'jab', 'jab', 'jab'], ['kick', 'down', 'up', 'kick'],
					['up', 'down', 'kick', 'kick'], ['jab', 'kick', 'kick', 'jab']]
onready var combo_action = ['uppercut', 'cranekick', 'sweep', 'kata']#, 'tournament']
onready var combo_unlocked
onready var combo_completed = false
onready var combo_selected = 0

#onready var TIMER_COMBO_TIMEOUT = 1

func _ready():
	reinit()
	on_blink()
	$effect_swish.stream = effectSwish
	$Camera2D.enabled = true
	$timer_dash.wait_time = TIMER_DASH
#	$timer_combo.wait_time = TIMER_COMBO_TIMEOUT
	$AnimatedSprite/sgommata.hide()
	$timer_input_freq.wait_time = TIMER_INPUT_FREQ
	pass # Replace with function body.

func reinit():
	collided_going_back = false
	going_back_direction = Vector2.ZERO
	$AnimatedSprite.playing=true
	pos_move_jab = $AnimatedSprite/jab.position
	pos_move_uppercut = $AnimatedSprite/uppercut.position
	pos_move_cranekick = $AnimatedSprite/cranekick.position
	pos_move_sweep = $AnimatedSprite/sweep.position
	shape_move_jab_a = $AnimatedSprite/jab/jab.shape.a
	shape_move_jab_b = $AnimatedSprite/jab/jab.shape.b
	shape_move_raw_a = $AnimatedSprite/raw/raw.shape.a
	shape_move_raw_b = $AnimatedSprite/raw/raw.shape.b
	shape_move_backfist_a = $AnimatedSprite/backfist/backfist.shape.a
	shape_move_backfist_b = $AnimatedSprite/backfist/backfist.shape.b
	shape_move_kick_a = $AnimatedSprite/kick/kick.shape.a
	shape_move_kick_b = $AnimatedSprite/kick/kick.shape.b
	is_hit = false
	playing_ko=false
	ko_y_count = 0
	ko_y_max = KO_Y
	HP = HP_MAX
	$AnimatedSprite.flip_h = false
	$AnimatedSprite/jab.position = pos_move_jab
	$AnimatedSprite/uppercut.position = pos_move_uppercut
	$AnimatedSprite/cranekick.position = pos_move_cranekick
	$AnimatedSprite/sweep.position = pos_move_sweep
	$AnimatedSprite/backfist/backfist.shape.a.x = shape_move_backfist_a.x
	$AnimatedSprite/backfist/backfist.shape.b.x = shape_move_backfist_b.x
	buffer_velocity = Vector2.ZERO
	buffering = false
	last_four_inputs = []
	last_three_inputs = []
#	$timer_input_freq.paused = true
#	$timer_input_freq.wait_time = INPUT_FREQ
	self.paused = false
	set_process(true)
	reload_combo_unlocked()
	
func reload_combo_unlocked():
#	print('JOHNNY reload_combo_unlocked() reloaded combo_unlocked=', combo_unlocked)
	combo_unlocked = ProjectSettings.get_setting('combo_unlocked')
	if combo_unlocked == null: #potremmo essere in test
		combo_unlocked = [true, false, false, false, false]

func store_combo_unlocked():
	ProjectSettings.set_setting('combo_unlocked', self.combo_unlocked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_train:
		return
	if playing_ko:
		if ko_y_count == KO_Y:
			$AnimatedSprite.stop()
			$AnimatedSprite.animation='dead'
			$AnimatedSprite.play()
			var efx_collision_car = load("res://sound/effects/collision_car.wav")
			$effect.stream = efx_collision_car
			$effect.play()
			self.set_process(false)
			return
		else:
#			print('playing johnny ko going_back to :', going_back_direction)
			$AnimatedSprite.animation = 'hit'
			var movement = Vector2.ZERO
	#		print(self.name,' going back x dir: ', going_back_direction)
			movement.x = going_back_direction.x * KO_X
			ko_y_count += 1
			ko_y_max -= 1
			movement.y = ko_y_count- ko_y_max
			self.move_and_slide(movement)
			var collision = get_slide_collision(0)
			if !collided_going_back and collision and collision.collider:
				var c = collision.collider
#				print('johnny collided with ', c.name, ' ', c.get_parent().name)
				if 'car' in c.name:
					collided_going_back = true
#					print('johnny collided while going back!')
					var efx_collision_car = load("res://sound/effects/collision_car.wav")
					$effect.stream = efx_collision_car
					$effect.play()
			return
		pass
	if self.performing_action == true:
		pass
	if self.is_hit == true:
		return
	var velocity = get_move_input()
	if velocity == Vector2.ZERO:
		if $AnimatedSprite.animation != 'guard':
			$AnimatedSprite.play('guard')
	elif !dash:
		if $AnimatedSprite.animation != 'walk':
			$AnimatedSprite.play('walk')
	else: 
#			print('detected dashing')
		if $AnimatedSprite.animation!='dash':
			$AnimatedSprite.play('dash')
		if !$effect.playing:
			$effect.stream = efx_dash
			$effect.play()
	var movement = velocity * delta * 30
	var collision = self.move_and_collide(movement)
	pass

func _input(event):
#	print('Johnny _input()')
	custom_input(event)
	if !on_train:
		get_action_input()

func custom_input(event):
	if event.is_action_pressed("ui_select"):
		emit_signal('on_select')
		last_four_inputs.clear()
		emit_signal('update_btn_combo', 0)
	if Input.is_action_just_pressed("ui_start"):
#		print('custom_input ui_start')
		pause_resume(true)
	var emitted = false
	if Input.is_action_just_released("ui_left"):
		update_control_gui(Vector2.LEFT, false, null, false)
		emitted = true
	if Input.is_action_just_pressed("ui_left"):
		update_control_gui(Vector2.LEFT, true, null, false)
		emitted = true
	if Input.is_action_just_released("ui_right"):
		update_control_gui(Vector2.RIGHT, false, null, false)
		emitted = true
	if Input.is_action_just_pressed("ui_right"):
		update_control_gui(Vector2.RIGHT, true, null, false)
		emitted = true
	if Input.is_action_just_released("ui_up"):
		update_control_gui(Vector2.UP, false, null, false)
		emitted = true
	if Input.is_action_just_pressed("ui_up"):
		update_control_gui(Vector2.UP, true, null, false)
		emitted = true
	if Input.is_action_just_released("ui_down"):
		update_control_gui(Vector2.DOWN, false, null, false)
		emitted = true
	if Input.is_action_just_pressed("ui_down"):
		update_control_gui(Vector2.DOWN, true, null, false)
		emitted = true
	if Input.is_action_just_pressed("ui_punch"):
		update_control_gui(null, false, "ui_punch", true)
		emitted = true
	if Input.is_action_just_released("ui_punch"):
		update_control_gui(null, false, "ui_punch", false)
		emitted = true
	if Input.is_action_just_pressed("ui_kick"):
		update_control_gui(null, false, "ui_kick", true)
		emitted = true
	if Input.is_action_just_released("ui_kick"):
		update_control_gui(null, false, "ui_kick", false)
		emitted = true
	var no_move_is_pressed = Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right")
	if !emitted and no_move_is_pressed:
		update_control_gui(null, false, null, false)

func update_control_gui(move, pressedm, action, presseda):
#	print('Johnny: update_control_gui() ', move, action)
	emit_signal('update_control_gui', move, pressedm, action, presseda)
	pass # Replace with function body.

func get_move_input():
	var velocity = Vector2.ZERO
	if Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_down") || Input.is_action_just_released("ui_up"):
		buffering = false
		return velocity
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_just_pressed("ui_left"):
		flip_to_left()
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		if !$AnimatedSprite.flip_h:
			flip_to_left()
	elif Input.is_action_just_pressed("ui_right"):
		flip_to_right()
	elif Input.is_action_pressed("ui_right"):
		velocity.x += 1
		if $AnimatedSprite.flip_h:
			flip_to_right()
	if velocity != Vector2.ZERO:
		change_state(STATES.GOING)
	if Input.is_action_just_pressed("ui_up"):
		last_four_inputs.push_back('up')
		valuta_per_gui()
		if last_four_inputs.size() >= 4:
			last_four_inputs.remove(0)
	if Input.is_action_just_pressed("ui_down"):
		last_four_inputs.push_back('down')
		valuta_per_gui()
		if last_four_inputs.size() >= 4:
			last_four_inputs.remove(0)
	if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_up"):
#		print('action just pressed')
		if $timer_updown.time_left > 0:
#			print('ricevuta nuova direzione entro intervallo')
			if velocity == buffer_velocity:
#				print('che è uguale alla precedente!!')
				change_state(STATES.DASHING)
				dash = true
				$timer_dash.start()
#				print('velocity raddoppiata: ', velocity)
#				print('questo buffering lo posso usare per un colpo particolare.')
#				tipo giù-giù+jab potrebbe essere un pugno basso
#				tipo giù-giù+kick potrebbe essere una spazzata SweepTheLeg !
			else:
#				print('che è diversa da quella precedente')
				change_state(STATES.GOING)
				dash= false
#				buffer_velocity = velocity
		else:
			$timer_updown.start()
	buffer_velocity = velocity
#	if buffering:
#		return Vector2.ZERO
	if(velocity.length() > 0):
		velocity = velocity.normalized() * sspeed
		if dash:
			velocity *= 3
	return velocity

func flip_to_left():
	$AnimatedSprite.flip_h = true
	$AnimatedSprite/uppercut.position = pos_move_uppercut * -1
	$AnimatedSprite/cranekick.position = pos_move_cranekick * -1
	$AnimatedSprite/sweep.position = pos_move_sweep * -1
	$AnimatedSprite/jab/jab.shape.a = shape_move_jab_a * Vector2(-1,1)
	$AnimatedSprite/jab/jab.shape.b = shape_move_jab_b * Vector2(-1,1)
	$AnimatedSprite/raw/raw.shape.a = shape_move_raw_a * Vector2(-1,1)
	$AnimatedSprite/raw/raw.shape.b = shape_move_raw_b * Vector2(-1,1)
	$AnimatedSprite/backfist/backfist.shape.b.x = shape_move_backfist_a.x
	$AnimatedSprite/backfist/backfist.shape.a.x = shape_move_backfist_b.x
	$AnimatedSprite/backfist/backfist.shape.b.x = shape_move_backfist_a.x
	$AnimatedSprite/kick/kick.shape.a.x = shape_move_kick_b.x
	$AnimatedSprite/kick/kick.shape.b.x = shape_move_kick_a.x
	$AnimatedSprite/backkick/backkick.shape.a.x = shape_move_kick_b.x
	$AnimatedSprite/backkick/backkick.shape.b.x = shape_move_kick_a.x
	$AnimatedSprite/sgommata.global_position = $AnimatedSprite/pos_sgommata_r.global_position
	$AnimatedSprite/sgommata.flip_h = true
	$AnimatedSprite/sgommata.frame = 0
	if buffer_velocity.x > 0:
		$AnimatedSprite/sgommata.show()
		$AnimatedSprite/sgommata.play()
	pass

func flip_to_right():
	$AnimatedSprite.flip_h = false
	$AnimatedSprite/uppercut.position = pos_move_uppercut
	$AnimatedSprite/cranekick.position = pos_move_cranekick
	$AnimatedSprite/sweep.position = pos_move_sweep
	$AnimatedSprite/jab/jab.shape.a.x = shape_move_jab_a.x
	$AnimatedSprite/jab/jab.shape.b.x = shape_move_jab_b.x
	$AnimatedSprite/raw/raw.shape.a.x = shape_move_raw_a.x
	$AnimatedSprite/raw/raw.shape.b.x = shape_move_raw_b.x
	$AnimatedSprite/backfist/backfist.shape.a.x = shape_move_backfist_a.x
	$AnimatedSprite/backfist/backfist.shape.b.x = shape_move_backfist_b.x
	$AnimatedSprite/kick/kick.shape.a.x = shape_move_kick_a.x
	$AnimatedSprite/kick/kick.shape.b.x = shape_move_kick_b.x
	$AnimatedSprite/backkick/backkick.shape.a.x = shape_move_kick_a.x
	$AnimatedSprite/backkick/backkick.shape.b.x = shape_move_kick_b.x
	$AnimatedSprite/sgommata.global_position = $AnimatedSprite/pos_sgommata_l.global_position
	$AnimatedSprite/sgommata.flip_h = false
	$AnimatedSprite/sgommata.frame = 0
	if buffer_velocity.x < 0:
		$AnimatedSprite/sgommata.show()
		$AnimatedSprite/sgommata.play()
	pass

func change_state(newstate):
	self.state = newstate
	match newstate:
		STATES.DASHING:
			if $AnimatedSprite.flip_h:
				$AnimatedSprite/sgommata.global_position = $AnimatedSprite/pos_sgommata_r.global_position
				$AnimatedSprite/sgommata.flip_h = false
			else:				
				$AnimatedSprite/sgommata.global_position = $AnimatedSprite/pos_sgommata_l.global_position
				$AnimatedSprite/sgommata.flip_h = false
			$AnimatedSprite/sgommata.frame = 0
			$AnimatedSprite/sgommata.show()
			$AnimatedSprite/sgommata.play()

func get_action_input():
	if !$timer_no_actions.paused and $timer_no_actions.time_left > 0:
		return ''
	if $AnimatedSprite.animation != 'walk' and $AnimatedSprite.animation != 'guard':
		return ''
	var action = null
	if Input.is_action_pressed("ui_punch") and Input.is_action_just_pressed('ui_kick'):
		action = 'backfist'
	elif Input.is_action_just_pressed("ui_punch") and !Input.is_action_pressed("ui_kick"):
		action = 'jab'
	elif Input.is_action_just_pressed("ui_kick") and !Input.is_action_pressed("ui_punch"):
		action = 'kick'
	#disable backfist combo for stage 1
	if action != null:
#		print('JOHNNY check sul timer_input_freq ', $timer_input_freq.time_left)
		if $timer_input_freq.time_left > 0:
			print('JOHNNY scarto input perche breath basso')
			return
		$timer_input_freq.start()
		$timer_combo.start()
		self.set_process(false)
		performing_action = true
		last_four_inputs.push_back(action)
		valuta_per_gui()
		last_three_inputs.push_back(action)
		combo_completed = false
#		print('last_three: ', last_three_inputs)
#		print('last_four: ', last_four_inputs)
		var combo_result = null
		if last_three_inputs.size() == 3:#scelgo tra le combo base!
#			print('Johnny get_action_input: combo_selected ', combo_selected,' unlocked?', combo_unlocked[combo_selected])
			#combo[combo_selected]
			var i = combo_base.find(last_three_inputs)
			if i > -1:
#				print('Johnny last_three_inputs are 3', last_three_inputs, ', found in combo_base array at index ', i)
#				print('Johnny showing combo_base_action ', combo_base_action[i])
				#combo_completed = true
				combo_result = combo_base_action[i]
				last_three_inputs.clear()
			else:
				last_three_inputs.remove(0)
		if last_four_inputs.size() >= 4:
#			print('Johnny last_four_inputs == 4 ', last_four_inputs)
			var i = combo.find(last_four_inputs)
#			print('Johnny combo_unlocked=', combo_unlocked,' combo_selected=', combo_selected)
			if i > -1 and i == combo_selected and combo_unlocked[combo_selected]:
#				print('last_four_inputs are 4 ', last_four_inputs, ', found in combo array at index ', i)
#				print('Johnny showing combo action ', combo_action[i])
#				print('combo unlocked? ', combo_selected, ' ', combo_unlocked[combo_selected])
				combo_completed = true
				combo_result = combo_action[i]
				last_four_inputs.clear()
				last_three_inputs.clear()
				emit_signal('update_btn_combo', 0)
			else:
				last_four_inputs.remove(0)
#				last_three_inputs.remove(0)
#		print('combo result: ',combo_result)
		$effect.stream = effectCombo1
		if combo_result != null:
			$effect.stream = effectCombo2
			$timer_no_actions.start()
			action = combo_result
		$effect_swish.play()
		$AnimatedSprite.play(action)
		#andava qui
		
		
func camera_tramble():
	emit_signal("camera_shake_requested")

func hit(damage, enemy):
	if !self.on_train:
	#	print('Johnny hit(): means he get hit')
		if playing_ko:
			return
		if self.performing_action or (enemy and enemy.grab == false and enemy.grab_ignore == true):
			return
	set_process(false)
#	far tremare la camera su e giù
	camera_tramble()
#	print('HIT')
	is_hit = true
	$AnimatedSprite.animation = 'hit'
	$hit_sprite.play()
	$AnimatedSprite.frame = 0
	$effect.stream = effectCombo1
#	if 'boss' in enemy.PSGNAME:
#		$effect.stream = effectComboBoss
#	print('johnny ordina animazione hit')
	$AnimatedSprite.play()
	$effect.play()
#	print('Johnny:hit() HP=', self.HP)
	if self.HP < damage:
		print('ONE LIFE LOST')
		var up = ProjectSettings.get_setting('up')
		if up == 0:
			$effect_defeat.stream = load("res://sound/effects/defeat.ogg")
			$effect_defeat.play()
		playing_ko=true
		going_back_direction = Vector2.LEFT
		if enemy:
			var difference = self.global_position.x - enemy.global_position.x
			if difference >= 0:
				going_back_direction = Vector2.RIGHT
	self.HP -= damage
	emit_signal("player_been_hit", self.HP, self.HP_MAX)
	set_process(true)

func on_stage_timeout():
	print('Johnny:on_stage_timeout()')
	hit(9999, null)

func _on_AnimatedSprite_animation_finished():
#	print('johnny animation finished ', $AnimatedSprite.animation)
	if on_train:
		on_train_AnimatedSprite_animation_finished()
	else:
		if $AnimatedSprite.animation == 'dead':
				yield(get_tree().create_timer(0.5), "timeout")
	#			print('Johnny emits player_down signal')
				emit_signal('player_down')
		elif $AnimatedSprite.animation == 'hit':
			$AnimatedSprite.animation = 'stand'
			is_hit = false
		elif $AnimatedSprite.animation == 'dash':
			$effect.stream = null
		elif $AnimatedSprite.animation in attacks:
			var newHP = int(HP_MAX/5)
			if $AnimatedSprite.animation == 'backfist' and HP > newHP:
				self.HP -= newHP
				emit_signal('backfist', self.HP, self.HP_MAX)
			else:
	#			print('Johnny emits signal hit. action: ', action ,' combo_completed: ', combo_completed)
				emit_signal('hit', $AnimatedSprite.animation, combo_completed)
				if combo_completed:
					$kiai.frame = 0
					$kiai.play()
					print('TODO kiai audio')
			emit_signal("act", $AnimatedSprite.animation, self.breaths)
			self.performing_action = false
			combo_completed = false
			self.set_process(true)

func on_train_AnimatedSprite_animation_finished():
	print('johnny on train animation finished')

func on_blink():
#	print('johnny starts blink!')
	$timer_blink.start()
	$timer_blinker.start()
	$AnimatedSprite/hit.set_deferred('monitorable', false)
	$AnimatedSprite/hit.set_deferred('monitoring', false)
	$AnimatedSprite/hit/hit.set_deferred('disabled', true)

func _on_blinker_timeout():
#	print('johnny stop blink')
	$timer_blink.stop()
	self.show()
	$AnimatedSprite.animation = 'guard'
	$AnimatedSprite/hit.set_deferred('monitorable', true)
	$AnimatedSprite/hit.set_deferred('monitoring', true)
	$AnimatedSprite/hit/hit.set_deferred('disabled', false)
	self.set_process(true)
	pass # Replace with function body.

func _on_blink_timeout():
	if self.visible:
		self.hide()
	else:
		self.show()
	pass # Replace with function body.

func _on_timer_combo_timeout():
	if on_train:
		on_train_timer_combo_timeout()
	else:
#		print('last_four_inputs cleared')
		last_three_inputs.clear()
		last_four_inputs.clear()
		emit_signal('update_btn_combo', 0)
	pass # Replace with function body.

func on_train_timer_combo_timeout():
	pass

func selected_combo(selected_combo):
	combo_selected = selected_combo

func _on_timer_dash_timeout():
	dash = false
	pass # Replace with function body.

func _on_sgommata_animation_finished():
	$AnimatedSprite/sgommata.hide()
	pass # Replace with function body.

func pause_resume(with_paused_menu):
	self.paused = !self.paused
	emit_signal('on_pause_resume', self.paused, with_paused_menu)
#	print('johnny put paused? ', self.paused)
	set_process(!self.paused)
	$AnimatedSprite.animation = 'guard'
	$timer_blink.paused = self.paused
	$timer_blinker.paused = self.paused
#	$timer_combo.paused = self.paused
	$timer_dash.paused = self.paused
	$effect.stop()
	$effect_swish.playing = !self.paused
	$effect_defeat.playing = !self.paused


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == 'walk' and ($AnimatedSprite.frame == 1 or $AnimatedSprite.frame == 3):
		if $effect.playing == false:
			$effect.stream = efx_step
			$effect.play()
	pass # Replace with function body.

func valuta_per_gui():
	if combo_unlocked[combo_selected] and last_four_inputs.size()>0:
		var quanti_da_accendere = 0
		var lf_lasti=last_four_inputs.size()-1
		var totale =  (last_four_inputs==combo[combo_selected])
		var tre =  (last_four_inputs.slice(lf_lasti-2,lf_lasti,1,true)==combo[combo_selected].slice(0,2,1,true))
		var due =  (last_four_inputs.slice(lf_lasti-1,lf_lasti,1,true)==combo[combo_selected].slice(0,1,1,true))
		var uno = last_four_inputs[lf_lasti]==combo[combo_selected][0]
#		print(last_four_inputs, ' on ', combo[combo_selected])
#		print('situa: ', totale,' ', tre, ' ', due, ' ', uno)
		if totale:
			emit_signal('update_btn_combo', 4)
		elif tre:
			emit_signal('update_btn_combo', 3)
		elif due:
			emit_signal('update_btn_combo', 2)
		elif uno:
			emit_signal('update_btn_combo', 1)
		else:
			emit_signal('update_btn_combo', 0)
	else:
			emit_signal('update_btn_combo', 0)
