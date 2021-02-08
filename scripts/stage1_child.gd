extends "res://scripts/stage_father.gd"


func _ready():
	STAGE_TIMER = 79
	STAGE_NUMBER = 1
	NO_TIME_STAGE = false

	stage_bg = preload("res://sound/stage1.ogg")

	$bgm.stream = stage_bg
	$bgm.play()
	
	$YSort/lynn.config($YSort/lynn.TYPES.SCORE, 'lynn', $YSort/player, true, false, $diags)
	$YSort/bri.config($YSort/bri.TYPES.DIAG, 'bri', $YSort/player, false, false, $diags)
	$YSort/rj.config($YSort/rj.TYPES.DIAG, 'rj', $YSort/player, false, false, $diags)
	$YSort/philippe.config($YSort/rj.TYPES.LIFE, 'philippe', $YSort/player, false, false, $diags)
	$YSort/peter.config($YSort/rj.TYPES.TIME, 'peter', $YSort/player, false, false, $diags)
	$YSort/park0.config($YSort/park0.TYPES.SCORE, 'park', $YSort/player, true, true, $diags)
	$YSort/park1.config($YSort/park1.TYPES.SCORE, 'park', $YSort/player, true, true, $diags)
	
	$YSort/player/AnimatedSprite.frames = preload("res://animations/Johnny.tres")
	
	$GUI/player.config($YSort/player, STAGE_TIMER, NO_TIME_STAGE)
	
	init_player()
	
	pass # Replace with function body.

	
func reset_player_position():
	$YSort/player.global_position = $YSort/spawn_johnny.global_position


func play_outro_stage():
	print('play_outro_stage del stage1_child')
	$bgm.stop()
	$YSort/player.pause_resume(false)
	var bg_outro = load("res://sound/softsuspance.ogg")
	$bgm.stream = bg_outro
	$bgm.play()
#	print('playing outro')
	$Tween.interpolate_property($YSort/police_car, "global_position", $YSort/police_car.global_position, $YSort/player/pos_police_car.global_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	$YSort/police_car/policeman.animation = 'walk'
	$YSort/police_car/policeman.play()
	$Tween.interpolate_property($YSort/police_car/policeman, "global_position", 
		 $YSort/police_car/policeman.global_position, Vector2($YSort/player.global_position.x - 20, $YSort/player.global_position.y ), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	$YSort/police_car/policeman.animation = 'jab'
	$YSort/police_car/policeman.play()
	$YSort/player.disconnect("player_down", self, '_on_player_down')
	$YSort/player/AnimatedSprite.animation = 'dead'
	$YSort/player/AnimatedSprite.play()
	yield(get_tree().create_timer(2.5), "timeout")
	play_outro()
	pass
