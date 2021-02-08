extends Node2D

onready var STAGE_NUMBER = 0
onready var STAGE_TIMER = 99
onready var NO_TIME_STAGE = false

onready var enemy_counter = 0

onready var texture_player_normal : Texture = preload("res://asset/GUI/Johnny_Icon_Normal.png")
onready var texture_player_hit = preload("res://asset/GUI/Johnny_Icon_hit.png")

onready var stage_bg = preload('res://sound/potrebbe.servire.ogg')
onready var pause_efx = preload('res://sound/effects/pause.ogg')

onready var rng = RandomNumberGenerator.new()

onready var ENEMIES_PER_RUMBLE = [6, 10, 8]
onready var rumble_counter = 0
var triggers = null
var limits = null
onready var rumble_generated_enemies = 0

onready var enemy_1 = preload("res://enemy.tscn")
onready var enemy_2 = preload("res://enemy2.tscn")
onready var enemy_3 = preload("res://enemy3.tscn")
onready var enemy_pirate1 = preload("res://enemy_pirate1.tscn")
onready var enemy_pirate2 = preload("res://enemy_pirate2.tscn")
onready var enemy_pirate3 = preload("res://enemy_pirate3.tscn")

enum ZONES {DANCE, FIGHT, BOSS, RUMBLE}
onready var current_zone = ZONES.DANCE

onready var bg_zone_dance = preload("res://sound/stage4.0.ogg")
onready var bg_zone_fight = preload("res://sound/stage4.1.ogg")
onready var bg_zone_boss = preload("res://sound/pauraaaa.ogg")
onready var efx_new_combo = preload("res://sound/new_combo.ogg")


func _ready():
	$Tween_intro.start()
	$GUI/enemy.hide()
	$GUI/cl/s.hide()
	rng.randomize()
	$YSort/player.global_position = $YSort/spawn_player.global_position
	for e in $YSort.get_children():
		if e.is_in_group('group_enemies'):
			init_enemy(e.name)
	$bgm.stream = stage_bg
	$bgm.play()
	$pause/paused.hide()
#	init_player()

func init_player():
	print('stage_father init_player')
	$YSort/player/Camera2D.current=true
	$YSort/player.connect('player_been_hit', self, '_on_player_been_hit')
	$YSort/player.connect('hit', self, '_on_player_hit')
	$YSort/player.connect('player_down', self, '_on_player_down')
	$YSort/player.connect('on_select', $GUI/player, '_on_select')
	$YSort/player.connect('update_control_gui', $GUI/player, '_on_update_control_gui')
	$YSort/player.connect('backfist', $GUI/player, '_on_backfist')
	$YSort/player.connect('act', $GUI/player, '_on_action')
	$YSort/player.connect('update_btn_combo', $GUI/player, 'update_btn_combo')
	self.connect('blink', $YSort/player, 'on_blink')
	$YSort/player/AnimatedSprite.animation='stand'
	$YSort/player.set_process(true)
	$GUI/player.config($YSort/player, STAGE_TIMER, NO_TIME_STAGE)
	for pausable in get_tree().get_nodes_in_group('pausable'):
		$YSort/player.connect('on_pause_resume', pausable, 'pause_resume')
	$GUI/player/time.connect('timing_out', self, 'on_timing_out')
	$GUI/player/time.connect('timing_in', self, 'on_timing_in')
	$breath_increase.connect("timeout", self, '_on_breath_increase_timeout')
	reset_player_position()
	init_player_child()

func init_player_child():
	pass

func on_timing_out():
	$bgm.pitch_scale = 1.3
	pass

func on_timing_in():
	$bgm.pitch_scale = 1
	pass
	
func reset_player_position():
	$YSort/player.global_position = $YSort/spawn_player.global_position

func enemy_dead(enemy):
#	print('aggiorno i punti')
#	print('TODO metto per qualche decimo di secondo la faccia nemica morta')
	$GUI/enemy.hide()
	check_stage_complete()

func check_stage_complete():
	var completed = true
	for e in $YSort.get_children():
			if e.is_in_group('group_enemies'):
#				print(e.name,'HP=', e.HP)
				if e.HP > 0:
					completed=false
	if completed:
		print('STAGE COMPLETE! all enemies down. play_outro func commented here below')
		play_outro_stage()
	pass

func _on_player_hit(action, combo_completed):
	get_tree().call_group("group_enemies", 'hit', action, $YSort/player.global_position, $YSort/player/AnimatedSprite.flip_h, combo_completed)
	get_tree().call_group("spawners", 'hit', action)
	pass # Replace with function body.

func _on_player_been_hit(player_hp, player_hp_max):
	$GUI/player.add_score(-10)
	$GUI/player.player_been_hit(player_hp, player_hp_max)

func _on_player_down():
	var lifes = $GUI/player.get_lifes()
	if lifes < 0:
		ProjectSettings.set_setting("gameover_msg", 'What\'s the matter , having trouble breathing ?')
		ProjectSettings.set_setting('gameover_psg', 'Johnny')
		get_tree().change_scene("res://gameover.tscn")
	else:
		if $GUI/player.get_time() <= 0:
			get_tree().reload_current_scene()
		else:
			print('stage1 player down ma ho ancora vite')
			$GUI/player.update_lifes()
			$YSort/player.reinit()
			$YSort/player.on_blink()
			$YSort/spawn_player.global_position = $YSort/player.global_position
			init_player()
			$GUI/player.config($YSort/player, STAGE_TIMER, NO_TIME_STAGE)
			$GUI/player.blink_lifes()

func show_enemy_on_gui(e):
#	print('GUI mostro ', e.name, ' ', e.HP, '/', e.HP_MAX, ' on dojo ', e.DOJO)
	var tacca = e.HP_MAX / $GUI/enemy/hp.get_child_count()
	var idx = 0
	for l in $GUI/enemy/hp.get_children():
		if e.HP >= (tacca * (idx+1)):
			$GUI/enemy/hp.get_child(idx).show()
		else:
#			yield(get_tree().create_timer(0.02), "timeout")
			$GUI/enemy/hp.get_child(idx).hide()
		idx += 1
	if $GUI/enemy.visible == false:
		$GUI/enemy.show()
	match e.DOJO:
		'highschool':
			$GUI/enemy/dojo.texture = load("res://asset/GUI/highschool/logo.png")
		'cobra':
			$GUI/enemy/dojo.texture = load("res://asset/GUI/cobra/logo.png")
	match e.PSGNAME:
		'ky', 'kyler', 'boss_kyler':
			$GUI/enemy/dojo/face.texture = load("res://asset/GUI/highschool/ky_normal.png")
		'ciccione':
			$GUI/enemy/dojo/face.texture = load("res://asset/GUI/highschool/ciccione_normal.png")
		'enemy':
			$GUI/enemy/dojo/face.texture = load("res://asset/GUI/highschool/enemy_normal.png")
		'bert':
			$GUI/enemy/dojo/face.texture = load("res://asset/GUI/Johnny_Icon_Normal.png")
	if e.HP <= 0:
#		print('mostro faccia morto x3sec poi nascondo')
		e.disconnect('show_enemy_on_gui', self, 'show_enemy_on_gui')
		$GUI/enemy.hide()
		return
	else:
		blink_enemy_face(e)

func init_enemy(ename):
#	print('stage_father:init_enemy() ', ename)
	var e = $YSort.get_node(ename)
#	print('enemy node found ', e)
	$YSort.get_node(ename).connect('hit_player', $YSort/player, 'hit')
	$YSort.get_node(ename).connect('dead', self, 'enemy_dead')
	$YSort.get_node(ename).connect('show_enemy_on_gui', self, 'show_enemy_on_gui')
	$YSort.get_node(ename).connect('hide_enemy_on_gui', self, 'hide_enemy_on_gui')
	$YSort.get_node(ename).connect('add_score', $GUI/player, 'add_score')
