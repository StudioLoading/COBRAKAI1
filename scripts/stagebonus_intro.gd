extends Node2D

onready var i = 0
onready var d
onready var d_ready = false

func _ready():
	
	$cl/s.hide()
	$credits/bg.hide()
	$credits/cc.hide()
	$bgm.play()
	prepare_dialogs()
	$YSort/johnny.animation = 'stand'
	yield(get_tree().create_timer(2), "timeout")
	$Tween.interpolate_property($bg2, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$bg2.queue_free()
	d_ready = true
	pass # Replace with function body.


func get_player_global_position():
	return $YSort/johnny.global_position

func kreese_hits(damage, node):
	print('kreese hitting !')
	$YSort/johnny.animation='hit'
	yield($YSort/johnny/AnimatedSprite, "animation_finished")
	$YSort/johnny.animation='guard'
	

func prepare_dialogs():
	i = 0
	d = []
	var d0 = {'psg': 'kreese', 'd': 'CobraKai is back\nwhere it belongs'}
	var d1 = {'psg': 'kreese', 'd': 'back on top.'}
	var d2 = {'psg': 'kreese', 'd': 'Everyone closed\nthe book on us.'}
	var d3 = {'psg': 'kreese', 'd': 'But now they see'}
	var d4 = {'psg': 'kreese', 'd': 'that the real\nstory\'s only\njust begun.'}
	
	d.append(d0)
	d.append(d1)
	d.append(d2)
	d.append(d3)
	d.append(d4)
	
	
	
func next_dialog():
	$cl/s.hide()
	var face
	var speak
	var animation = 'default'
	if i < d.size():
		if i == 1:
			$YSort/kreese.animation='walk'
			$Tween.interpolate_property($YSort/kreese, "global_position", $YSort/kreese.global_position, $YSort/pos.global_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		if i == 4:
			$YSort/kreese.animation='guard'
			$YSort/johnny.animation='guard'
			$Timer.start()
		match d[i]['psg']:
			'kreese':
				face = load("res://asset/GUI/cobra/Kreese_normal.png")
#				speak = load("res://animations/intro_gui_johnny.tres")
			'johnny':
				face = load("res://asset/GUI/cobra/Johnny_normal.png")
				speak = load("res://animations/intro_gui_johnny.tres")
		$cl/s/m/hb/ccf/face.texture = face
		$cl/s/m/hb/ccf/face/speak.frames = speak
		$cl/s/m/hb/ccf/face/speak.animation = animation
		$cl/s/m/hb/ccf/face/speak.play()
		$cl/d/text.text = d[i]['d']
		$cl/d.show()
		i+=1

func _input(event):
	if d_ready and  event.is_pressed():
		next_dialog()
	pass


func _on_Tween_tween_all_completed():
	$YSort/kreese.animation='stand'
	$YSort/johnny.animation='stand'
	pass # Replace with function body.


func _on_Timer_timeout():
	$Timer.stop()
	$bgm.stop()
	$bgm.stream = load("res://sound/effects/kreese_aintz.ogg")
	$bgm.play()
	$YSort/kreese.animation='jab'
	yield($YSort/kreese, "animation_finished")
	$YSort/johnny.animation='hit'
	$YSort/kreese.animation='sweep'
	yield($YSort/kreese, "animation_finished")
	$YSort/johnny.animation='dead'
	yield($YSort/johnny, "animation_finished")
	$credits/bg.show()
	$Tween.interpolate_property($credits/bg, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$credits/cc.show()
	pass # Replace with function body.
