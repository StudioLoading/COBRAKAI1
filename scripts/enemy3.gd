extends "res://scripts/enemy.gd"
#ENEMY 3
func _ready():
	$AnimatedSprite.frames = load('res://animations/enemy3.tres')	
	BASE_SPEED_MOVEMENT = 10
	REACH_PLAYER_TIME = 4
	SPEED_ACTION = 0.1
	SPEED_GOING_BACK = 0.7
	REACTION_TIME = 1
	HP = 80#300
	HP_MAX = 80#300
	KO_Y = 30
	KO_X = 30
	SCORE = {'jab': 10, 'raw': 20, 'kick': 5, 'uppercut': 20, 'backfist': 10, 'backkick': 5, 'cranekick': 40, 'sweep': 30}
	DAMAGE = {'jab': 10, 'raw': 20, 'kick': 5, 'uppercut': 15, 'backfist': 10, 'backkick': 5, 'cranekick': 40, 'sweep': 30}
	INFLICTION = {'jab': 8, 'kick': 16}
	DOJO = 'highschool'
	PSGNAME='ciccione'
	MOV_WALK_PERC = 6
	MOV_RUN_PERC = 0
	MOV_DASH_PERC = 0
	MOV_GUARD_PERC = 4
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK
