extends Node2D

var ready 
var i 
var d 

onready var diag_finished = false

func _ready():
	$Tween.interpolate_property($miguel, "position", $miguel_init_pos.position,$miguel_final_pos.position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$miguel.animation='walk'
	$miguel.play()
	prepare_dialogs()
	pass # Replace with function body.

func prepare_dialogs():
	ready = false
	i = 0
	d = []
	var d0 = {'psg': 'johnny', 'd': 'So you want to\nkick some ass ??'}
	var d1 = {'psg': 'johnny', 'd': 'First'}
	var d2 = {'psg': 'johnny', 'd': 'You have to\nlearn how\nto kick !'}
	var d3 = {'psg': 'miguel_smile', 'd': '*smile*'}
	var d4 = {'psg': 'johnny', 'd': 'Meet me at\nthe pool at\nmidnight.'}
	d.append(d0)
	d.append(d1)
	d.append(d2)
	d.append(d3)
	d.append(d4)
	pass


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
	elif !diag_finished:
		diag_finished = true
		$Tween.disconnect('tween_all_completed', self, '_on_Tween_tween_all_completed')
		$Tween.connect('tween_all_completed', self, '_on_Tween_tween_all_completed_change_scene')
		$Tween.interpolate_property($miguel, "position", $miguel_final_pos.position,$miguel_init_pos.position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($johnny, "position", $johnny.position, $miguel_init_pos.position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		$miguel.flip_h=true
		$johnny.flip_h=true
		$miguel.animation='walk'
		$miguel.play()
		$johnny.animation='walk'
		$johnny.play()
	else:
		get_tree().change_scene("res://stage3.tscn")

func _on_Tween_tween_all_completed():
	print('miguel reached the position')
	$miguel.animation='guard'
	$miguel.play()
	ready= true
	
	pass # Replace with function body.

func _on_Tween_tween_all_completed_change_scene():
	print('now go to the pool, real stage3 starts')
	$Tween.disconnect('tween_all_completed', self, '_on_Tween_tween_all_completed_change_scene')
	pass
