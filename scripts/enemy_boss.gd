extends "res://scripts/enemy.gd"

onready var positions = []
onready var positions_going_to_index = 0
onready var HIT_ATTACKS = []
signal boss_defeated
onready var efx_step = preload("res://sound/effects/step.ogg")
onready var efx_hit = preload("res://sound/effects/boss_hit.ogg")
onready var efx_loaded_attack = preload("res://sound/effects/hit.loaded_boss.ogg")

func _ready():
	print('BOSS ready')
	$trigger/c.set_deferred('disabled', true)

func config():
	self.positions.clear()
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK
	self.mov = MOVEMENTS.WALK
	self.grab_ignore = true
	self.status = STATES.WAITING_FOR_PLAYER
	self.speed_movement = BASE_SPEED_MOVEMENT

func add_position(new_pos):
	positions.push_back(new_pos)
#	print('BOSS: positions: ', self.positions)

func next_position():
	positions_going_to_index = (positions_going_to_index+1) % positions.size()
	var p = positions[positions_going_to_index].global_position
	var hit : Vector2 = Vector2.ZERO
	hit.x = p.x - self.global_position.x
	hit.y = p.y - self.global_position.y
#	print('BOSS: going to =', p)
	self.dir_to_player = hit.normalized()
	if self.status != STATES.WAITING_FOR_PLAYER and $wakeup.time_left == 0:
		change_status(STATES.PERFORMING_ATTACK, null, null, null, null, null)
	

func move(action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing):
	print('BOSS: move()')
#	self.mov == MOVEMENTS.WALK
	var new_mov = self.mov
	var r = rng.randi_range(1,10)
	if r < MOV_WALK_PERC:
		new_mov = MOVEMENTS.WALK
		self.speed_movement = BASE_SPEED_MOVEMENT
	elif r < (MOV_WALK_PERC + MOV_RUN_PERC):
		new_mov = MOVEMENTS.RUN
		self.speed_movement = BASE_SPEED_MOVEMENT * 1.8
	elif r < (MOV_WALK_PERC + MOV_RUN_PERC + MOV_GUARD_PERC):
		new_mov = MOVEMENTS.GUARD
#		self.speed_movement = 0
	self.mov = new_mov
	change_status(STATES.REACHING_PLAYER, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing)
	return

func change_status(s, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing):
	if s and self.status:
		print('BOSS: change_status() from ', self.STATES.keys()[self.status], ' to ', self.STATES.keys()[s])
		if self.status == self.STATES.DEAD:
			return
	if s == self.status:
		return
	if johnny_global_position == null:
		johnny_global_position = self.global_position + Vector2(rand_range(0, 100), rand_range(0, 100))
#		print(self.name ,' _on_reach_player_timeout() ', get_tree().get_root().get_node("stage"))
		if get_tree().get_root().get_node("stage"):
			johnny_global_position = get_tree().get_root().get_node("stage").get_player_global_position()
	print(self.name, ' going toward position ', johnny_global_position)
	if positions and positions.size() >= 2:
		johnny_global_position = positions[positions_going_to_index].global_position
		print(self.name, ' positions array used ', johnny_global_position)
	if status == null:
		status = s
	if self.status == STATES.GOING_BACK and combo_complete:
		#print(self.name,' going_back, prevent changing_status')
		return
	if johnny_global_position.x < self.global_position.x:
		$AnimatedSprite.flip_h = true
		if $grab_player:
			$grab_player.position.x = -grab_player_position.x
	else:
		$AnimatedSprite.flip_h = false
		if $grab_player:
			$grab_player.position.x = grab_player_position.x
	match s:
		STATES.PLAYING_KO:
			sensible = false
			grab = false
			wait_for_player = false
			$reach_player.paused = true
			$move.stop()
			$timer_dash.stop()
			$reach_player.stop()
			if $grab_player:
				$grab_player.disconnect('area_exited', self, '_on_grab_player_area_exited')
				$grab_player.disconnect('area_entered', self, '_on_grab_player_area_entered')
				$grab_player.queue_free()
			$AnimatedSprite.animation = 'hit_back'
			set_process(true)
			$walk.set_deferred("disabled",true)
			$hit.set_deferred("disabled",true)
			$c.set_deferred("disabled",true)
			
		STATES.DEAD:
			set_process(false)
			wait_for_player = false
			grab = false
			sensible = false
			$move.stop()
			$reach_player.stop()
			
		STATES.IS_HIT:
			if !(action in HIT_ATTACKS):
				return
			set_process(false)
			wait_for_player = false
			$move.paused=true
			$move.stop()
			#print(self.name, ' hit by ', action)
			if action == 'backfist':
				$AnimatedSprite.play('hit_back')
			else:
				$AnimatedSprite.play('hit')
			$hit_sprite.frame=0
			$hit_sprite.play()
			going_back_direction.x = self.global_position.x - johnny_global_position.x
			going_back_direction = going_back_direction.normalized()
			var damage = DAMAGE.get(action)
			if self.HP > damage:
				$effects.stream = effect_base
				$effects.play()
				self.HP = self.HP - damage
				emit_signal('add_score', self.SCORE.get(action))
				emit_signal('show_enemy_on_gui', self)
				if action == 'backfist' || combo_complete:
					$effects.stream = effect_combo
					$effects.play()
					change_status(STATES.GOING_BACK, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing)
					return
		#		#print(self.name, ' ', self.HP, '/', self.HP_MAX)
			else:
				self.HP = self.HP - damage
				emit_signal('show_enemy_on_gui', self)
				change_status(STATES.PLAYING_KO, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing)
				return
		#		#print(self.name,' update_HP() play_ko')
		STATES.IS_PLAYER_GRABBED:
			set_process(true)
			$reach_player.paused = true
			$reach_player.stop()
			if johnny_dashing != Vector2.ZERO:
				self.collision_layer = 4
				if johnny_dashing == Vector2.RIGHT:
					self.global_position.x += 15
				else:
					self.global_position.x -= 15
				self.collision_layer = 1
				grab = false
			else:
				grab = true
				emit_signal('show_enemy_on_gui', self)
				print('boss invoking change_status(PERFORMING_ATTACK)')
				change_status(STATES.PERFORMING_ATTACK, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing)
			return
		
		STATES.PERFORMING_ATTACK:
			$move.paused=false
			$move.start()
			print('boss $move counter started')
		
		STATES.IS_SENSIBLE:
			if !sensible and self.status != STATES.IS_HIT:
				#print('change status to is sensible.')
				emit_signal('show_enemy_on_gui', self)
				sensible = true
			return

		STATES.STOP_BEING_SENSIBLE:
			if sensible:
