extends "res://scripts/enemy.gd"
#ENEMY 2
func _ready():
	$AnimatedSprite.frames = load('res://animations/enemy_pirate1.tres')
	BASE_SPEED_MOVEMENT = 40
	REACH_PLAYER_TIME = 1
	SPEED_ACTION = 0.3
	SPEED_GOING_BACK = 1
	REACTION_TIME = 0.7
	HP = 40#300
	HP_MAX = 40#300
	KO_Y = 20
	KO_X = 20
	SCORE = {'jab': 10, 'raw': 40, 'kick': 5, 'uppercut': 55, 'backfist': 5, 'backkick': 5}
	DAMAGE = {'jab': 10, 'raw': 40, 'kick': 5, 'uppercut': 5, 'backfist': 5, 'backkick': 5}
	INFLICTION = {'jab': 8, 'kick': 4}
	DOJO = 'highschool'
	PSGNAME='pirate1'
	MOV_WALK_PERC = 5
	MOV_RUN_PERC = 1
	MOV_DASH_PERC = 0
	MOV_GUARD_PERC = 4
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK
