extends Node2D

onready var sensible = false

onready var wrong = preload("res://sound/effects/wrong.ogg")
onready var shifting = preload("res://sound/effects/dash_chair.ogg")

onready var distance = 150
onready var kick_counter = 0
onready var kick_max = 1

onready var moving = false

func _redy():
	shifting.loop_mode=0

func kicked(act, _breaths):
	if 'kick' in act and sensible:
		if kick_counter < kick_max:
			$puff.frame=0
			$puff.play()
			var stage = self.get_parent().get_parent()
#			print(self.name, ' kicked')
			if stage != null:
				var pPosX = stage.get_player_global_position().x
				$AnimatedSprite.play('bilico')
				if pPosX <= self.global_position.x:
					$AnimatedSprite.flip_h = false
					$Tween.interpolate_property(self, "global_position", self.global_position, self.global_position + Vector2(distance,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				else:
					$AnimatedSprite.flip_h = true
					$puff.position.x *= -1
					$Tween.interpolate_property(self, "global_position", self.global_position, self.global_position - Vector2(distance,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$efx.stream = shifting
				moving = true
				$Tween.start()
				kick_counter += 1
		else :
			$efx.stream = wrong
			sensible = false
			$AnimatedSprite.play('broken')
			return
		$efx.play()
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
#	print('sedia tween completed')
	moving = false
	$efx.stop()
	$AnimatedSprite.play('default')
	pass # Replace with function body.


func _on_kick_area_entered(area):
	if 'kick' in area.name and !sensible:
#		print(self.name, ' kick area entered ', area.name)
		sensible = true
	pass # Replace with function body.


func _on_kick_area_exited(area):
	if 'kick' in area.name and sensible:
#		print(self.name, ' kick area exited ', area.name)
		sensible = false
	pass # Replace with function body.
