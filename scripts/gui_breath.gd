extends HBoxContainer

signal out_of_breath

onready var is_out_of_breath = false
onready var texture_full = preload("res://asset/GUI/breath.bar_azure_bit.png")
onready var texture_empty = preload("res://asset/GUI/breath.bar_empty_bit.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	$breath.value = $breath.max_value
	update_bar(0)
	pass # Replace with function body.

func update_bar(n):
#	print('gui_breath update bar ', n,' over current value ', $breath.value)
	$breath.value += n
	if $breath.value <= 0:
		if !is_out_of_breath:
			emit_signal('out_of_breath')
			is_out_of_breath = true
	if $breath.value > $breath.max_value:
		$breath.value = $breath.max_value
	else:
		var v = $breath.value
		var c = $h.get_child_count()
		var tacca = float($breath.max_value / c)
		var idx = 0
		for l in c:
			var i = tacca * l
			if $breath.value >= i and i < $breath.max_value:
				 $h.get_child(idx).texture = texture_full
			else:#yield(get_tree().create_timer(0.1), "timeout")
				$h.get_child(idx).texture = texture_empty
			idx += 1
	return $breath.value

func reset_bar():
#	$breath.value = $breath.max_value
#	print('gui_breath reset_bar')
	update_bar($breath.max_value)
	is_out_of_breath = false
	
func breath_plusone():
	var updated = update_bar(1)
	return updated

func breath_plus_n(n):
	var updated = update_bar(n)
	return updated

func get_breath():
	return $breath.value
