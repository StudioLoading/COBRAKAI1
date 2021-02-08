extends Node2D

var i
var d
var d_ready

func _ready():
	$cl/d/text.text = ''
	$cl/up.hide()
	$cl/up.rect_size.y = 0
	$cl/down.hide()
	$cl/down.rect_size.y = 0
	$cl/up.show()
	$cl/down.show()
	$cl/d/face.texture = null
	$cl/d/face/speak.frames = null
	$rj.global_position = $init_pos_rj.global_position
	$j.global_position = $init_pos_j.global_position
	$Tween_Mov.interpolate_property($rj, "global_position", $rj.global_position, $final_pos_rj.global_position, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween_Mov.interpolate_property($j, "global_position", $j.global_position, $final_pos_j.global_position, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$rj.animation='walk'
	$rj.playing=true
	$j.animation='walk'
	$j.playing=true
	$Tween_Mov.start()
	prepare_dialogs()
	d_ready= false
	pass # Replace with function body.
	
func prepare_dialogs():
	i = 0
	d = []
	var d0 = {'psg': 'j', 'd': 'What\'s up \ncobra kai fans?'}
	var d0_b = {'psg': 'j', 'd': 'I am here\nwith RJ'}
	var d1 = {'psg': 'j', 'd': 'Shout it back!\nWe are back!!'}
	var d2 = {'psg': 'j', 'd': 'Thanks for\nfollowing\nthis page.'}
	var d3 = {'psg': 'j', 'd': 'Take care\nand\nNo Mercy !'}
	var d4 = {'psg': 'j', 'd': 'We will\nsee you\nat the dojo.'}
	
	var d6 = {'psg': 'rj', 'd': 'Here\'s RJ'}
	var d7 = {'psg': 'rj', 'd': 'shout out\nto myself...'}
	
	var d8 = {'psg': 'j', 'd': 'You just\nshout out\nto yourself?'}
	var d9 = {'psg': 'j', 'd': 'That\'s a\ncobra kai\nright there!'}
	
	var d10 = {'psg':'both', 'd': '**both\nlaughing**'}
	
	d.append(d0)
	d.append(d0_b)
	d.append(d1)
	d.append(d2)
	d.append(d3)
	d.append(d4)
	d.append(d6)
	d.append(d7)
	d.append(d8)
	d.append(d9)
	d.append(d10)


func next_dialog():
	$cl/d.hide()
	var animation = 'default'
	var face = null
	var speak = null
	var rj_animation = 'guard'
	var j_animation= 'guard'
	if i < d.size():
		match d[i]['psg']:
			'rj':
				face = load("res://asset/GUI/cobra/RJ_normal.png")
				speak = load("res://animations/rj_gui_rj.tres")
				rj_animation = 'stand_talk'
				j_animation = 'guard'
			'j':
				face = load("res://asset/GUI/cobra/Johnny_normal.png")
				speak = load("res://animations/intro_gui_johnny.tres")
				rj_animation = 'guard'
				j_animation = 'stand_talk'
			'both':
				rj_animation = 'guard_talk'
				j_animation = 'guard_talk'
				
		$rj.animation = rj_animation
		$j.animation = j_animation
		$cl/d/face.texture = face
		$cl/d/face/speak.frames = speak
		$cl/d/face/speak.animation = animation
		$cl/d/face/speak.play()
		$cl/d/text.text = d[i]['d']
		$cl/d.show()
		i+=1
	else:
		play_outro()
	
func _input(event):
	if d_ready and  event.is_pressed():
		next_dialog()
	pass


func _on_Tween_Mov_tween_all_completed():
	$rj.animation='stand'
	$j.animation='stand'
	yield(get_tree().create_timer(0.7), "timeout")
	$Tween_updown.interpolate_property($cl/up, "rect_size", Vector2($cl/up.rect_size.x, 0), Vector2($cl/up.rect_size.x, 78), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween_updown.start()


func _on_Tween_updown_tween_all_completed():
	print('start dialog')
	d_ready = true
	pass # Replace with function body.

func play_outro():
	d_ready=false
	$Tween_outro.interpolate_property($rj, "global_position", $rj.global_position, $init_pos_rj.global_position, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween_outro.interpolate_property($j, "global_position", $j.global_position, $init_pos_j.global_position, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween_outro.interpolate_property($cl/up, "rect_size", $cl/up.rect_size, Vector2($cl/up.rect_size.x, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$rj.animation='walk'
	$j.animation='walk'
	$rj.flip_h=true
	$j.flip_h=false
	$Tween_outro.start()


func _on_Tween_outro_tween_all_completed():
	$rj.queue_free()
	$j.queue_free()
	pass # Replace with function body.
