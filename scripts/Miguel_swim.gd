extends Area2D

onready var time = 1
onready var step = 0
onready var ohm = Vector2.DOWN
onready var final_step = 3
onready var final_time = 4
onready var initial_y_pos = 15

onready var bobble_scene = preload('res://stage3_bobble.tscn')

var surface_global_y
onready var BREATH_DECREASE = -6
signal decrease_breath
signal reset_breath

signal update_times

onready var splashino = preload("res://sound/effects/splashino.ogg")
onready var WATER_SURFACE_Y = 8

func _ready():
	self.position.y = initial_y_pos
	set_process_input(false)
	$Tween.interpolate_property(self, "position", position, Vector2(0,30), 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$a.animation='swim'
	$a.play()
	pass # Replace with function body.

func _input(event):
	if event.is_pressed() and (event.is_action_pressed("ui_kick") or event.is_action_pressed("ui_up")):
		if self.position.y > WATER_SURFACE_Y:
			var pos_y = self.position.y
			self.position.y -= 1
			if $a.animation != 'swim':
				$a.animation='swim'
		else:
#			print(self.position.y, ' emit signal breath reset Miguel_swim resetting breath')
			emit_signal('reset_breath')
			if time < final_time:
				if step < final_step:
					print(step, ' step completed')
					step += 1
					set_process_input(false)
					$a.animation='hit'
					$efx.stream = splashino
					$efx.play()
					$Tween.interpolate_property(self, "position", position, Vector2(0,15 * (step+1)), 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					$Tween.start()
				if step >= final_step:
						print(time, ' time completed')
						time += 1
						emit_signal('update_times', time)
						if time != final_time:
							step = 0


func _on_gravity_timeout():
	if step > 0:
		self.position.y += step*1.1
	else:
		self.position.y += 1.1
	if !$Tween.is_active():
		if self.position.y > WATER_SURFACE_Y:
#			print(self.position.y, ' emit signal breath decrese')
			var b = bobble_scene.instance()
			$bobble.add_child(b)
			b.go_up(surface_global_y)
			emit_signal('decrease_breath', BREATH_DECREASE)
		else:
			emit_signal('reset_breath')
	pass # Replace with function body.


func _on_Tween_tween_all_completed():
	set_process_input(true)
	emit_signal('reset_breath')
	$gravity.start()
	pass # Replace with function body.

func out_of_breath():
	print('OUT OF BREATH! repeat!')
	if time < final_time:
		time = 0
	set_process_input(false)
	emit_signal('update_times', time)
	$Tween.interpolate_property(self, "position", position, Vector2(position.x, initial_y_pos-5), 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


