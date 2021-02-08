extends "res://scripts/enemy.gd"
#ENEMY 2
func _ready():
	SPEED_MOVEMENT = 20
	REACH_PLAYER_TIME = 4
	SPEED_ACTION = 0.1
	SPEED_GOING_BACK = 0.7
	HP = 80#300
	HP_MAX = 80#300
	KO_Y = 30
	KO_X = 30
	SCORE = {'jab': 6, 'raw': 10, 'kick': 10, 'backfist': 10}
	DAMAGE = {'jab': 6, 'raw': 10, 'kick': 10, 'backfist': 10}
	INFLICTION = {'jab': 8}
	DOJO = 'highschool'
	PSGNAME='ciccione'