#	$YSort.get_node(str(ename,'/effects')).volume_db = -15

func hide_enemy_on_gui(e):
	if $GUI/enemy.visible:
		$GUI/enemy.hide()
		
func blink_enemy_face(e):
	var texture_enemy_hit = null
	var texture_enemy_normal = null
	match e.PSGNAME:
		'ky':
			texture_enemy_normal = load("res://asset/GUI/highschool/ky_normal.png")
			texture_enemy_hit = load("res://asset/GUI/highschool/ky_hit.png")
		'ciccione':
			texture_enemy_normal = load("res://asset/GUI/highschool/ciccione_normal.png")
			texture_enemy_hit = load("res://asset/GUI/highschool/ciccione_hit.png")
		'enemy','enemy2':
			texture_enemy_normal = load("res://asset/GUI/highschool/enemy_normal.png")
			texture_enemy_hit = load("res://asset/GUI/highschool/enemy_hit.png")
	$GUI/enemy/dojo/face.texture = texture_enemy_hit
	yield(get_tree().create_timer(0.4), "timeout")
	$GUI/enemy/dojo/face.texture = texture_enemy_normal

func play_outro_stage():
	$bgm.stop()
	var bg_outro = load("res://sound/softsuspance.ogg")
	$bgm.stream = bg_outro
	$bgm.play()
	yield(get_tree().create_timer(2.5), "timeout")
	play_outro()
	pass
	
func play_outro():
	$YSort/player.set_process(false)
	$GUI/player.hide()
	$GUI/cl/s.hide()
	$GUI/enemy.hide()
	$bgm.stop()
	$efx.pause_mode = true
	var life = $YSort/player.HP
	var time = $GUI/player.get_time()
	var score = $GUI/player.get_score()
	var up = $GUI/player.get_lifes()
	ProjectSettings.set_setting("stage", STAGE_NUMBER)
	ProjectSettings.set_setting("time", time)
	ProjectSettings.set_setting("score", score)
	ProjectSettings.set_setting("up", up)
	ProjectSettings.set_setting("life", life)
	var stage_complete_scene = load("res://stage_complete.tscn")
	var stage_complete_instance = stage_complete_scene.instance()
	$YSort/player.add_child(stage_complete_instance)
	pass

func _on_camera_movement_body_exited(body):
	if body.is_in_group('player'):
		$YSort/player/Camera2D.current = false
	pass # Replace with function body.

func _on_camera_movement_body_entered(body):
	if body.is_in_group('player'):
		$YSort/player/Camera2D.current = true

func get_player_global_position():
#	print('stage_father:get_player_global_position() returns ', $YSort/player.global_position)
	return $YSort/player.global_position

func pause_resume(paused, with_paused_menu):
#	print('pausing bgm and efx ', paused)
	if paused and with_paused_menu:
		$bgm.stream_paused = paused
		$efx.stream = pause_efx
		$efx.play()
	else:
		$bgm.stream_paused = false

func _on_breath_increase_timeout():
	$YSort/player/timer_input_freq.wait_time = (1/$GUI/player/f.breath_plus_n(2))*10
#	print('NEW player timer_input.wait_time = ', $YSort/player/timer_input_freq.wait_time)
	pass # Replace with function body.


func _on_exit_body_entered(body):
	if body.is_in_group('player'):
		play_outro()
	pass # Replace with function body.

func update_miguel_zone(zone):
	if current_zone != zone:
#		print('changing bgm from ', current_zone, ' to ', zone)
		current_zone = zone
		match zone:
			ZONES.DANCE:
				if $bgm.stream != bg_zone_dance:
					$bgm.stream = bg_zone_dance
					$bgm.play()
			ZONES.FIGHT, ZONES.RUMBLE:
				if $bgm.stream != bg_zone_fight:
					$bgm.stream = bg_zone_fight
					$bgm.play()
			ZONES.BOSS:
				if $bgm.stream != bg_zone_boss:
					$bgm.stream = bg_zone_boss
					$bgm.play()
