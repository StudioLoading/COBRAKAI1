extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
#	$Timer.start()
	var msg = ProjectSettings.get_setting("gameover_msg")
	$cc/h/t/AnimatedSprite.play()
	$Tween.interpolate_property($cc, "rect_global_position",  $cc.rect_global_position, Vector2($cc.rect_global_position.x, 0), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$bgm.play()
	pass # Replace with function body.

func _on_nosensei_timer_timeout():
	$bgm.stop()
	$bgm.stream=load("res://sound/title_justintro.ogg")
	$bgm.play()
	$cc/h/t.hide()
	$cc/h/v/defeat.hide()
	$Timer.start()
	pass # Replace with function body.

func _on_Timer_timeout():
	var stage_property = ProjectSettings.get_setting("stage")
	print('GAMEOVER: stage_property=', stage_property)
	if stage_property == null:
		stage_property = 1
	if 'boss' in str(stage_property):
		stage_property = stage_property.substr(0,1)
#	var stage_scene_name = str('res://stage', stage_property,'.tscn')
#	print('GAMEOVER loading scene named ', stage_scene_name)
	ProjectSettings.set_setting("stage", stage_property)
	ProjectSettings.set_setting("score", 0)
	ProjectSettings.set_setting("up", 2)
	get_tree().change_scene('res://stage_start.tscn')
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	yield(get_tree().create_timer(3), "timeout")
	$nosensei_timer.start()
	pass # Replace with function body.
