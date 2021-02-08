extends "res://scripts/enemy.gd"
#ENEMY 3
func _ready():
	$AnimatedSprite.frames = load('res://animations/enemy_pirate3.tres')
	BASE_SPEED_MOVEMENT = 40
	REACH_PLAYER_TIME = 1.5
	SPEED_ACTION = 0.25
	SPEED_GOING_BACK = 0.6
	REACTION_TIME = 0.8
	HP = 60#300
	HP_MAX = 60#300
	KO_Y = 20
	KO_X = 20
	SCORE = {'jab': 5, 'raw': 40, 'kick': 2, 'uppercut': 2, 'backfist': 10, 'backkick': 2}
	DAMAGE = {'jab': 5, 'raw': 40, 'kick': 2, 'uppercut': 2, 'backfist': 10, 'backkick': 2}
	INFLICTION = {'jab': 8, 'kick': 4}
	DOJO = 'highschool'
	PSGNAME='pirate3'
	MOV_WALK_PERC = 0
	MOV_RUN_PERC = 6
	MOV_DASH_PERC = 0
	MOV_GUARD_PERC = 4
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK
