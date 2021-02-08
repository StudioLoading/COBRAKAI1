extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var maxy

# Called when the node enters the scene tree for the first time.
func _ready():
	applied_force = Vector2(0, -170)
	pass # Replace with function body.

func go_up(max_y):
	maxy = max_y
#	print('bobble goes up to ', max_y)
	$a.play()

func _physics_process(delta):
	if maxy:
		if global_position.y <= maxy:
			$a.animation='s'

func _on_a_animation_finished():
	if $a.animation=='s':
		queue_free()
	pass # Replace with function body.
