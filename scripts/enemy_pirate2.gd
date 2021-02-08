extends "res://scripts/enemy.gd"
#ENEMY 2
func _ready():
	$AnimatedSprite.frames = load('res://animations/enemy_pirate2.tres')
	BASE_SPEED_MOVEMENT = 60
	REACH_PLAYER_TIME = 0.5
	SPEED_ACTION = 0.25
	SPEED_GOING_BACK = 1
	REACTION_TIME = 0.5
	HP = 30#300
	HP_MAX = 30#300
	KO_Y = 20
	KO_X = 20
	SCORE = {'jab': 2, 'raw': 2, 'kick': 10, 'uppercut': 2, 'backfist': 30, 'backkick': 50}
	DAMAGE = {'jab': 2, 'raw': 2, 'kick': 10, 'uppercut': 2, 'backfist': 30, 'backkick': 50}
	INFLICTION = {'jab': 8, 'kick': 4}
	DOJO = 'highschool'
	PSGNAME='pirate2'
	MOV_WALK_PERC = 6
	MOV_RUN_PERC = 2
	MOV_DASH_PERC = 0
	MOV_GUARD_PERC = 2
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK
