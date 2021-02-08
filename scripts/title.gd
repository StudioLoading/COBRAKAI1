extends Control

var sensible
onready var rdy = false

func _ready():
	sensible= false
	ProjectSettings.set_setting("stage", 1)
	ProjectSettings.set_setting("stage_name", 'ACE DEGENERATE')
	ProjectSettings.set_setting("life", 30)#uguale al HP della scena Johnny
	ProjectSettings.set_setting("time", 70)
	ProjectSettings.set_setting("score", 0)
	ProjectSettings.set_setting("up", 2)
	ProjectSettings.set_setting('combo_unlocked', [false, false, false, false, false])
	$joypad.hide()
	if Input.is_joy_known(0) and Input.get_joy_name(0) != null:
		print(Input.get_joy_name(0) + " device connected")
		$joypad.show()
		for i in range(16):
			print(str(i), ' ', Input.get_joy_button_string(i))
	else:
		print('no joypad connected!')
	$bg.play()
	Input.connect("joy_connection_changed",self,"joy_con_changed")
	pass # Replace with function body.

func joy_con_changed(deviceid,isConnected):
	if isConnected:
		$joypad.show()
		print("Joystick " + str(deviceid) + " connected")
		if Input.is_joy_known(0):
			print("Recognized and compatible joystick")
		else:
			print('Joystick unknown')
		print(Input.get_joy_name(0) + " device connected")
	else:
		$joypad.hide()
		print("Joystick " + str(deviceid) + " disconnected")
	pass
	
func _input(event):
	if event.is_pressed() and sensible:
		if event.is_action_pressed("ui_cancel"):
			get_tree().reload_current_scene()
			return
		else:
			if event.is_action_pressed("ui_start") and rdy:
				$t_pushstart.stop()
				$push_start.hide()
				$bg.stop()
				yield(get_tree().create_timer(0.3), "timeout")
				var bg = load('res://sound/effects/title_lingua.wav')
				bg.loop_mode=0
				$efx.stream = bg
				$efx.play()
				$t.texture=load("res://asset/title/logo.png")
				$Timer.start()
				sensible = false

func _on_Timer_timeout():
	$Timer.stop()
	get_tree().change_scene("res://stage_start.tscn")
	pass # Replace with function body.

func _on_strikefirst_timeout():
	var e = load('res://sound/effects/title.strikes.ogg')
	$efx.stream = e
	$efx.play()
	$strikef.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	$strikef2.queue_free()
	$efx.play()
	yield(get_tree().create_timer(0.7), "timeout")
	$strikeh.queue_free()
	$efx.play()
	yield(get_tree().create_timer(0.2), "timeout")
	$strikeh2.queue_free()
	$efx.play()
	yield(get_tree().create_timer(0.7), "timeout")
	$Tween.interpolate_property($strikenomercy, "rect_position", $strikenomercy.rect_position, Vector2(600, $strikenomercy.rect_position.y),0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	e = load('res://sound/effects/title.nomercy.ogg')
	$efx.stream = e
	$Tween.start()
	$efx.play()
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	$tween_pushstart.interpolate_property($push_start, "rect_position", $push_start.rect_position, Vector2(128, 221), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween_pushstart.start()
	sensible = true
	$t_pushstart.start()
	pass # Replace with function body.

func _on_t_pushstart_timeout():
	$push_start.visible = !$push_start.visible
	pass # Replace with function body.

func _on_tween_pushstart_tween_all_completed():
	rdy = true
	pass # Replace with function body.


func _on_to_credits_timeout():
	get_tree().change_scene(str("res://credits.tscn"))
	pass # Replace with function body.
