extends Control

var stage
var stage_name
var life
var time
var total_score
var stage_score
var combo_unlocked
var up
var texture_logo_normal
var texture_logo_hit

onready var selected_combo = 0
signal selected_combo_s
signal gameover

var player

onready var dir = preload("res://asset/GUI/controller/dir.png")
onready var dir_pressed = preload("res://asset/GUI/controller/dir.pressed.png")

onready var btn = preload("res://asset/GUI/controller/btn.png")
onready var btn_pressed = preload("res://asset/GUI/controller/btn.pressed.png")

onready var efx_powerup = preload("res://sound/effects/powerup.ogg")

onready var hp_full = preload("res://asset/GUI/hp.png")
onready var hp_empty = preload("res://asset/GUI/hp.empty.png")

onready var btn_punch = preload("res://asset/GUI/combo/btn.punch_o.png")
onready var btn_punch_pressed = preload("res://asset/GUI/combo/btn.punch.png")
onready var btn_kick = preload("res://asset/GUI/combo/btn.kick_o.png")
onready var btn_kick_pressed = preload("res://asset/GUI/combo/btn.kick.png")
onready var btn_up = preload("res://asset/GUI/combo/btn.up_o.png")
onready var btn_up_pressed = preload("res://asset/GUI/combo/btn.up.png")
onready var btn_down = preload("res://asset/GUI/combo/btn.down_o.png")
onready var btn_down_pressed = preload("res://asset/GUI/combo/btn.down.png")


func _ready():
	self.stage = ProjectSettings.get_setting("stage")
	self.stage_name = ProjectSettings.get_setting("stage_name")
	self.life = ProjectSettings.get_setting("life")
	self.time = ProjectSettings.get_setting("time")
	self.total_score = ProjectSettings.get_setting("score")
	self.up = ProjectSettings.get_setting('up')
	self.stage_score = 0
	if total_score == null:
		total_score = 0
		ProjectSettings.set_setting('score', total_score)
		add_score(0)
	if up == null:
		up = 5
		ProjectSettings.set_setting('up', up)
	update_score()
	selected_combo = -1
	combo_unlocked = ProjectSettings.get_setting('combo_unlocked')
	if combo_unlocked == null:
		combo_unlocked = [true, true, false, false, false]
		ProjectSettings.set_setting('combo_unlocked', combo_unlocked)
#	$h_down/c/t/btns.hide()
#	$f.hide()
	pass # Replace with function body.

func config(psg, stage_timer, no_time_stage):
#	print('player configuring start')
	self.player = psg
	$h_up/player_logo.texture = load(str('res://asset/GUI/', psg.DOJO,'/logo.png'))
	$h_up/score_life/life/grid/beerxn.text = str("%02d" % int(ProjectSettings.get_setting('up')))
	texture_logo_normal = load(str('res://asset/GUI/',psg.DOJO,'/','logo.png'))
	texture_logo_hit = load(str('res://asset/GUI/',psg.DOJO,'/', 'logo_hit.png'))
	$h_up/player_logo/face.texture = load(str('res://asset/GUI/',psg.DOJO,'/', psg.PSGNAME,'_normal.png'))
	update_lifes()
	update_gui(psg.HP, psg.HP_MAX)
	update_combo()
	$f.reset_bar()
	self.connect('selected_combo_s', psg, 'selected_combo')
	emit_signal('selected_combo_s', selected_combo)
	if no_time_stage:
		$time.queue_free()
	else:
		$time.hide()
		$time.stage_time_left = stage_timer
		$time/stage_timer.paused = false
		$time/stage_timer.start()
		$time.connect('stage_timeout', self, 'on_stage_timeout')
		$time/nn.hide()
		$time/nn.text = str(stage_timer)
		$time/nn.show()
		$time.show()

func on_stage_timeout():
	print('gui_player:on_stage_timeout()')
	player.on_stage_timeout()
	emit_signal('stage_timeout')

func add_score(s):
	stage_score += s
	update_score()

func get_score():
	return int(round(total_score+stage_score))

func get_time():
	if get_node('time'):
		return int(round($time.stage_time_left))
	else:
		return 0

func blink_lifes():
	var i = 0
	while i < 3:
		var beerxn = $h_up/score_life/life/grid/beerxn.text
		$h_up/score_life/life/grid/beerxn.text = '__'
		yield(get_tree().create_timer(0.2), "timeout")
		$h_up/score_life/life/grid/beerxn.text = beerxn
		yield(get_tree().create_timer(0.15), "timeout")
		i+=1

func player_been_hit(player_hp, player_hp_max):
	blink_player_face()
	update_gui(player_hp, player_hp_max)

func update_score():
	$h_up/score_life/life/grid/score_points.text=str("%07d" % int(round(total_score+stage_score)))

func update_gui(player_hp, player_hp_max):
	var c = $h_up/score_life/life/grid/hp.get_child_count()
	var tacca = float(player_hp_max / c)
	print('GUI aggiorno vita player ', player_hp, '/', player_hp_max, '. Numero tacche ', c, '. tacca vale ', tacca)
	if player_hp <= 0:
		self.stage_score = 0
		update_score()
		decrease_up()
	if player_hp < tacca and player_hp > 0:
		$h_up/score_life/life/grid/hp.get_child(0).texture = hp_full
	else:
		var idx = 0
		for l in c:
			var i = tacca * l
			if player_hp >= i and i < player_hp_max:
				if $h_up/score_life/life/grid/hp.get_child(idx).texture == hp_empty:
					$efx.stream = efx_powerup
					$efx.play()
					yield(get_tree().create_timer(0.1), "timeout")
				$h_up/score_life/life/grid/hp.get_child(idx).texture = hp_full
			else:
#				yield(get_tree().create_timer(0.05), "timeout")
				$h_up/score_life/life/grid/hp.get_child(idx).texture = hp_empty
			idx+=1

func blink_player_face():
	$h_up/player_logo.texture = texture_logo_hit
	yield(get_tree().create_timer(0.4), "timeout")
	$h_up/player_logo.texture = texture_logo_normal
	
func add_up():
	var lifes = int(ProjectSettings.get_setting('up'))
	lifes += 1
	ProjectSettings.set_setting('up', lifes)
	update_lifes()
	blink_lifes()

func decrease_up():
	var lifes = get_lifes()
	lifes -= 1
	print('gui_player decrease up to ', lifes)
	ProjectSettings.set_setting('up', lifes)
	if lifes < 0:
		emit_signal('gameover')
	else:
		update_lifes()

func update_lifes():
	var lifes = int(ProjectSettings.get_setting('up'))
	$h_up/score_life/life/grid/beerxn.text = str("%02d" % int(round(lifes)))

func get_lifes():
	return int(ProjectSettings.get_setting('up'))
	
func _on_select():
	clean_combo_btns()
	var number_selectable_combo =  $h_down/c/c.get_children().size()
	selected_combo = (selected_combo+ 1)%number_selectable_combo
#	print('gui_player on_select() ',selected_combo)
	$h_down/cursor.rect_global_position = $h_down/c/c.get_child(selected_combo).get_node("p").global_position
	var btns_to_show =  self.player.combo[selected_combo]
	var unlocked = self.player.combo_unlocked[selected_combo]
#	print('btns_to_show: ', btns_to_show)
	var idx = 0
	if unlocked :
		for b in btns_to_show:
			var texture = load_texture_from_btn(b, false)
			$h_down/c/btns.get_child(idx).texture = texture
			$h_down/c/btns.get_child(idx).show()
			idx+=1
	$h_down/c/btns.show()
	$efx.stream = load('res://sound/effects/combo_picked.ogg')
	$efx.play()
	emit_signal('selected_combo_s', selected_combo)
	
func load_texture_from_btn(b, pressed):
	var result = null
	match b:
		'jab':
			result = btn_punch_pressed if pressed else btn_punch
		'kick':
			result = btn_kick_pressed if pressed else btn_kick
		'up':
			result = btn_up_pressed if pressed else btn_up
		'down':
			result = btn_down_pressed if pressed else btn_down
	return result
	
func add_combo():
	var i = 0
	var combo_unlocked = ProjectSettings.get_setting('combo_unlocked')
	for c in combo_unlocked:
		if c == false:
			combo_unlocked[i] = true
			ProjectSettings.set_setting('combo_unlocked', combo_unlocked)
			update_combo()
			return
		i+=1

func update_combo():
	self.player.reload_combo_unlocked()
	var i = 0
	if self.player:
		for c in self.player.combo_unlocked:
			if c:
				var combostring = str('combo',i)
				var postring = str(combostring,'/p')
				$h_down/c/c.get_node(combostring).texture = load(str("res://asset/GUI/combo/combo.",str(i+1),".png"))
				$h_down/c/c.get_node(postring).show()
			i+=1
	clean_combo_btns()
	_on_select()

func clean_combo_btns():
	var btns_to_show =  self.player.combo[selected_combo]
#	print('btns_to_show: ', btns_to_show)
	var idx = 0
	for b in btns_to_show:
		var texture = load_texture_from_btn(b, false)
		$h_down/c/btns.get_child(idx).texture = texture
		$h_down/c/btns.get_child(idx).show()
		idx+=1
	$h_down/c/btns.show()

func add_time():#dovrei usare la scena gui_time
	$time.stage_time_left += 30

func item_picked_up(item):
	var item_scene = preload("res://item.tscn")
	var instance = item_scene.instance()
	print('item picked up: ', instance.TYPES.keys()[item])
	match item:
		instance.TYPES.LIFE:
			add_up()
		instance.TYPES.HP:
			player.HP = player.HP_MAX
			update_gui(player.HP, player.HP_MAX)
		instance.TYPES.COMBO:
			add_combo()
		instance.TYPES.TIME:
			add_time()
		instance.TYPES.SCORE:
			add_score(2000)

func _on_backfist(player_hp, player_hp_max):
	update_gui(player_hp, player_hp_max)

func _on_update_control_gui(move, pressedm, action, presseda):
	if move == null and action == null:
		$controller/c/up.texture = dir
		$controller/c/down.texture = dir
		$controller/c/left.texture = dir
		$controller/c/right.texture = dir
		$controller/c/b.texture = btn
		$controller/c/a.texture = btn
		return
	if move:
		match move:
			Vector2.UP:
				if pressedm:
					$controller/c/up.texture = dir_pressed
				else:
					$controller/c/up.texture = dir
			Vector2.DOWN:
				if pressedm:
					$controller/c/down.texture = dir_pressed
				else:
					$controller/c/down.texture = dir
			Vector2.LEFT:
				if pressedm:
					$controller/c/left.texture = dir_pressed
				else:
					$controller/c/left.texture = dir
			Vector2.RIGHT:
				if pressedm:
					$controller/c/right.texture = dir_pressed
				else:
					$controller/c/right.texture = dir
	if action:
		match action:
			"ui_punch":
				if presseda:
					$controller/c/b.texture = btn_pressed
				else:
					$controller/c/b.texture = btn
			"ui_kick":
				if presseda:
					$controller/c/a.texture = btn_pressed
				else:
					$controller/c/a.texture = btn

func _on_action(action_performed, breath_array):
#	print('GUI _on_action performed ', action_performed,' got to decrease some breath')
	var breath_delta = 0
	var attack
	for b in breath_array:
		if b['attack'] == action_performed:
#			print('breath to decrease = ', b['breath'])
			attack = b['attack']
			breath_delta = b['breath'] * -1
	$f.update_bar(breath_delta)
#	print('update GUI combo with ', attack)

func update_btn_combo(n):
#	print('GUI update_btn_combo ', n)
	if n==0:
		clean_combo_btns()
	else:
		var btns_to_show =  self.player.combo[selected_combo]
		var idx = 0
		for b in btns_to_show:
			var texture = load_texture_from_btn(b, n>idx)
			$h_down/c/btns.get_child(idx).texture = texture
			$h_down/c/btns.get_child(idx).show()
			idx+=1
		$h_down/c/btns.show()
		if n == 4:
			print('TODO make animation on combo btns')
			yield(get_tree().create_timer(0.2), "timeout")
			clean_combo_btns()
	pass
