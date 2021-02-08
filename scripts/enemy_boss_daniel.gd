extends "res://scripts/enemy_boss.gd"


func _ready():
	print('DANIEL ready')
	efx_step = preload("res://sound/effects/step.ogg")
	efx_hit = preload("res://sound/effects/boss_hit.ogg")
	efx_loaded_attack = preload("res://sound/effects/hit.loaded_boss.ogg")
	$AnimatedSprite.frames = load('res://animations/boss_daniel.tres')
	BASE_SPEED_MOVEMENT = 20
	REACH_PLAYER_TIME = 99
	SPEED_ACTION = 0.3
	SPEED_GOING_BACK = 1
	REACTION_TIME = 0.2
	HP = 100#60#300
	HP_MAX = 100#60#300
	KO_Y = 30
	KO_X = 30
	SCORE = {'jab': 0, 'raw': 2, 'kick': 0, 'uppercut': 10, 'backfist': 5, 'backkick': 0}
	DAMAGE = {'jab': 0, 'raw': 2, 'kick': 0, 'uppercut': 10, 'backfist': 5, 'backkick': 0}
	INFLICTION = {'jab': 8, 'raw': 12, 'kick': 18, 'uppercut': 18}
	HIT_ATTACKS = ['uppercut', 'raw', 'backfist']
	DOJO = 'miyagi'
	PSGNAME='boss_daniel'
	MOV_WALK_PERC = 4
	MOV_RUN_PERC = 2
	MOV_DASH_PERC = 3
	MOV_GUARD_PERC = 2
	config()


func next_position():
	var zero_one = rng.randi_range(0,2)
	positions_going_to_index = (positions_going_to_index+1) % positions.size()
	var p = positions[positions_going_to_index].global_position
	if zero_one == 0 and get_tree().get_root().get_node("stage"):
		p = get_tree().get_root().get_node("stage").get_player_global_position()
		print('DANIEL wakeup start')
		$wakeup.start()
	var h : Vector2 = Vector2.ZERO
	h.x = p.x - self.global_position.x
	h.y = p.y - self.global_position.y
	print('DANIEL next_position() going to =', p)
	self.dir_to_player = h.normalized()
	if self.status != STATES.WAITING_FOR_PLAYER:
		change_status(STATES.PERFORMING_ATTACK, null, null, null, null, null)
		
func _on_AnimatedSprite_frame_changed():
	match $AnimatedSprite.animation:
		'raw', 'kick':
			if $AnimatedSprite.frame == 1:
				$effects.stream = efx_loaded_attack
				$effects.play()
			elif $AnimatedSprite.frame == 2:
				$kiai.frame = 0
				$kiai.play()
		'hit', 'dead':
			$effects.stream = efx_hit
			$effects.play()
	pass # Replace with function body.

