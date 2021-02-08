extends "res://scripts/enemy_boss.gd"


func _ready():
	print('KYLER ready')
	efx_step = preload("res://sound/effects/step.ogg")
	efx_hit = preload("res://sound/effects/boss_hit.ogg")
	efx_loaded_attack = preload("res://sound/effects/hit.loaded_boss.ogg")
	$AnimatedSprite.frames = load('res://animations/boss_pirate_kyler.tres')
	BASE_SPEED_MOVEMENT = 30
	REACH_PLAYER_TIME = 99
	SPEED_ACTION = 0.3
	SPEED_GOING_BACK = 1
	REACTION_TIME = 0.2
	HP = 40#300
	HP_MAX = 40#300
	KO_Y = 30
	KO_X = 30
	SCORE = {'jab': 0, 'raw': 0, 'kick': 0, 'uppercut': 0, 'backfist': 5, 'backkick': 10}
	DAMAGE = {'jab': 0, 'raw': 0, 'kick': 0, 'uppercut': 0, 'backfist': 5, 'backkick': 10}
	INFLICTION = {'jab': 8, 'raw': 12, 'kick': 18}
	HIT_ATTACKS = ['backkick', 'backfist']
	DOJO = 'highschool'
	PSGNAME='boss_kyler'
	MOV_WALK_PERC = 8
	MOV_RUN_PERC = 1
	MOV_DASH_PERC = 0
	MOV_GUARD_PERC = 1
	config()

	
