extends "res://scripts/stage_father.gd"

onready var d = []
onready var i = -1
onready var d_ready = false

func _ready():
	$YSort/player/Camera2D.current =false
	$Camera2D.current = true
	STAGE_TIMER = 99
	STAGE_NUMBER = ProjectSettings.get_setting("stage")
	if STAGE_NUMBER == null:
		STAGE_NUMBER = 8
	ProjectSettings.set_setting("stage", str(STAGE_NUMBER))
	$YSort/spawn_player.global_position = $YSort/spawn_player_stage.global_position
	stage_bg = preload('res://sound/loop1.ogg')
	$bgm.stream = stage_bg
	$bgm.play()
	NO_TIME_STAGE = true
	$YSort/player.queue_free()
	prepare_diags()

func prepare_diags():
	d.append({'psg': 'Johnny', 'd': 'There is one\nmore lesson I have\nto teach you!'})
	d.append({'psg': 'Johnny', 'd': 'You all have learnt\nto STRIKE FIRST\nbeing aggressive!'})
	d.append({'psg': 'Johnny', 'd': 'I tought you to\nSTRIKE HARD'})
	d.append({'psg': 'Johnny', 'd': 'Now the third rule\nof Cobra Kai.'})
	d.append({'psg': 'Johnny', 'd': 'NO MERCY'})
	d.append({'psg': 'Johnny', 'd': 'Life is\'nt fair.\nOne morning you\nwake up feeling great'})
	d.append({'psg': 'Johnny', 'd': 'Then life throws a\nspinning heel kick\nto your balls'})
	d.append({'psg': 'Johnny', 'd': 'You get an F on\na test. You get\nsuspended'})
	d.append({'psg': 'Johnny', 'd': 'You fall love with a girl.\nand some other dude\ncomes and steals her.'})
	d.append({'psg': 'Johnny', 'd': 'Cars get set on fire!'})
	d.append({'psg': 'Johnny', 'd': 'Just when you think\nthing are going good\neverything falls apart.'})
	d.append({'psg': 'Johnny', 'd': 'That\'s how it goes.\nLife shows no mercy.'})
	d.append({'psg': 'Johnny', 'd': 'So Neither do we.'})
	d.append({'psg': 'Johnny', 'd': 'We do whatever it takes\nto keep out heads above\nwater.'})
	d.append({'psg': 'Johnny', 'd': 'We do whatever it takes\nto moving forward.'})
	d.append({'psg': 'Johnny', 'd': 'We do whatever it takes\nto WIN!'})
	d.append({'psg': 'Johnny', 'd': 'Remember who you are\nYou\'re bad ass!\nyou don\'t give a shit'})
	d.append({'psg': 'Johnny', 'd': 'You kick ass.'})
	d.append({'psg': 'Johnny', 'd': 'You\'re Cobra Kai'})
	d.append({'psg': 'All', 'd': '** COBRA KAAAI **\n**YEEAH**'})
	d.append({'psg': 'Johnny', 'd': 'Pick up your things\nand kick the shit\nout of everybody.'})
	d.append({'psg': 'All', 'd': '**YEEAH**'})
	d_ready = true

func next_dialog():
	$GUI/cl/s.show()
	var face
	var speak
	var animation = 'default'
	if i < d.size():
		match d[i]['psg']:
			'Miguel':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
			'Johnny':
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
			'Hawk':
				face = load("res://asset/GUI/cobra/Hawk_mute.png")
				speak = load("res://animations/intro_gui_hawk.tres")
		$GUI/cl/s/m/hb/ccf/face.texture = face
		$GUI/cl/s/m/hb/ccf/face/speak.frames = speak
		$GUI/cl/s/m/hb/ccf/face/speak.animation = animation
		$GUI/cl/s/m/hb/ccf/face/speak.play()
		$GUI/cl/s/m/hb/cct/text.text = d[i]['d']
	else:
		go_to_stage()
	
func _input(event):
	if d_ready and  event.is_pressed():
		i += 1
		next_dialog()
	pass

func go_to_stage():
	var delta_px = 530
	var delta_time = 1
	$GUI/cl/s.hide()
	for a in $YSort.get_children():
		if a is AnimatedSprite:
			var c = a.global_position
			var f = Vector2(c.x + delta_px, c.y)
			$Tween.interpolate_property(a, "global_position", c, f, delta_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
			a.play('walk')
	var final_camera_offset = Vector2($Camera2D.offset.x + delta_px - 230, 0)
	$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, final_camera_offset, delta_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	for a in $YSort.get_children():
		if a is AnimatedSprite:
			a.play('stand')
