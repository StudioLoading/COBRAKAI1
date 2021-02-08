extends "res://scripts/stage_father.gd"
onready var ready = false
onready var d = []
onready var i = 0
onready var roba_perterra = preload("res://asset/stage6/roba_perterra.png")
onready var efx_roba_perterra = preload("res://sound/effects/boss_glass_broken.ogg")
onready var bg = preload("res://sound/title_new.ogg")

func _ready():
	STAGE_TIMER = 69
	STAGE_NUMBER = 6
	ProjectSettings.set_setting("stage", STAGE_NUMBER)
	$YSort/miguel.hide()
	$GUI/enemy.hide()
	$GUI/cl/s.hide()
	rng.randomize()
	stage_bg = preload('res://sound/stage6.ogg')
	$bgm.stream = stage_bg
	$bgm.play()
	$YSort/player/Camera2D.current = false
	$YSort/player.queue_free()
	$Camera2D.current = true
	var final_pos = Vector2($YSort/sam.global_position.x - 256, 0)
	yield(get_tree().create_timer(1.5), "timeout")
	$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, $Camera2D.offset + final_pos, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	prepare_diag()
	
func prepare_diag():
	var d0 = {'psg': 'sam', 'd': 'why are you\nspreading lies\nabout me ?'}
	var d1 = {'psg': 'ky', 'd': 'We saw a movie\nor maybe I saw\nmore than you did.'}
	var d2 = {'psg': 'ky', 'd': 'You know that\nbillboard with a big\ndick on it?'}
	var d3 = {'psg': 'ky', 'd': 'I guess you\ntake after your\ndad.'}
	var d4 = {'psg': 'sam_swish', 'd': '...'}
	var d5 = {'psg': 'miguel_view', 'd': 'Hey Kyler!'}
	var d6 = {'psg': 'miguel', 'd': 'Why don\'t you\nstop being such\nan asshole.'}
	var d7 = {'psg': 'ky', 'd': 'You want\nanother beat rea?'}
	var d8 = {'psg': 'ky', 'd': 'Your lame ass\nkarate won\'t save you\nthis time.'}
	var d9 = {'psg': 'miguel', 'd': 'It\'s not lame ass\nkarate...'}
	var d10 = {'psg': 'miguel', 'd': 'It\'s COBRA KAI!'}
	d.append(d0)
	d.append(d1)
	d.append(d2)
	d.append(d3)
	d.append(d4)
	d.append(d5)
	d.append(d6)
	d.append(d7)
	d.append(d8)
	d.append(d9)
	d.append(d10)
	
	$GUI/cl/s.show()
	var face
	var speak
	var animation = 'default'
	while i < d.size():
		match d[i]['psg']:
			'miguel', 'miguel_view':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
			'ky':
				face = load("res://asset/GUI/highschool/ky_mute.png")
				speak = load("res://animations/intro_gui_ky.tres")
		$GUI/cl/s/m/hb/ccf/face.texture = face
		$GUI/cl/s/m/hb/ccf/face/speak.frames = speak
		$GUI/cl/s/m/hb/ccf/face/speak.animation = animation
		$GUI/cl/s/m/hb/ccf/face/speak.play()
		$GUI/cl/s/m/hb/cct/text.text = d[i]['d']
		if d[i]['psg'] == 'sam_swish':
			print('show swishing table')
			$YSort/sam.play('swish')
			var final_pos = $YSort/tavolo_rettangolare07/Sprite/posto_a_tavola05.global_position
			final_pos.y = final_pos.y - 16
			final_pos.x = final_pos.x - 2
			$Tween.interpolate_property($YSort/tavolo_rettangolare07/Sprite/posto_a_tavola05, "global_position", $YSort/tavolo_rettangolare07/Sprite/posto_a_tavola05.global_position, final_pos, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			$efx.stream = efx_roba_perterra
			$efx.play()
			yield($Tween, "tween_all_completed")
			$YSort/tavolo_rettangolare07/Sprite/posto_a_tavola05.texture = roba_perterra
		if d[i]['psg'] == 'miguel_view':
			$bgm.stream = bg
			$bgm.play()
			$YSort/miguel.show()
			$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2.ZERO, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
#			yield($Tween, "tween_all_completed")
		if i == 7:
			$YSort/kyler.flip_h = true
			$YSort/kyler.play('walk')
			$Tween.interpolate_property($YSort/kyler, "global_position", $YSort/kyler.global_position, $YSort/miguel.global_position, 20, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		i+=1
		yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene("res://stage6.tscn")
	

	pass
