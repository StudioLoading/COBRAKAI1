extends "res://scripts/stage_father.gd"

onready var ready = false
onready var d = []
onready var i = 0
onready var miguel_skel_anim = preload("res://animations/Miguel_skel.tres")

func _ready():
	STAGE_TIMER = 69
	STAGE_NUMBER = 4
	ProjectSettings.set_setting("stage", STAGE_NUMBER)	
	$GUI/enemy.hide()
	$GUI/cl/s.hide()
	rng.randomize()
	stage_bg = preload('res://sound/stage1.ogg')
	$bgm.stream = stage_bg
	$bgm.play()
#	init_player()
	$YSort/player.queue_free()
	$YSort/player/Camera2D.current = false
	$Camera2D.current = true
	$YSort/miguel.play('walk')
	$YSort/johnny.play('stand')
	var final_pos = Vector2($YSort/johnny.global_position.x + 24, $YSort/johnny.global_position.y-5)
	$Tween.interpolate_property($YSort/miguel, "global_position", $YSort/miguel.global_position, final_pos, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$YSort/miguel.play('guard')
	$YSort/miguel.flip_h = true
	prepare_diag()
	
func prepare_diag():
	var d0 = {'psg': 'johnny', 'd': 'Pick up your\ncostume.'}
	var d1 = {'psg': 'johnny', 'd': 'I drive to\nyour school\nand try'}
	var d2 = {'psg': 'johnny', 'd': 'to pick up\nsome more students'}
	var d3 = {'psg': 'miguel', 'd': 'My costume is bad...'}
	var d4 = {'psg': 'johnny', 'd': 'and we have\na reputation to\nuphold.'}
	var d5 = {'psg': 'johnny', 'd': 'Use this!'}
	var d6 = {'psg': 'miguel_costume', 'd': ''}
	d.append(d0)
	d.append(d1)
	d.append(d2)
	d.append(d3)
	d.append(d4)
	d.append(d5)
	d.append(d6)
	next_dialog()

func next_dialog():
	$GUI/cl/s.show()
	var face
	var speak
	var animation = 'default'
	while i < d.size():
		match d[i]['psg']:
			'miguel':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
			'johnny':
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
		$GUI/cl/s/m/hb/ccf/face.texture = face
		$GUI/cl/s/m/hb/ccf/face/speak.frames = speak
		$GUI/cl/s/m/hb/ccf/face/speak.animation = animation
		$GUI/cl/s/m/hb/ccf/face/speak.play()
		$GUI/cl/s/m/hb/cct/text.text = d[i]['d']
		i+=1
		if i == d.size():
			$bgm.stop()
			$efx.stream = load("res://sound/effects/laugh.ogg")
			$efx.play()
			yield(get_tree().create_timer(1.5), "timeout")
			$YSort/miguel.frames = miguel_skel_anim
			$YSort/miguel.play('guard')
			$efx.stop()
		yield(get_tree().create_timer(3), "timeout")
	$YSort/johnny.flip_h= true
	$YSort/johnny.play('walk')
	$YSort/miguel.play('walk')
	$Tween.interpolate_property($YSort/miguel, "global_position", $YSort/miguel.global_position, $env/exit.global_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($YSort/johnny, "global_position", $YSort/johnny.global_position, $env/exit.global_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	get_tree().change_scene("res://stage4.tscn")
	

