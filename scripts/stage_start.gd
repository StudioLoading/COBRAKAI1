extends Node2D

var stage
var stage_name
var life
var time
var score
var cover_final_position
var cobra_final_position
var ready


func _ready():
	stage = ProjectSettings.get_setting("stage")
	stage_name = ProjectSettings.get_setting("stage_name")
	life = ProjectSettings.get_setting("life")
	time = ProjectSettings.get_setting("time")
	score = ProjectSettings.get_setting("score")
	$c/vbc/hbc/stage_n.text = str(stage)
	$c/vbc/stage_title.text = str(stage_name)
	cover_final_position = Vector2(0,256)
	cobra_final_position = Vector2(158, 36)
	$cobra.rect_position = Vector2(158, 256)
	$cobra.hide()
	$c/cover.rect_position = Vector2(0, 55)
	$c/flash.hide()
	$bg.play()
	pass # Replace with function body.


func _on_delay_timeout():
	$Tween.interpolate_property($c/cover, "rect_position", $c/cover.rect_position, cover_final_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$delay.disconnect('timeout', self, '_on_delay_timeout')
	pass # Replace with function body.


func _on_Tween_tween_all_completed():
	#$c/cover.queue_free()
	$cobra.show()
	$Tween_cobra.interpolate_property($cobra, "rect_position", $cobra.rect_position, cobra_final_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween_cobra.start()
	pass # Replace with function body.


func _on_Tween_cobra_tween_all_completed():
	ready = true
	pass # Replace with function body.

func _input(event):
	if event.is_pressed() and ready:
		$c/flash.show()
		yield(get_tree().create_timer(0.1), "timeout")
		$c/flash.hide()
		yield(get_tree().create_timer(0.5), "timeout")
		$bg.stop()
		var stagescene_name = str("res://stage",stage,".tscn")
		var intro_stagescene_name = str("res://stage",stage,"_intro.tscn")
		var stagescene = load(stagescene_name)
		var intro_stagescene = load(intro_stagescene_name)
		if intro_stagescene != null:
			get_tree().change_scene(intro_stagescene_name)
		else:
			get_tree().change_scene(stagescene_name)
		
