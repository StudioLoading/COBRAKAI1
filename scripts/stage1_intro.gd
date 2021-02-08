extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var initial_camera_x
var black_up_final_y
var d 
var i
var d_ready
onready var bg_johnny = preload('res://sound/stage1.ogg')
onready var bg_enemies = preload('res://sound/softsuspance.ogg')
# Called when the node enters the scene tree for the first time.
func _ready():
	$johnny.hide()
	$cl/s/m/hb/ccf/face/speak.frames = null
	$cl/s/m/hb/ccf/face.texture = null
	$bg.stream = bg_enemies
	$bg.play()
	d_ready = false
	black_up_final_y = 100
	initial_camera_x = -500
	$Camera2D.offset.x = initial_camera_x
	$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2.ZERO, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	prepare_dialogs()
	d_ready = true
	pass # Replace with function body.

func prepare_dialogs():
	i = 0
	d = []
	var d0 = {'psg': 'miguel', 'd': 'it was for my grandma!'}
	var d1 = {'psg': 'ky', 'd': 'Hey you want it?'}
	var d2 = {'psg': 'ky', 'd': 'Take it all.'}
	var d3 = {'psg': 'miguel_rea', 'd': '*ouch*'}
	var d4 = {'psg': 'ciccione', 'd': 'we should call him \'Rea !! '}
	var d5 = {'psg': 'ky', 'd': '...bitch'}
	var d6 = {'psg': 'miguel', 'd': '... asshole'}
	var d7 = {'psg': 'ky', 'd': 'What\'d you say, \'Rea ?!'}
	var d8 = {'psg': 'ky_jab', 'd': '*puch*'}
	var d9 = {'psg': 'ciccione', 'd': 'That\'s brute, Ky'}
	var d10 = {'psg': 'johnny', 'd': 'HEEEEY !!'}
	var d11 = {'psg': 'camera_johnny', 'd': ''}
	var d12 = {'psg': 'johnny', 'd': 'Just leave the dork alone.'}
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
	
func next_dialog():
	var face
	var speak
	var animation = 'default'
	if i < d.size():
		match d[i]['psg']:
			'ky', 'ky_jab':
				face = load("res://asset/GUI/highschool/ky_mute.png")
				speak = load("res://animations/intro_gui_ky.tres")
			'ciccione':
				face = load("res://asset/GUI/highschool/ciccione_mute.png")
				speak = load("res://animations/intro_gui_ciccione.tres")
			'miguel':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
			'miguel_rea':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
				animation='sciroppo'
			'johnny':
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
				if $bg.stream != bg_johnny:
					$bg.stop()
					$bg.stream = bg_johnny
					if !$bg.playing:
						$bg.play()
		$cl/s/m/hb/ccf/face.texture = face
		$cl/s/m/hb/ccf/face/speak.frames = speak
		$cl/s/m/hb/ccf/face/speak.animation = animation
		$cl/s/m/hb/ccf/face/speak.play()
		$cl/s/m/hb/cct/text.text = d[i]['d']
#		$cl/d.show()
		if '_jab' in d[i]['psg']:
			$ky.animation='jab_intro'
			$ky.play()
			$rea.animation='hit'
			$rea.play()
		elif '_rea' in d[i]['psg']:
			$rea.animation='default'
			$rea.play()
		elif 'camera_johnny' in d[i]['psg']:
			$ky.animation='stand'
			$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(initial_camera_x, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			$johnny.animation = 'guard'
			$johnny.show()
			#yield($Tween, "tween_completed")
		i+=1
	else:
		get_tree().change_scene("res://stage1.tscn")
	
func _input(event):
	if d_ready and  event.is_pressed():
		next_dialog()
	pass
