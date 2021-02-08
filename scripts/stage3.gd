extends Node2D

onready var i = 0
onready var d_step_0 = []
onready var d_step_1 = []
onready var d_step_2 = []
onready var d_step_3 = []
onready var d_step_4 = []
	
func _ready():
	$johnny.hide()
	$johnny.position = $init_pos.position
	$Tween_show.interpolate_property($johnny, "position",  $johnny.position, $show_pos.position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween_show.start()
	$miguel_a.position = $init_pos.position
	$miguel_a.animation='walk'
	$miguel_a.play()
	$miguel_a.flip_h = true
	prepare_dialogs()
	$cl/player.hide()
	$cl/player/time.hide()
	$path/f/splash.hide()
	$cl/step_info/h/vi/i.text = 'FLOATS'
	$cl/step_info/h/vi/h/n.text = '01'
	$cl/step_info/h/vi/h/ntot.text = '04'
	$bgm.play()
	$cl/player/h_up.hide()
	pass # Replace with function body.


func prepare_dialogs():
	var d0 = {'psg': 'johnny', 'd': 'Your first instinct\nis to use your\nhands, right ?'}
	var d1 = {'psg': 'johnny', 'd': 'You gotta unlearn that.\nand think with your legs'}
	var d11 = {'psg': 'miguel', 'd': 'How do I\nthink with my\nlegs ?'}
	var d20 = {'psg': 'johnny', 'd': 'Well you\njust\n...'}
	var d21 = {'psg': 'johnny_jab', 'd': '*push*'}
	var d30 = {'psg': 'johnny', 'd': 'Use your legs\nto kick your\nway out!'}
	d_step_0.append(d0)
	d_step_0.append(d1)
	d_step_0.append(d11)
	d_step_0.append(d20)
	d_step_0.append(d21)
	d_step_0.append(d30)

func show_dialogs(ds):
	var face
	var speak
	var animation = 'default'
	var dialog = d_step_0
	if ds != null:
		dialog = ds
	$cl/player.hide()
	$cl/s.show()
	while i < dialog.size():
		match dialog[i]['psg']:
			'johnny':
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
			'miguel':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
			'johnny_jab':
				$johnny.animation = 'jab'
				$johnny.play()
				$miguel_a.hide()
				$path/f/s.texture = load("res://asset/miguel_swim/hit.png")
				$path/f/s.flip_h = true
				$path/f/Tween.interpolate_property($path/f, "unit_offset", 0, 1, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				$path/f/Tween.start()
				yield($johnny, "animation_finished")
				$johnny.animation = 'stand'
				$johnny.play()
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
		$cl/s/m/hb/ccf/face.texture = face
		$cl/s/m/hb/ccf/face/speak.frames = speak
		$cl/s/m/hb/ccf/face/speak.animation = animation
		$cl/s/m/hb/ccf/face/speak.play()
		$cl/s/m/hb/cct/text.text = dialog[i]['d']
		var wait_diag = int(dialog[i]['d'].length() / 10)
		i += 1
		yield(get_tree().create_timer(wait_diag), "timeout")
	i = 0
	#$cl/player/f/breath.value = $cl/player/f/breath.max_value
#	$cl/player/f.show()
	$cl/player.show()
	$cl/s.hide()
	$cl/player/controller.hide()
	pass # Replace with function body.

func _on_Tween_show_tween_all_completed():
	$johnny.show()
	$Tween_walk.interpolate_property($johnny, "position",  $johnny.position, $johnny_final_pos.position, 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween_walk.start()
	$Tween_show.disconnect('tween_all_completed', self, '_on_Tween_show_tween_all_completed')
	$Tween_show.connect('tween_all_completed', self, '_on_Tween_show_tween_all_completed_miguel')
	$Tween_show.interpolate_property($miguel, "position",  $miguel_a.position, $show_pos.position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween_show.start()
	pass # Replace with function body.

func _on_Tween_show_tween_all_completed_miguel():
	$Tween_walk.interpolate_property($miguel_a, "position",  $miguel_a.position, $miguel_final_pos.position, 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween_walk.start()
	pass

func _on_Tween_walk_tween_all_completed():
	$johnny.animation = 'stand'
	$johnny.flip_h = false
	$Tween_walk.disconnect('tween_all_completed', self, '_on_Tween_walk_tween_all_completed')
	$Tween_walk.connect('tween_all_completed', self, '_on_Tween_walk_tween_all_completed_miguel')
	$Tween_walk.interpolate_property($miguel_a, "position",  $miguel_a.position, $miguel_final_pos.position, 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween_walk.start()
	pass # Replace with function body.

func _on_Tween_walk_tween_all_completed_miguel():
	$miguel_a.animation = 'stand'
	$miguel_a.flip_h = true
	$miguel_a.play()
	show_dialogs(null)
#	$miguel.position = $miguel_a.positioĸ

func _on_Tween_tween_all_completed():
	$path/f/splash.show()
	$path/f/splash.play()
	$path2/f/s.hide()
	$path2/f/s.texture = load("res://asset/miguel_swim/hit.png")
	$path2/f/s.flip_h = true
	$path2/f/s.show()
	$path/f/s.hide()
	$path2/f/Tween.interpolate_property($path2/f, "unit_offset", 0, 1, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$path2/f/Tween.start()
	$efx.stream = load("res://sound/effects/splash.ogg")
	$efx.play()
	pass # Replace with function body.


func _on_splash_animation_finished():
	pass # Replace with function body.


func _on_Tween_tweenp2_all_completed():
	$path2.queue_free()
	var player_scene = load("res://Miguel_swim.tscn")
	var player = player_scene.instance()
	player.connect('decrease_breath', $cl/player/f, 'update_bar')
	player.connect('reset_breath', $cl/player/f, 'reset_bar')
	$cl/player/f.connect('out_of_breath', self, 'out_of_breath')
	player.connect('update_times', self, 'update_times')
	player.surface_global_y = $water_surface.global_position.y
	player.get_node("a").play()
#	print('surface_global_y=', $water_surface.global_position.y)
	$water_surface.add_child(player)
	player.set_process(true)
	$path.queue_free()
	pass # Replace with function body.

func update_times(times):
	$cl/step_info/h/vi/h/n.text = str('0', times)
	if times == 4:
		d_step_0.clear()
		var ds = []
		ds.append({'psg': 'johnny', 'd': 'YEEAH!!\n KEEP KICKIN\''})
		show_dialogs(ds)
		$cl/step_info/h/vi/h/n.text = str("%02d" % int(round(0)))
		$timer_final_time.start()

func out_of_breath():
	var player = $water_surface.get_child(0)
	print('stage3 out_of_breath()')
	player.out_of_breath()
	var ds = []
	ds.append({'psg': 'johnny', 'd': 'Cobra Kai\n never dies,\n SAY IT!!'})
	ds.append({'psg': 'miguel', 'd': 'Cobra Kai never dies!!!'})
	show_dialogs(ds)

func _on_timer_final_time_timeout():
	$cl/step_info/h/vi/i.text = 'RESIST'
	var n = int($cl/step_info/h/vi/h/n.text)
	n += 1
	if n < 31:
		$cl/step_info/h/vi/h/n.text = str("%02d" % int(round(n)))
		$cl/step_info/h/vi/h/ntot.text = '30'
	if n == 30:
		var player = $water_surface.get_child(0)
		player.get_node("gravity").paused = true
		$timer_final_time.paused=true
#		print('HALF STAGE FINISHED! outro with the janitor and back to the dojo for kickcombo')
		$miguel_a.position =  $miguel_final_pos.position
		$miguel_a.animation = 'walk'
		$johnny.animation = 'walk'
		player.queue_free()
		$cl/step_info.queue_free()
		$miguel_a.show()
		$miguel_a.flip_h=false
		$Tween_walk.disconnect('tween_all_completed', self, '_on_Tween_walk_tween_all_completed_miguel')
		$Tween_walk.interpolate_property($miguel_a, "position",  $miguel_a.position, $show_pos.position, 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween_walk.interpolate_property($johnny, "position",  $johnny.position, $show_pos.position, 1.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween_walk.start()
		yield($Tween_walk, 'tween_all_completed')
		get_tree().change_scene("res://stage3_dojo.tscn")
		pass # Replace with function body.
