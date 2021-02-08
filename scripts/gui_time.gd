extends VBoxContainer

var stage_time_left
var blinking = false
signal timing_out
signal timing_in
signal stage_timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_stage_timer_timeout():
	stage_time_left -= 1
	$nn.text = str("%02d" % int(round(stage_time_left)))
	if stage_time_left <= 20:
		if blinking == false:
			blinking = true
			emit_signal('timing_out')
		$nn.hide()
		yield(get_tree().create_timer(0.1), "timeout")
		$nn.show()
		yield(get_tree().create_timer(0.1), "timeout")
		$nn.hide()
		yield(get_tree().create_timer(0.1), "timeout")
		$nn.show()
		yield(get_tree().create_timer(0.1), "timeout")
		$nn.hide()
		yield(get_tree().create_timer(0.1), "timeout")
		$nn.show()
	else:
		if blinking == true:
			emit_signal('timing_in')
		blinking = false
	if stage_time_left <= 0:
		$efx.stream = load("res://sound/effects/defeat.ogg")
		$efx.play()
		$stage_timer.paused=true
		$blink.start()
		emit_signal('stage_timeout')
	pass


func _on_blink_timeout():
	$nn.visible = !$nn.visible
	pass # Replace with function body.
	
func pause_resume(paused, with_paused_menu):
	$stage_timer.paused = paused
	$efx.playing = !paused
