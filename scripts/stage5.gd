extends "res://scripts/stage_father.gd"

onready var ball_scene = preload("res://stage5_ball.tscn")
onready var ball_time = 1.8
onready var ball_time_initial = 1.8
onready var ball_counter = 0
onready var ball_dodge_counter = 0
onready var ball_hit_counter = 0
onready var ball_max_initial = 10
onready var ball_max_final = 22
onready var ball_max = 10

func _ready():
	STAGE_TIMER = 59
	STAGE_NUMBER = ProjectSettings.get_setting("stage")
	if STAGE_NUMBER == null:
		STAGE_NUMBER = 5
	ProjectSettings.set_setting("stage", str(STAGE_NUMBER))
	$YSort/spawn_player.global_position = $YSort/spawn_player_stage.global_position
	reset_player_position()
	stage_bg = preload('res://sound/stage2.ogg')
	$bgm.stream = stage_bg
	$bgm.play()
	NO_TIME_STAGE = true
	init_player()
	$YSort/dragon/arrow.hide()
	right_panel_speeding_up()
	yield(get_tree().create_timer(2), "timeout")
	$ball_timer.wait_time = ball_time
	right_panel_start_balls()
	play_intro()
	
	
func play_intro():
	var d = []
	var d0 = {'psg': 'Johnny', 'd': 'Dodge the balls!'}
	var d1 = {'psg': 'Johnny', 'd': 'Press the correct\narrow at the\ncorrect time'}
	var d2 = {'psg': 'Johnny', 'd': '.. Ready ?!'}
	var d3 = {'psg': 'Miguel', 'd': 'Yes sen..'}
	var d4 = {'psg': 'Johnny', 'd': 'GO!'}
	d.append(d0)
	d.append(d1)
	d.append(d2)
	d.append(d3)
	d.append(d4)
	$GUI/cl/s.show()
	next_dialog(d, 0)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 1)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 2)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 3)
	yield(get_tree().create_timer(0.5), "timeout")
	next_dialog(d, 4)
	yield(get_tree().create_timer(1), "timeout")
	$GUI/cl/s.hide()
	stage_bg = preload('res://sound/stage2.ogg')
	$bgm.stream = stage_bg
	$bgm.play()
	_on_ball_timer_timeout()
	$ball_timer.start()
	
func play_outro_diags():
	var d = []
	var d0 = {'psg': 'Johnny', 'd': 'Good job!\nwhat are you\nlooking at?'}
	var d1 = {'psg': 'Miguel', 'd': 'AUCH!!'}
	var d2 = {'psg': 'Miguel', 'd': '.. it was not fair!'}
	var d3 = {'psg': 'Johnny', 'd': 'You looking for\na fair fight?'}
	var d4 = {'psg': 'Johnny', 'd': 'Dream On !!'}
	var d5 = {'psg': 'Johnny', 'd': 'What if that\nbaseball was\nan enemy\'s friend'}
	var d6 = {'psg': 'Johnny', 'd': 'coming at you\nfrom behind ?'}
	var d7 = {'psg': 'Johnny', 'd': '... Let me look'}
	var d8 = {'psg': 'Johnny', 'd': 'it\'s fine,\njust don\'t be a baby.'}
	d.append(d0)
	d.append(d1)
	d.append(d2)
	d.append(d3)
	d.append(d4)
	d.append(d5)
	d.append(d6)
	d.append(d7)
	d.append(d8)
	$GUI/cl/s.show()
	next_dialog(d, 0)
	yield(get_tree().create_timer(2), "timeout")
	_on_ball_timer_timeout()
