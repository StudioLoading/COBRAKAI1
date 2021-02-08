extends "res://scripts/stage_father.gd"

onready var dancer_scene = preload("res://dancer.tscn")

signal blink

const dancer_types = preload("res://scripts/dancer.gd")
onready var miguel_skel_anim = preload("res://animations/Miguel_skel.tres")


func _ready():

	STAGE_TIMER = 95
	STAGE_NUMBER = 4
	$luci/tdispari.wait_time = 0.3
	$luci/tpari.wait_time = 0.7
	$luci/tpari.start()
	$luci/tdispari.start()
	
	config_dancers()
	config_spawners()
	$YSort/player/AnimatedSprite.frames = miguel_skel_anim
	var from_stage = ProjectSettings.get_setting("stage")
	if from_stage != null and "boss_intro" in str(from_stage):
		$YSort/spawner_player_stage.global_position = $p_exit_stage.global_position
		$YSort/spawner_player_stage.global_position.y += 20
		$bgm.stream = bg_zone_boss
		$bgm.play()
		var variable_per_enemy_names = 0
		for a in $enemy_poss.get_children():
			for p in a.get_children():
				if p is Position2D:
					var enemy_type = rng.randi_range(0,2)
					var enemy_instance =  enemy_pirate1.instance()
					match enemy_type:
						1:
							enemy_instance = enemy_pirate2.instance()
						2:
							enemy_instance = enemy_pirate3.instance()
					enemy_instance.name = str(enemy_instance.name, variable_per_enemy_names)
					$YSort.add_child(enemy_instance)
					enemy_instance.global_position = p.global_position
					self.init_enemy(enemy_instance.name)
					enemy_instance.change_status(enemy_instance.STATES.WAITING_FOR_PLAYER, null, null, null, false, Vector2.ZERO)
					variable_per_enemy_names += 1
					print('adding enemy to stage ', enemy_instance.name)
	else:
		$bgm.stream = bg_zone_dance
		$bgm.play()
		$rumble_triggers_00.connect("body_entered", self, '_on_rumble_triggers_body_entered')
		$rumble_triggers_01.connect("body_entered", self, '_on_rumble_triggers_body_entered')
		$rumble_triggers_02.connect("body_entered", self, '_on_rumble_triggers_body_entered')
		$rumble_triggers_00/timer_enemy_spawner.connect("timeout", self, '_on_timer_enemy_spawner_timeout')
		$rumble_triggers_01/timer_enemy_spawner.connect("timeout", self, '_on_timer_enemy_spawner_timeout')
		$rumble_triggers_02/timer_enemy_spawner.connect("timeout", self, '_on_timer_enemy_spawner_timeout')
		limits = $rumble_limits_00
		triggers = $rumble_triggers_00
		
	ProjectSettings.set_setting("stage", STAGE_NUMBER)
	$YSort/spawn_player.global_position = $YSort/spawner_player_stage.global_position
	
	init_player()
	
	reset_player_position()
	$p_exit.global_position = $p_exit_stage.global_position

func config_dancers():
	for d in get_tree().get_nodes_in_group('dancer'):
		var dancer = dancer_scene.instance()
		var r =  dancer_types.TYPE.values()[rng.randi_range(1,6)]
		dancer.global_position = d.global_position
		if d.is_in_group('boogie_dancer'):
			dancer.config(r, dancer_types.DANCE.BOOGIE)
		elif d.is_in_group('normal_dancer'):
			dancer.config(r, dancer_types.DANCE.NORMAL)
		elif d.is_in_group('talk_dancer'):
			dancer.config(r, dancer_types.DANCE.TALK)
		if d.is_in_group('flipped'):
			dancer.flip()
		dancer.dance()
		$YSort.add_child(dancer)
	pass

func config_spawners():
	$YSort/yaz.config($YSort/yaz.TYPES.DIAG, 'yazlaker', $YSort/player, false, false, $diags)
	$YSort/sam.config($YSort/sam.TYPES.LIFE, 'samlaker', $YSort/player, false, false, $diags)
	$YSort/moon.config($YSort/moon.TYPES.SCORE, 'moonlaker', $YSort/player, false, false, $diags)
	$YSort/eli.config($YSort/eli.TYPES.SCORE, 'eli', $YSort/player, true, false, $diags)
	$YSort/dimitri.config($YSort/dimitri.TYPES.DIAG, 'dimitri', $YSort/player,  false, false, $diags)
	$YSort/dimitri/s.flip_h = true
	$YSort/cestino_life.config($YSort/cestino_life.TYPES.LIFE, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_life2.config($YSort/cestino_life2.TYPES.LIFE, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_time.config($YSort/cestino_time.TYPES.TIME, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_time2.config($YSort/cestino_time2.TYPES.TIME, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_time3.config($YSort/cestino_time3.TYPES.TIME, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_time4.config($YSort/cestino_time4.TYPES.TIME, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_hp2.config($YSort/cestino_hp2.TYPES.HP, 'cestino', $YSort/player, true, true, $diags)
	$YSort/cestino_hp3.config($YSort/cestino_hp3.TYPES.HP, 'cestino', $YSort/player, true, true, $diags)

func _on_tpari_timeout():
	$luci/pari.visible = !$luci/pari.visible
	pass # Replace with function body.

func _on_tdispari_timeout():
	$luci/dispari.visible = !$luci/dispari.visible
	pass # Replace with function body.
	
func _on_a_dance_body_entered(body):
	if body.is_in_group("player"):
		update_miguel_zone(ZONES.DANCE)
	pass # Replace with function body.

func _on_a_fight_body_entered(body):
	if body.is_in_group("player"):
		update_miguel_zone(ZONES.FIGHT)
	pass # Replace with function body.

func _on_a_boss_body_entered(body):
	if body.is_in_group("player"):
		update_miguel_zone(ZONES.BOSS)
	pass # Replace with function body.

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
		var enemy_instance =  enemy_pirate1.instance()
#		print('_on_timer_enemy_spawner_timeout(): enemy_type=', enemy_type)
		match enemy_type:
			1:
				enemy_instance = enemy_pirate2.instance()
			2:
				enemy_instance = enemy_pirate3.instance()
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
#			print('stage4 rumble still active for enemy ', e.name, '-', e.name.substr(0,2), ' still alive')
			rumble_completed = false
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
		else:
			print('tutte le risse sono state completate, si può avviare all\' uscita verso il boss')

func generate_enemies():
	var poss = $enemy_poss.get_child(rumble_counter-1)
	var variable_per_enemy_names = 0
	if poss :
		for p in poss.get_children():
			var enemy_type = rng.randi_range(0,2)
			var enemy_instance =  enemy_pirate1.instance()
			#enemy_instance.get_node("AnimatedSprite").frames = 
			match enemy_type:
				1:
					enemy_instance = enemy_pirate2.instance()
				2:
					enemy_instance = enemy_pirate3.instance()
			enemy_instance.name = str(enemy_instance.name, variable_per_enemy_names)
			$YSort.add_child(enemy_instance)
			enemy_instance.global_position = p.global_position
		#	print('trying to add an enemy, named ', enemy_instance.name)
			self.init_enemy(enemy_instance.name)
			enemy_instance.change_status(enemy_instance.STATES.WAITING_FOR_PLAYER, null, null, null, false, Vector2.ZERO)
			variable_per_enemy_names += 1
	pass

func play_outro():
	$efx.pause_mode = true
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
