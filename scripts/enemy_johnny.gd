extends "res://scripts/enemy.gd"
#ENEMY JOHNNY
signal defeated 

func _ready():
	$AnimatedSprite.frames = load('res://animations/Johnny_gi.tres')
	$AnimatedSprite.play('guard')
	BASE_SPEED_MOVEMENT = 50
	REACH_PLAYER_TIME = 1
	SPEED_ACTION = 0.03
	SPEED_GOING_BACK = 0.7
	REACTION_TIME = 0.1
	HP = 100#300
	HP_MAX = 100#300
	KO_Y = 30
	KO_X = 30
	SCORE = {'jab': 0, 'raw': 0, 'kick': 0, 'uppercut': 0, 'backfist': 0, 'backkick': 0, 'cranekick': 20}
	DAMAGE = {'jab': 0, 'raw': 0, 'kick': 0, 'uppercut': 0, 'backfist': 0, 'backkick': 0, 'cranekick': 20}
	INFLICTION = {'jab': 20, 'kick': 20, 'raw': 20}
	DOJO = 'cobra'
	PSGNAME='johnny'
	MOV_WALK_PERC = 3
	MOV_RUN_PERC = 0
	MOV_DASH_PERC = 1
	MOV_GUARD_PERC = 6
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK


func disappear():
	$AnimatedSprite.play('guard')
	emit_signal('defeated')
	pass
