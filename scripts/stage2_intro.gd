extends Node2D


var d
var i
var ready
# Called when the node enters the scene tree for the first time.
func _ready():
	ready = false
	i = 0
	d = []
	var d0 = {'psg': 'johnny', 'd': 'Are you sure\nyou are ready ?'}
	var d1 = {'psg': 'johnny', 'd': '\'Cause once you go\ndown this path\nthere is no way back.'}
	var d2 = {'psg': 'miguel', 'd': 'You\'re gonna be\nmy karate teacher?'}
	var d3 = {'psg': 'johnny', 'd': 'No'}
	var d4 = {'psg': 'johnny', 'd': '...'}
	var d5 = {'psg': 'johnny', 'd': 'I\'m gonna be your sensei'}
	var d6 = {'psg': 'miguel_smile', 'd': '*smile*'}
	var d7 = {'psg': 'johnny', 'd': 'I\'m gonna teach you\nthe style \nof karate'}
	var d8 = {'psg': 'johnny', 'd': 'that was tought to me:'}
	var d9 = {'psg': 'johnny', 'd': 'a method of fighting\nyour pussy generation\ndesperately needs'}
	var d10 = {'psg': 'johnny', 'd': 'I\'m not just gonna teach\nyou how to conquer\nyour fears'}
	var d11 = {'psg': 'johnny', 'd': 'I\'ll teach you how to\nawaken the snake\nwithin you.'}
	var d12 = {'psg': 'johnny', 'd': 'And once you do that,\nyou\' ll \nbe the one who\'s feared.'}
	var d13 = {'psg': 'johnny', 'd': 'You\'ll build strength.\nYou\'ll learn descipline.'}
	var d14 = {'psg': 'johnny', 'd': 'And when the time is right:\nyou\'ll strike back.'}
	var d15 = {'psg': 'miguel_smile', 'd': '*smile*'}
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
	$cl/s/m/hb/ccf/face.hide()
	$cl/s/m/hb/cct/text.hide()
	$bgm.play()
#	$cl/black_down.rect_size.y = 40
	pass # Replace with function body.


func _on_Timer_timeout():
	$Tween.interpolate_property($johnny, "global_position", $johnny.global_position, $miguel/p.global_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$johnny.animation = 'walk'
	print('start!')
#	$Timer.disconnect('timeout', self, '_on_Timer_timeout')
	pass # Replace with function body.


func _on_Tween_tween_all_completed():
	print('johnny reached the position')
	$johnny.animation='stand'
	$miguel.flip_h = true
	ready= true
	pass # Replace with function body.


func _input(event):
	if event.is_pressed() and ready:
		$cl/s/m/hb/ccf/face.show()
		$cl/s/m/hb/cct/text.show()
		next_dialog()

func next_dialog():
	var face
	var speak
	var animation = 'default'
	if i < d.size():
		match d[i]['psg']:
			'miguel', 'miguel_smile':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
			'johnny':
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
		$cl/s/m/hb/ccf/face.texture = face
		$cl/s/m/hb/ccf/face/speak.frames = speak
		$cl/s/m/hb/ccf/face/speak.animation = animation
		$cl/s/m/hb/ccf/face/speak.play()
		$cl/s/m/hb/cct/text.text = d[i]['d']
		i+=1
	else:
		get_tree().change_scene("res://stage2.tscn")
	
