extends RigidBody2D

enum TYPES {LIFE, COMBO, TIME, SCORE, HP, COMBO}
var item 
signal picked_up
var psg : KinematicBody2D


func _ready():
	$label.hide()
	pass # Replace with function body.

func config(psg, item):
	if psg == null || item == null:
		print('item: configuro item senza psg o item assegnato, lo elimino subito')
		self.queue_free()
		return
	var texture
	var label
	var efx_track = load("res://sound/effects/picked.ogg")
#	print('genero item ', item,' per player di nome ', psg.PSGNAME)
	match item:
		TYPES.LIFE:
			texture = load(str('res://asset/GUI/',psg.DOJO,'/life_', psg.PSGNAME,'.png'))
			label = load ('res://asset/GUI/life.label.png')
		TYPES.HP:
			texture = load(str('res://asset/GUI/',psg.DOJO,'/hp_', psg.PSGNAME,'.png'))
			label = load ('res://asset/GUI/hp.label.png')
		TYPES.COMBO:
			texture = load('res://asset/GUI/combo/combo.item.png')
		TYPES.TIME:
			texture = load('res://asset/GUI/item.time.png')
			label = load ('res://asset/GUI/time.label.png')
			efx_track = load("res://sound/effects/item_time.ogg")
		TYPES.SCORE:
			texture = load('res://asset/GUI/item.score.png')
			label = load ('res://asset/GUI/score.label.png')
	$Sprite.texture = texture
	$label.texture = label
	self.item = item
	self.psg = psg
	$efx.stream = efx_track

func _on_pick_area_entered(area):
	if area.get_parent() and area.get_parent().is_in_group('player'):
#		print('item picked up !!!')
		$efx.play()
		$label.show()
		emit_signal('picked_up', self.item)
		$Sprite.hide()
	pass # Replace with function body.


func _on_efx_finished():
	print('ITEM _on_efx_finished')
	#$label.hide()
	self.queue_free()
	pass # Replace with function body.
