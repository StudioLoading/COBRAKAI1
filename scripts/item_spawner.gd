extends StaticBody2D

onready var breaks_with_enemies = false
onready var sensible = false
onready var spawned = false
onready var item_scene = preload("res://item.tscn")
onready var diag_scene = preload("res://gui_dialog.tscn")
onready var diags_scene_instance 
enum TYPES {LIFE, TIME, SCORE, HP, COMBO, DIAG}
var type
var player
onready var item_or_dialog = true
onready var spawner_name
onready var showin_diag = false

func _ready():
	$s.frames = preload("res://animations/item_spawner_cestino.tres")
	$s.animation = 'default'
	pass

func config(t, a, p, item_or_dialog, breaks_with_enemies, ds):
	self.type = t
	$s.frames = load(str('res://animations/item_spawner_', a, '.tres'))
	self.diags_scene_instance = ds
	if a in diags_scene_instance.SPAWNERS:
		self.spawner_name = a
	self.player = p
	self.item_or_dialog = item_or_dialog
	self.breaks_with_enemies = breaks_with_enemies
	$s.play('default')
	

func _on_jab_area_area_entered(area):
	if area.name == 'hit' and area.get_parent().get_parent().is_in_group('player') and !showin_diag:
#		print('player jab area entered')
		sensible = true
	pass # Replace with function body.


func _on_jab_area_area_exited(area):
	if area.name == 'hit' and area.get_parent().get_parent().is_in_group('player') and !showin_diag:
#		print('player jab area exited')
		sensible = false
	pass # Replace with function body.

func hit(action):
#	print('item_spawner hit by ', action, ' sensible?', sensible)
	if action == 'jab' and sensible and !showin_diag:
#		print('item got hit')
		if item_or_dialog:
			spawn_item()
		else:
			spawn_diag()

func _on_jab_area_body_entered(body):
	if item_or_dialog:
		if body.is_in_group('group_enemies') and breaks_with_enemies:
			print('enemy ', body.PSGNAME, ' entering the jab_area of this spawner. Enemy status=', body.status)
			if body.status in [body.STATES.GOING_BACK, body.STATES.PLAYING_KO, body.STATES.IS_HIT]:
				$efx.stream = load("res://sound/effects/collision_car.ogg")
				$efx.play()
				spawn_item()
#		if body.is_in_group('player'):
#			spawn_item()
	pass # Replace with function body.

func spawn_item():
	if self.spawned:
		return
	self.spawned = true
	$s.animation='broken'
	yield(get_tree().create_timer(0.3), "timeout")
	$efx.stream = load("res://sound/effects/item_spawner_trigger.ogg")
	$efx.play()
	var b_instance = item_scene.instance()
	match type: #LIFE, COMBO, TIME, SCORE
		TYPES.LIFE:
			b_instance.config(player,b_instance.TYPES.LIFE)
		TYPES.TIME:
			b_instance.config(player,b_instance.TYPES.TIME)
		TYPES.SCORE:
			b_instance.config(player,b_instance.TYPES.SCORE)
		TYPES.HP:
			b_instance.config(player,b_instance.TYPES.HP)
		TYPES.COMBO:
			b_instance.config(player,b_instance.TYPES.COMBO)
	b_instance.connect('picked_up', get_parent().get_parent().get_node("GUI/player"), 'item_picked_up')
	$p.add_child(b_instance)

func _on_base_area_body_entered(body):
	_on_jab_area_body_entered(body)
	pass # Replace with function body.
	
func spawn_diag():
	showin_diag = true
	var d_instance = diag_scene.instance()
	self.add_child(d_instance)
	var d
	var stage_number = ProjectSettings.get_setting("stage")
	if stage_number == null:
		stage_number = 1
	var d_spawner = null
	if self.spawner_name in diags_scene_instance.diags_spawned:
		d_spawner = diags_scene_instance.diags_spawned[self.spawner_name]
	else:
		print(self.spawner_name, ' not found in diags_spawned dictionary')
		return
	if d_spawner == null:
		print('item_spawner : spawn_diag() spawner_name=', self.spawner_name, ' without diags')
		return
	else:
		d = d_spawner[str('stage', stage_number)]
	if d == null or d['diags'] == null or d['diags'].size() == 0:
		print('dialog for ', self.spawner_name,' on stage ', stage_number,' not found.')
		return
	self.player.pause_resume(false)
	var i = 0
	var diags_to_show = []
#	print('achieved? ', d)
	if d['achieved'] == true:
#		print(self.spawner_name,' ready to show achieved_diags ', d['achieved_diags'].size(), ' long')
		diags_to_show += d['achieved_diags']
#		print(self.spawner_name,' spawned already ? ',self.spawned,', type=', self.type)
		if !self.spawned and self.type != TYPES.DIAG:
#			print('plus achieved_diags ', d['achieved_notyetspawned_diags'].size())
			diags_to_show += d['achieved_notyetspawned_diags']
	else:
#		print('item_spawner ', self.spawner_name,' ready to show a diags ', d['diags'].size(), ' long')
		diags_to_show = d['diags']
	while i < diags_to_show.size():
		var animation = 'default'
		var face
		var speak
		match self.spawner_name:
			'rj':
				face = load("res://asset/GUI/real/RJ_mute.png")
				speak = load("res://animations/rj_gui_rj.tres")
			'bri':
				face = load("res://asset/GUI/real/bri_mute.png")
				speak = load("res://animations/intro_gui_bri.tres")
			'miguel':
				face = load("res://asset/GUI/cobra/Miguel_mute.png")
				speak = load("res://animations/intro_gui_miguel.tres")
			'johnny':
				face = load("res://asset/GUI/cobra/Johnny_mute.png")
				speak = load("res://animations/intro_gui_johnny.tres")
			'peter':
				face = load("res://asset/GUI/real/peter_mute.png")
				speak = load("res://animations/intro_gui_peter.tres")
			'philippe':
				face = load("res://asset/GUI/real/Philippe_mute.png")
				speak = load("res://animations/Philippe_gui.tres")
			'dimitri':
				face = load("res://asset/GUI/miyagi/dimitri_mute.png")
				speak = load("res://animations/Dimitri_gui.tres")
		d_instance.get_node('s/m/hb/ccf/face').texture = face
		d_instance.get_node('s/m/hb/ccf/face/speak').frames = speak
		d_instance.get_node('s/m/hb/ccf/face/speak').animation = animation
		d_instance.get_node('s/m/hb/ccf/face/speak').play()
		d_instance.get_node('s/m/hb/cct/text').text = diags_to_show[i]
#		print('item_spawner diag shown ', i)
		i+=1
		yield(get_tree().create_timer(2), "timeout")
	d_instance.queue_free()
	self.player.pause_resume(false)
	var achieved_to_name = str(d['achieved_to'])
	if achieved_to_name != null and achieved_to_name != '':
		diags_scene_instance.diags_spawned[achieved_to_name][str('stage', stage_number)]['achieved'] = true
#	print('setting achieved_to achieved flag ', diags_scene_instance.diags_spawned[achieved_to_name][str('stage', stage_number)])
	showin_diag = false
	if self.type != TYPES.DIAG and d['achieved']:
		spawn_item()
	pass
