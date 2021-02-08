extends "res://scripts/enemy.gd"
#ENEMY 2
func _ready():
	$AnimatedSprite.frames = load('res://animations/enemy2.tres')
	BASE_SPEED_MOVEMENT = 40
	REACH_PLAYER_TIME = 2
	SPEED_ACTION = 0.1
	SPEED_GOING_BACK = 0.7
	REACTION_TIME = 0.2
	HP = 60#300
	HP_MAX = 60#300
	KO_Y = 30
	KO_X = 30
	SCORE = {'jab': 2, 'raw': 4, 'kick': 10, 'uppercut': 15, 'backfist': 4, 'backkick': 20, 'cranekick': 40, 'sweep': 30}
	DAMAGE = {'jab': 2, 'raw': 14, 'kick': 10, 'uppercut': 15, 'backfist': 4, 'backkick': 20, 'cranekick': 40, 'sweep': 30}
	INFLICTION = {'jab': 8, 'kick': 18}
	DOJO = 'highschool'
	PSGNAME='enemy2'
	MOV_WALK_PERC = 2
	MOV_RUN_PERC = 5
	MOV_DASH_PERC = 0
	MOV_GUARD_PERC = 3
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK
