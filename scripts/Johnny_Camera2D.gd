extends Camera2D

onready var timer : Timer = $timer

export var amplitude : = 3.5
export var duration : = 0.3 setget set_duration
export(float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake

var enabled : = false

export onready var initial_camera_offset = Vector2(0, -24)


func _ready() -> void:
	randomize()
	set_process(false)
	self.duration = duration
	connect_to_shakers()


func _process(delta: float) -> void:
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	offset = initial_camera_offset+Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)


func _on_timer_timeout():
	self.shake = false
	

func _on_camera_shake_requested() -> void:
#	print('Johnny_Camera: shake requested')
	if not enabled:
		return
	self.shake = true


func set_duration(value: float) -> void:
	duration = value
	timer.wait_time = duration


func set_shake(value: bool) -> void:
	shake = value
	set_process(shake)
	offset = initial_camera_offset
	if shake:
		timer.start()


func connect_to_shakers() -> void:
	for camera_shaker in get_tree().get_nodes_in_group("camera_shaker"):
		camera_shaker.connect("camera_shake_requested", self, "_on_camera_shake_requested")

func pause_resume(paused, with_paused_menu):
#	print('pausing? ', paused)
	pass
