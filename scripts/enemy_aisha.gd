extends "res://scripts/enemy.gd"
#ENEMY aisha

signal defeated 


func _ready():
	$AnimatedSprite.frames = load('res://animations/aisha.tres')
	BASE_SPEED_MOVEMENT = 40
	REACH_PLAYER_TIME = 1
	SPEED_ACTION = 0.13
	SPEED_GOING_BACK = 0.7
	REACTION_TIME = 0.2
	HP = 60#300
	HP_MAX = 60#300
	KO_Y = 30
	KO_X = 30
	SCORE = {'jab': 0, 'raw': 0, 'kick': 5, 'uppercut': 10, 'backfist': 0, 'backkick': 20, 'cranekick': 30, 'sweep': 50}
	DAMAGE = {'jab': 0, 'raw': 0, 'kick': 5, 'uppercut': 10, 'backfist': 0, 'backkick': 20, 'cranekick': 30, 'sweep': 90}
	INFLICTION = {'jab': 10, 'kick': 10, 'raw': 10}
	DOJO = 'cobra'
	PSGNAME = 'aisha'
	MOV_WALK_PERC = 8
	MOV_RUN_PERC = 0
	MOV_DASH_PERC = 0
	MOV_GUARD_PERC = 2
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK


func disappear():
	$AnimatedSprite.play('guard')
	emit_signal('defeated')
	pass
