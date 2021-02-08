extends AnimatedSprite

var steps = 220

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property(self, "position", self.position, position + (Vector2(steps, 0)), 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	self.animation='walk'
	self.play()
	$Tween.start()
	pass # Replace with function body.
	

func _on_Tween_tween_all_completed():
	if !self.flip_h:
		self.animation='stand-pr'
	$Timer.start()
	pass # Replace with function body.


func _on_Timer_timeout():
	steps *= -1
	$Tween.interpolate_property(self, "position", position, position + (Vector2(steps, 0)), 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	self.animation='walk'
	self.flip_h = !self.flip_h
	self.play()
	$Tween.start()
	pass # Replace with function body.

func pause_resume(pause, with_paused_menu):
	$Timer.paused = pause
