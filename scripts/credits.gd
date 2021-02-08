extends Node2D

onready var inout = true
onready var idx = 0
onready var idx_max = 11

func _ready():
	$bgm.play()
	ProjectSettings.set_setting("stage", 1)
	pass

func _on_Timer_timeout():
	if inout:
		match idx:
			0:
				$ColorRect/hb/g/d.text = 'TITLE:'
				$ColorRect/hb/g/i.texture = load("res://asset/GUI/combo/cobrakai.png")
				$ColorRect/hb/g/t.text = 'COBRA KAI 1'
			1:
				$ColorRect/hb/g/d.text = 'DESCRIPTION:'
				$ColorRect/hb/g/i.texture = load("res://asset/GUI/controller/controller.png")
				$ColorRect/hb/g/t.text = 'THIS IS A FANGAME of\nTHE COBRA KAI SERIE\nSEASON 1 show.'
			2:
				$ColorRect/hb/g/d.text = 'A SPECIAL THANKS TO:'
				$ColorRect/hb/g/i.texture = load("res://asset/credits/dojo.group.png")
				$ColorRect/hb/g/t.text = 'COBRA KAI DOJO\noffical facebook group'
			3:
				$ColorRect/hb/g/d.text = 'THANKS TO:'
				$ColorRect/hb/g/i.texture = load("res://asset/credits/ckk.png")
				$ColorRect/hb/g/t.text = 'COBRA KAI KOMPANION podcast'
			4:
				$ColorRect/hb/g/d.text = 'THANKS TO:'
				$ColorRect/hb/g/i.texture = load("res://asset/stage1/homeless1.png")
				$ColorRect/hb/g/t.text = "Cobra Kai\'s Homeless Lynn\n\nFACEBOOK GROUP"
			5:
				$ColorRect/hb/g/d.text = 'THANKS TO:'
				$ColorRect/hb/g/i.texture = load("res://asset/tomcole/boba.png")
				$ColorRect/hb/g/t.text = "David Shatraw Fan Page\n& Tom Cole Spinoff Ideas\n\nFACEBOOK GROUP"
			6:
				$ColorRect/hb/g/d.text = 'ART:'
				$ColorRect/hb/g/i.texture = load("res://asset/stage4/hawk.png")
				$ColorRect/hb/g/t.text = "FRANCESCO BACCHELLI"
			7:
				$ColorRect/hb/g/d.text = 'LEVEL DESIGN:'
				$ColorRect/hb/g/i.texture = load("res://asset/stage4/dancers/skeleton/walk1.png")
				$ColorRect/hb/g/t.text = "FRANCESCO BACCHELLI"
			8:
				$ColorRect/hb/g/d.text = 'SOUND:'
				$ColorRect/hb/g/i.texture = load("res://asset/stage4/dancers/dj/02.png")
				$ColorRect/hb/g/t.text = "FRANCESCO BACCHELLI\nand\nANDREA MARCOMINI"
			9:
				$ColorRect/hb/g/d.text = 'CODE:'
				$ColorRect/hb/g/i.texture = load("res://asset/stage4/dimitri.png")
				$ColorRect/hb/g/t.text = "FRANCESCO BACCHELLI"
			10:
				$ColorRect/hb/g/d.text = 'THANKS FOR PLAYING:'
				$ColorRect/hb/g/i.texture = load("res://asset/stage4/dancers/kumiko_yellow/00.png")
				$ColorRect/hb/g/t.text = "FOLLOW \nCobra Kai Videogame\nFACEBOOK PAGE\nfor updates!"
			11:
				$ColorRect/hb/g/d.text = 'SHOUT OUT TO:'
				$ColorRect/hb/g/i.texture = load("res://asset/credits/BolognaNERD_minimal.png")
				$ColorRect/hb/g/t.text = "ASSOCIATION\nfor their precious support."
		$Tween.interpolate_property($s, "modulate", 
		  Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.5, 
		  Tween.TRANS_LINEAR, Tween.EASE_IN)
	else:
		$Tween.interpolate_property($s, "modulate", 
		  Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, 
		  Tween.TRANS_LINEAR, Tween.EASE_IN)
		idx += 1
	if idx > idx_max:
		idx = 0
	inout = !inout
	$Tween.start()
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("ui_start"):
		get_tree().change_scene(str("res://title.tscn"))
