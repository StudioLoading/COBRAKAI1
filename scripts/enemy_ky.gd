extends "res://scripts/enemy.gd"
#ENEMY 2
func _ready():
	$AnimatedSprite.frames = load("res://animations/enemy_ky.tres")
	BASE_SPEED_MOVEMENT = 50
	REACH_PLAYER_TIME = 0.3
	SPEED_ACTION = 0.1
	SPEED_GOING_BACK = 0.02
	REACTION_TIME = 0.8
	HP = 100#300
	HP_MAX = 100#300
	KO_Y = 30
	KO_X = 30
	SCORE = {'jab': 2, 'raw': 10, 'kick': 5, 'uppercut': 10, 'backfist': 5, 'backkick': 10}
	DAMAGE = {'jab': 0, 'raw': 10, 'kick': 10, 'uppercut': 15, 'backfist': 5, 'backkick': 10}
	INFLICTION = {'jab': 15, 'kick': 5}
	DOJO = 'highschool'
	PSGNAME = 'ky'
	MOV_WALK_PERC = 0
	MOV_RUN_PERC = 4
	MOV_DASH_PERC = 3
	MOV_GUARD_PERC = 2
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK
	self.status = self.STATES.WAITING_FOR_PLAYER

