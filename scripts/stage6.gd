extends "res://scripts/stage_father.gd"

onready var kicked = false

func _ready():
	$ColorRect.show()
	STAGE_TIMER = 69
	STAGE_NUMBER = 6
	ENEMIES_PER_RUMBLE = [6, 10, 12]
	ProjectSettings.set_setting("stage", STAGE_NUMBER)
	$GUI/enemy.hide()
	$GUI/cl/s.hide()
	rng.randomize()
	$YSort/player.global_position = $YSort/spawn_player_stage.global_position
	stage_bg = preload('res://sound/stage6.ogg')
	bg_zone_dance = stage_bg
	$bgm.stream = stage_bg
	$bgm.play()
	for k in get_tree().get_nodes_in_group('item_kicking'):
		$YSort/player.connect('act', k, 'kicked')
	$YSort/spawn_player.global_position = $YSort/spawn_player_stage.global_position
	$YSort/player.combo_unlocked= [true, false, false, false, false]
	$YSort/player.store_combo_unlocked()
	init_player()
	config_spawners()
	$rumble_triggers_00.connect("body_entered", self, '_on_rumble_triggers_body_entered')
	$rumble_triggers_01.connect("body_entered", self, '_on_rumble_triggers_body_entered')
	$rumble_triggers_02.connect("body_entered", self, '_on_rumble_triggers_body_entered')
	$rumble_triggers_00/timer_enemy_spawner.connect("timeout", self, '_on_timer_enemy_spawner_timeout')
	$rumble_triggers_01/timer_enemy_spawner.connect("timeout", self, '_on_timer_enemy_spawner_timeout')
	$rumble_triggers_02/timer_enemy_spawner.connect("timeout", self, '_on_timer_enemy_spawner_timeout')
	limits = $rumble_limits_00
	triggers = $rumble_triggers_00
	$Tween_intro.interpolate_property($ColorRect, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 3, Tween.TRANS_EXPO, Tween.EASE_IN)
	yield($Tween_intro, "tween_all_completed")
	$ColorRect.queue_free()

func init_player_child():
	$p_exit.global_position = $p_exit_stage.global_position
	pass
	
func check_stage_complete():
	var completed = false
	if completed:
		print('STAGE COMPLETE! all enemies down. play_outro func commented here below')
		play_outro_stage()
	pass


func _on_rumble_triggers_body_entered(body):
	if body.is_in_group('player'):
#		print('_on_rumble_triggers_body_entered: stopping player camera, ')
		$YSort/player/Camera2D.current = false
		triggers.disconnect("body_entered", self, '_on_rumble_triggers_body_entered')
		match rumble_counter:
			1:
				limits = $rumble_limits_01
				triggers = $rumble_triggers_01
			2:
				limits = $rumble_limits_02
				triggers = $rumble_triggers_02
		for t in limits.get_children():
#			print('enabling ', t.name,' collision shape')
			t.set_deferred("disabled", false)
		triggers.get_node("timer_enemy_spawner").start()
		for r in triggers.get_children():
			if r is CollisionShape2D:
				r.queue_free()
				break
		update_miguel_zone(ZONES.RUMBLE)
	pass # Replace with function body.

func _on_timer_enemy_spawner_timeout():
#	print('timer_enemy_spawner timeout')
	if rumble_counter<ENEMIES_PER_RUMBLE.size() and rumble_generated_enemies < ENEMIES_PER_RUMBLE[rumble_counter]:
		var enemy_type = rng.randi_range(0,3)
		var enemy_instance =  enemy_1.instance()
#		print('_on_timer_enemy_spawner_timeout(): enemy_type=', enemy_type)
		match enemy_type:
			1:
				enemy_instance = enemy_2.instance()
			2:
				enemy_instance = enemy_3.instance()
		enemy_instance.name = str('r_', enemy_instance.name, rumble_generated_enemies)
#		print('created enemy with name ', enemy_instance.name)
		$YSort.add_child(enemy_instance)
		if (rumble_generated_enemies % 2) == 0:
			enemy_instance.global_position =  triggers.get_node("rumble_spawner_01").global_position
		else:
			enemy_instance.global_position = triggers.get_node("rumble_spawner_02").global_position
	#	print('trying to add an enemy, named ', enemy_instance.name)
		self.init_enemy(enemy_instance.name)
		enemy_instance.get_node("reach_player").start()
		rumble_generated_enemies += 1
		triggers.get_node("timer_enemy_spawner").start()
	pass # Replace with function body.

func enemy_dead(enemy):
#	print('aggiorno i punti')
	$GUI/enemy.hide()
	if current_zone == ZONES.RUMBLE:
		check_rumble_end()

func check_rumble_end():
	var rumble_completed = true
	for e in $YSort.get_children():
		if e.is_in_group('group_enemies') and e.HP > 0 and 'r_' == e.name.substr(0,2) and e.is_on_screen():
			rumble_completed = false
			print('STAGE6 still standing enemy ', e.name)
			break
	if rumble_completed:
		rumble_generated_enemies = 0
		rumble_counter += 1
		$YSort/player/Camera2D.current = true
		for t in limits.get_children():
	#			print('enabling ', t.name,' collision shape')
			t.set_deferred("disabled", true)
		update_miguel_zone(ZONES.FIGHT)
		var cartel_global_position = get_player_global_position() + Vector2(0, -32)
		var cartel = load("res://go.tscn")
		var cartel_instance = cartel.instance()
		cartel_instance.name = 'cartel'
		cartel_instance.global_position = cartel_global_position
		$YSort.add_child(cartel_instance)
		if rumble_counter < ENEMIES_PER_RUMBLE.size():
			triggers.disconnect("body_entered", self, '_on_rumble_triggers_body_entered')
			match rumble_counter:
				1:
					limits = $rumble_limits_01
					triggers = $rumble_triggers_01
				2:
					limits = $rumble_limits_02
					triggers = $rumble_triggers_02
			if rumble_counter > 0:
				triggers.connect("body_entered", self, '_on_rumble_triggers_body_entered')
			generate_enemies()
			update_miguel_zone(ZONES.DANCE)
		else:
			var kyler = load("res://ky.tscn").instance()
			kyler.global_position = $YSort/pos_kyler.global_position
			$YSort.add_child(kyler)
			init_enemy(kyler.name)
			print('tutte le risse sono state completate, si può avviare all\' uscita verso il boss')
	
func generate_enemies():
#	var poss = $enemy_poss.get_child(rumble_counter-1)
#	var variable_per_enemy_names = 0
#	if poss :
#		for p in poss.get_children():
#			var enemy_type = rng.randi_range(0,2)
#			var enemy_instance =  enemy_pirate1.instance()
#			#enemy_instance.get_node("AnimatedSprite").frames = 
#			match enemy_type:
#				1:
#					enemy_instance = enemy_pirate2.instance()
#				2:
#					enemy_instance = enemy_pirate3.instance()
#			enemy_instance.name = str(enemy_instance.name, variable_per_enemy_names)
#			$YSort.add_child(enemy_instance)
#			enemy_instance.global_position = p.global_position
#		#	print('trying to add an enemy, named ', enemy_instance.name)
#			self.init_enemy(enemy_instance.name)
#			enemy_instance.change_status(enemy_instance.STATES.WAITING_FOR_PLAYER, null, null, null, false, Vector2.ZERO)
#			variable_per_enemy_names += 1
	pass

func config_spawners():
#	$YSort/sam.config($YSort/sam.TYPES.LIFE, 'samlaker', $YSort/player, false, false, $diags)
	$YSort/aj.config($YSort/aj.TYPES.SCORE, 'aj', $YSort/player, false, false, $diags)
	$YSort/bri.config($YSort/bri.TYPES.DIAG, 'bri', $YSort/player, false, false, $diags)
	$YSort/peter.config($YSort/peter.TYPES.DIAG, 'peter', $YSort/player, false, false, $diags)
	$YSort/philippe.config($YSort/philippe.TYPES.SCORE, 'philippe', $YSort/player, true, false, $diags)
	$YSort/cestino_score.config($YSort/cestino_score.TYPES.SCORE, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_score2.config($YSort/cestino_score2.TYPES.SCORE, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_time.config($YSort/cestino_time.TYPES.TIME, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_time2.config($YSort/cestino_time2.TYPES.TIME, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_hp.config($YSort/cestino_hp.TYPES.HP, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_life.config($YSort/cestino_life.TYPES.LIFE, 'cestino', $YSort/player, true, true, $diags)

func play_outro():
	$efx.pause_mode = true
	$bgm.pause_mode = true
	var life = $YSort/player.HP
	var time = $GUI/player.get_time()
	var score = $GUI/player.get_score()
	var up = $GUI/player.get_lifes()
	ProjectSettings.set_setting("stage", STAGE_NUMBER)
	ProjectSettings.set_setting("life", life)
	ProjectSettings.set_setting("time", time)
	ProjectSettings.set_setting("score", score)
	ProjectSettings.set_setting("up", up)
	get_tree().change_scene("res://stage_father_boss_intro.tscn")