#	yield(get_tree().create_timer(1), "timeout")
#	$YSort/player/AnimatedSprite.play('hit')
#	$YSort/player/AnimatedSprite.playing = false
#	$YSort/player/AnimatedSprite.frame = 0
	yield(get_tree().create_timer(0.5), "timeout")
	next_dialog(d, 1)
	yield(get_tree().create_timer(1.5), "timeout")
	next_dialog(d, 2)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 3)
	yield(get_tree().create_timer(2), "timeout")
	next_dialog(d, 4)
	yield(get_tree().create_timer(2), "timeout")
	next_dialog(d, 5)
	yield(get_tree().create_timer(2), "timeout")
	next_dialog(d, 6)
	yield(get_tree().create_timer(3), "timeout")
	next_dialog(d, 7)
	$YSort/sensei.play('walk')
	var final_sensei_pos = $YSort/player.global_position
	final_sensei_pos.x = $YSort/player.global_position.x- 10
	$Tween.interpolate_property($YSort/sensei, "global_position", $YSort/sensei.global_position, final_sensei_pos, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	$YSort/sensei.play('stand')
	yield(get_tree().create_timer(1), "timeout")
	next_dialog(d, 8)
	$YSort/player/AnimatedSprite.play('dodge_stand')
	$YSort/player/AnimatedSprite.frame = 0
	yield(get_tree().create_timer(3), "timeout")
	print('STAGE5 TODO moving chars to the exit')
	$GUI/cl/s.hide()
	play_outro()

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

func right_panel_start_balls():
	$env/bg/right/throws.text = str(ball_max)
	$env/bg/right/dodge.text = str("%02d" % ball_dodge_counter)
	$env/bg/right.texture = load("res://asset/stage5/right.png")
	$env/bg/right/throws.show()
	$env/bg/right/dodge.show()

func right_panel_speeding_up():
	$env/bg/right.texture = load("res://asset/stage5/speeding_up.png")
	$env/bg/right/throws.hide()
	$env/bg/right/dodge.hide()

func right_panel_speeding_down():
	$env/bg/right.texture = load("res://asset/stage5/speeding_down.png")
	$env/bg/right/throws.hide()
	$env/bg/right/dodge.hide()

func init_player_child():
	$YSort/player/AnimatedSprite/backfist.set_deferred('monitoring', true)
	$YSort/player/AnimatedSprite/backkick.set_deferred('monitoring', true)
	$YSort/player/AnimatedSprite/jab.set_deferred('monitoring', true)
	$YSort/player/AnimatedSprite/raw.set_deferred('monitoring', true)
	$YSort/player/AnimatedSprite/kick.set_deferred('monitoring', true)
	$YSort/player/Camera2D.current =false
	$Camera2D.current = true
	$YSort/player.set_process(false)
	$YSort/player.step_train = 'dodge'
	$YSort/player.on_train = true
#	$YSort/player/AnimatedSprite/hit.connect('body_entered', self, 'ball_hit_player')
	
func _on_ball_timer_timeout():
		$YSort/dragon/arrow.flip_h=false
		$YSort/dragon/arrow.flip_v=false
		$YSort/dragon/arrow.rotation_degrees = 0
		var ball_instance = ball_scene.instance()
		ball_instance.global_position = $YSort/spawner_ball.global_position
		ball_instance.get_node("AnimatedSprite").play('rolling')
		var impulse = Vector2.LEFT * 600
		var r = rng.randi_range(-1,2)
		ball_instance.config(Vector2.DOWN)
		match r:
			-1:
				ball_instance.config(Vector2.DOWN)
				$YSort/dragon/arrow.flip_v=true
			0:
				ball_instance.config(Vector2.RIGHT)
				$YSort/dragon/arrow.rotation_degrees=90
			1:
				ball_instance.config(Vector2.UP)
			2:
				ball_instance.config(Vector2.LEFT)
				$YSort/dragon/arrow.rotation_degrees=-90		
		$YSort/dragon/arrow.show()
		var vec = Vector2.UP * rng.randi_range(0,1)
		impulse += vec * 30
		ball_instance.apply_impulse(Vector2.ZERO, impulse)
		$dragon_balls.play('roll')
		yield($dragon_balls, "animation_finished")
		$YSort.add_child(ball_instance)
		ball_counter += 1
		$YSort/dragon/arrow.hide()

func _on_ball_hit_area_entered(area):
	if area.get_parent().is_in_group('ball'):
		$ball_timer.paused = true
		var dodge = area.get_parent().get_dodge()
		var player_animation = $YSort/player/AnimatedSprite.animation
#		print('STAGE5 hit by ball with dodge_dir : ', dodge)
#		print('STAGE5 player playing animation ',  player_animation)
		var dodged = false
		match dodge:
			Vector2.DOWN:
				if player_animation == 'dodge_down':
					dodged = true
			Vector2.UP:
				if player_animation == 'dodge_up':
					dodged = true
			Vector2.LEFT:
				if player_animation == 'dodge_left':
					dodged = true
			Vector2.RIGHT:
				if player_animation == 'dodge_right':
					dodged = true
		area.get_parent().apply_impulse(Vector2.ZERO, Vector2.DOWN*50)
#		print('ball dodged ? ', dodged)
		if !dodged:
#			print('emit signal player hit !!')
			ball_hit_counter += 1
			$YSort/player/hit_sprite.frame = 0
			$YSort/player/hit_sprite.play()
			$YSort/player/AnimatedSprite.play('hit')
			$efx.stream = load("res://sound/effects/hit.combo.2.ogg")
		else:
			ball_dodge_counter += 1
			$efx.stream = load("res://sound/effects/training.ogg")
		$efx.play()
		$env/bg/right/dodge.text = str("%02d" % ball_dodge_counter)
		var results = ball_hit_counter + ball_dodge_counter
		if results == ball_max:
			print(ball_dodge_counter,'/',ball_max)
			if ball_dodge_counter > (ball_max/2):
				print('next step!')
				if ball_max == ball_max_final:
					print('stag5 completed')
					$ball_timer.stop()
					$ball_timer.one_shot = true
					ball_max = 1
					$YSort/player/AnimatedSprite.flip_h = true
					right_panel_speeding_down()
					play_outro_diags()
				else:
					ball_max += 4
					ball_time -= 0.3
					right_panel_speeding_up()
			else:
				print('back to first step!')
				ball_max = ball_max_initial
				ball_time = ball_time_initial
				right_panel_speeding_down()
			ball_dodge_counter = 0
			ball_hit_counter = 0
			$env/bg/right/dodge.text = str("%02d" % ball_dodge_counter)
			$env/bg/right/throws.text = str(ball_max)
			$ball_timer.wait_time = ball_time
			yield(get_tree().create_timer(3), "timeout")
		$ball_timer.paused = false
		right_panel_start_balls()
	pass # Replace with function body.

func _on_dragon_balls_frame_changed():
	if $dragon_balls.frame == 1 and $dragon_balls.animation == 'roll':
		$efx.stream = load("res://sound/effects/dash.ogg")
		$efx.play()
	pass # Replace with function body.

func _on_dragon_balls_animation_finished():
	if $dragon_balls.animation == 'roll':
		$dragon_balls.play('default')
	pass # Replace with function body.
