extends "res://scripts/enemy.gd"
#ENEMY 3
func _ready():
	speed_movement = 40
	REACH_PLAYER_TIME = 3
	SPEED_ACTION = 0.07
	SPEED_GOING_BACK = 0.4
	HP = 80#300
	HP_MAX = 80#300
	KO_Y = 30
	KO_X = 30
	SCORE = {'jab': 6, 'raw': 10, 'kick': 10, 'backfist': 10, 'backkick': 15}
	DAMAGE = {'jab': 6, 'raw': 10, 'kick': 10, 'backfist': 10, 'backkick': 15}
	INFLICTION = {'jab': 8}
	DOJO = 'cobra'
	PSGNAME='kreese'
