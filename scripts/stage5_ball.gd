extends RigidBody2D

onready var dodge_dir

func _ready():
	$efx.stream = load("res://sound/effects/lesss.ogg")
	$efx.play()

func _on_Timer_timeout():
	self.queue_free()
	pass # Replace with function body.

func config(d):
#	print('setting dodge_dir to ', d)
	self.dodge_dir = d

func get_dodge():
	return self.dodge_dir


func _on_Timer2_timeout():
	$AnimatedSprite.play('default')
	pass # Replace with function body.