#				print('change status to stop being sensible.')
				emit_signal('hide_enemy_on_gui', self)
				sensible = false
				if grab:
					move(action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing)
			return
			
		STATES.REACHING_PLAYER:
			$move.stop()
			if self.status == STATES.IS_HIT:
				pass
			set_process(true)
			wait_for_player = false
			grab = false
#			sensible = false #non lo cambio perchè non c'è relazione!
			if self.mov == MOVEMENTS.GUARD:
				$AnimatedSprite.animation='guard'
				print('BOSS executing play to guard')
				$AnimatedSprite.play()
#			else:
#				$AnimatedSprite.animation='stand'
			$reach_player.paused = false
			$reach_player.start()
	self.status = s

func _on_reach_player_timeout():
	print('BOSS: _on_reach_player_timeout()')
	return

func _on_trigger_body_entered(body):
	print('BOSS: _on_trigger_body_entered()')
	return

func disappear():
	$AnimatedSprite.animation = 'guard'
	emit_signal('boss_defeated')


func _process(delta):
	match self.status:
		STATES.IS_HIT, STATES.PERFORMING_ATTACK, STATES.DEAD:
			return
		STATES.PLAYING_KO:
			print('boss: ko_y_count ', ko_y_count, '/', KO_Y,' KO_Y')
			if ko_y_count == KO_Y:
				$AnimatedSprite.stop()
				$AnimatedSprite.animation='dead'
				var efx_collision_car = load("res://sound/effects/collision_car.wav")
				$effects.stream = efx_collision_car
				$effects.play()
				if $c:
					$c.disabled = true
				emit_signal('dead', self)
				print('BOSS executing play')
				$AnimatedSprite.play()
				change_status(STATES.DEAD,null, null, null, false, Vector2.ZERO)
				return
			else:
				if $AnimatedSprite.animation != 'hit_back':
					$AnimatedSprite.animation = 'hit_back'
				var movement = Vector2.ZERO
#				print(self.name,' going back x dir: ', going_back_direction)
				movement.x = going_back_direction.x * KO_X
				ko_y_count += 1
				ko_y_max -= 1
				movement.y = ko_y_count- ko_y_max
				self.move_and_slide(movement)
				print('boss move and slide')
			pass
		STATES.GOING_BACK:
			if $going_back.time_left > 0:
				var movement = Vector2.ZERO
				movement.x = going_back_direction.x * 2
				movement.y = -$going_back.time_left
				var collision = self.move_and_collide(movement)
			else:
				if $AnimatedSprite.animation != 'down':
					$AnimatedSprite.animation = 'down'
					print('BOSS executing play')
					$AnimatedSprite.play()
		STATES.DASH:
	#			print('stato dash, movement ', mov, ' animation: ', $AnimatedSprite.animation)
			if $AnimatedSprite.animation != 'dash':
				$AnimatedSprite.frame = 0
				$AnimatedSprite.animation ='dash'
				print('BOSS executing play')
				$AnimatedSprite.play()
			go_to_player(delta)
		STATES.REACHING_PLAYER:
#			print('Boss process REACHING_PLAYER mov=', self.mov)
#			print('Boss process REACHING_PLAYER animation=', $AnimatedSprite.animation)
#			print('Boss process REACHING_PLAYER playing=', $AnimatedSprite.playing)
			if self.mov == MOVEMENTS.GUARD:
#				print('Boss process REACHING_PLAYER with mov==GUARD')
				if $AnimatedSprite.animation != 'guard':
					$AnimatedSprite.play('guard')
			elif self.mov == MOVEMENTS.WALK:
				if $AnimatedSprite.animation != 'walk':
					$AnimatedSprite.play('walk')
			go_to_player(delta)
	return


func _on_AnimatedSprite_frame_changed():
	match $AnimatedSprite.animation:
		'raw':
			if $AnimatedSprite.frame == 1:
				$effects.stream = efx_loaded_attack
				$effects.play()
		'hit', 'dead':
			$effects.stream = efx_hit
			$effects.play()
	pass # Replace with function body.


func _on_wakeup_timeout():
	print(self.PSGNAME, ' BOSS wakeup timeout')
	next_position()
	pass
