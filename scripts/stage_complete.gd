extends Node2D


var stage
var stage_name
var life
var time
var score

var stage_complete_string
var string_complete_idx

var stream_char_shown
var stream_weep
var stream_calc_completed

var ready 

func _ready():
	$cl/flash.hide()
	ready = false
	stage = ProjectSettings.get_setting("stage")
	stage_name = ProjectSettings.get_setting("stage_name")
	life = ProjectSettings.get_setting("life")
	time = ProjectSettings.get_setting("time")
	score = ProjectSettings.get_setting("score")
	if !stage :
		#start test
		stage = 1
		stage_name ='ACE DEGENERATE'
		life = 20
		time = 40
		score = 65
		#end test
	$cl/vbc/cc/point_grid.hide()
	$cl/vbc/stage.hide()
	$stage_complete_show.start()
	string_complete_idx = 0
	stage_complete_string = str(stage_name)
	stream_char_shown = load("res://sound/effects/lesss.ogg")
	stream_weep = load("res://sound/effects/fischio.ogg")
	stream_calc_completed = load("res://sound/effects/item_spawner_trigger.ogg")
	$efx.stream = stream_char_shown
	$cl/vbc/stage_n.text = str('STAGE ', str(stage))
	$bgm.play()
	pass


func _on_initial_wait_timeout():
	$cl/vbc/cc/point_grid.show()
	$calculation_time.start()
	pass # Replace with function body.


func _on_calculation_time_timeout():
	var t = int($cl/vbc/cc/point_grid/TIME_NN.text)
	if t < time:
		t += 1
		$cl/vbc/cc/point_grid/TIME_NN.text= str("%02d" % int(round(t)))
	else:
		$calculation_time.stop()
		$calculation_time.disconnect('timeout', self, '_on_calculation_time_timeout')
		$efx_step.stream = stream_calc_completed
		$efx_step.play()
		$calculation_life.start()

func _on_calculation_life_timeout():
	var l = int($cl/vbc/cc/point_grid/LIFE_NN.text)
	if l < life:
		l += 1
		$cl/vbc/cc/point_grid/LIFE_NN.text= str("%02d" % int(round(l)))
	else:
		var final_life_score = int($cl/vbc/cc/point_grid/LIFE_NN.text) * 10
		life = final_life_score
		$cl/vbc/cc/point_grid/LIFE_NN.text = str(final_life_score)
		$calculation_life.stop()
		$calculation_life.disconnect('timeout', self, '_on_calculation_life_timeout')
		$efx_step.stream = stream_calc_completed
		$efx_step.play()
		$calculation_hit.start()


func _on_calculation_hit_timeout():
	$cl/vbc/cc/point_grid/HIT_NN.text = str("%02d" % int(round(score)))
	$calculation_hit.stop()
	$calculation_hit.disconnect('timeout', self, '_on_calculation_hit_timeout')
	$cl/vbc/cc/point_grid/TOTAL_NN.text = str("%06d" % int(round(score+life+time)))
	ProjectSettings.set_setting("score", int(round(score+life+time)))
	ready = true


func _on_stage_complete_show_timeout():
	$cl/vbc/stage.show()
	string_complete_idx += 1
	var phraseLength = stage_complete_string.length()
	if string_complete_idx <= phraseLength:
		$cl/vbc/stage.text = stage_complete_string.substr(0, string_complete_idx)
	else:
		$cl/vbc/stage.text = stage_complete_string
		$stage_complete_show.stop()
		$stage_complete_show.disconnect('timeout', self, '_on_stage_complete_show_timeout')
		$initial_wait.start()
	string_complete_idx += 1
	pass # Replace with function body.


func _input(event):
	if event.is_pressed() and ready:
		$cl/flash.show()
		yield(get_tree().create_timer(0.1), "timeout")
		$cl/flash.hide()
		yield(get_tree().create_timer(0.5), "timeout")
		stage = ProjectSettings.get_setting("stage")
		print('STAGE_COMPLETE stage=', stage)
		if !stage:
			stage = 1
		elif 'boss' in str(stage):
			stage = stage.substr(0,1)
			stage = int(stage)
		if int(stage) < 8:
			ready = false
			stage = int(stage) + 1
			ProjectSettings.set_setting("stage", stage)
			match stage:
				2:
					ProjectSettings.set_setting('stage_name', "COBRA KAI DOJO")
				3:
					ProjectSettings.set_setting('stage_name', "LEARN TO KICK")
				4:
					ProjectSettings.set_setting('stage_name', "ESQUELETO")
				5:
					ProjectSettings.set_setting('stage_name', "FAIR FIGHT ?\nDREAM ON !")
				6:
					ProjectSettings.set_setting('stage_name', "LUNCH TIME")
				7:
					ProjectSettings.set_setting('stage_name', "HAWK")
				8:
					ProjectSettings.set_setting('stage_name', "LARUSSO")
				9:
					ProjectSettings.set_setting('stage_name', "CREDITS")
				10:
					ProjectSettings.set_setting('stage_name', "SENSEI")
			if stage == 8:
				get_tree().change_scene(str("res://credits.tscn"))
				return
#			else:
			$bgm.stream = stream_weep
			$bgm.connect("finished", self, "_on_bgm_finished")
			$bgm.play()
			get_tree().change_scene(str("res://stage_start.tscn"))
	pass # Replace with function body.
