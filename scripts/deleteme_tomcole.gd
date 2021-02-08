extends Node2D

var d 
var i
var d_ready

func _ready():
	$cl/up.rect_size.y = 0
	$cl/d/face.hide()
	$cl/d/face/speak.hide()
	$cl/d/text.rect_size.x = 80
	$Tween.interpolate_property($cl/up, "rect_size", $cl/up.rect_size, Vector2($cl/up.rect_size.x, 80), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	prepare_dialogs()
	d_ready = false
	$AnimatedSprite.animation = 'boba'
	$cl/d/text.text = ''
	pass # Replace with function body.

func prepare_dialogs():
	i = 0
	d = []
	var d0 = {'psg': '', 'd': 'Are you sure I\ncan\'t get you a Boba?'}
	var d1 = {'psg': '', 'd': '*whassaaahh*'}
	var d2 = {'psg': '', 'd': 'we got a two-time\nAll Valley Champ here!'}
	var d3 = {'psg': '', 'd': '*slurping*'}
	d.append(d0)
	d.append(d1)
	d.append(d2)
	d.append(d3)
	

func _on_talk_timeout():
	$cl/d/text.text = d[1]['d']
	$AnimatedSprite.animation = 'default'
	$wasaa.start()
	pass # Replace with function body.


func _on_wasaa_timeout():
	$cl/d/text.text = d[2]['d']
	$AnimatedSprite.animation = 'talk'
	$talk2.start()
	pass # Replace with function body.

func _on_talk2_timeout():
	$cl/d/text.text = d[3]['d']
	$AnimatedSprite.animation = 'boba'
	$boba.start()
	pass # Replace with function body.

func _on_boba_timeout():
	$cl/d/text.text = '. . .'
	$AnimatedSprite.animation = 'stand'
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	d_ready = true
	pass # Replace with function body.
	
func _input(event):
	if d_ready and  event.is_pressed():
		$cl/d/text.text = d[0]['d']
		$AnimatedSprite.animation = 'talk'
		$talk.start()
		d_ready = false
	pass
