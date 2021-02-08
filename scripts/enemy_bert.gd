extends "res://scripts/enemy.gd"
#ENEMY bert
signal defeated 

func _ready():
	$AnimatedSprite.frames = load('res://animations/bert.tres')
	BASE_SPEED_MOVEMENT = 60
	REACH_PLAYER_TIME = 1
	SPEED_ACTION = 0.17
	SPEED_GOING_BACK = 0.7
	REACTION_TIME = 0.25
	HP = 90#300
	HP_MAX = 90#300
	KO_Y = 30
	KO_X = 30
	SCORE = {'jab': 5, 'raw': 10, 'kick': 10, 'uppercut': 30, 'backfist': 0, 'backkick': 10, 'cranekick': 90}
	DAMAGE = {'jab': 5, 'raw': 10, 'kick': 10, 'uppercut': 30, 'backfist': 0, 'backkick': 10, 'cranekick': 90}
	INFLICTION = {'jab': 2, 'kick': 4}
	DOJO = 'cobra'
	PSGNAME='bert'
	MOV_WALK_PERC = 1
	MOV_RUN_PERC = 8
	MOV_DASH_PERC = 0
	MOV_GUARD_PERC = 1
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK

func disappear():
	$AnimatedSprite.play('guard')
	emit_signal('defeated')
	pass
