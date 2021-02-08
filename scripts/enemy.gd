extends KinematicBody2D


var sensible = false
var grab = false
var grab_ignore = false
var going_back_direction
var dir_to_player
var grab_player_position

signal hit_player

var speed_movement = 40
export var BASE_SPEED_MOVEMENT = 40
export var REACH_PLAYER_TIME = 1.4
export var SPEED_ACTION = 0.3
export var SPEED_GOING_BACK = 0.5
export var REACTION_TIME = 0.35

var HP = 20#150
export var HP_MAX = 20#150

var ko_y_count
var ko_y_max
export var KO_Y = 30
export var KO_X = 50

var SCORE = {'jab': 0, 'raw': 5, 'kick': 5, 'uppercut': 15, 'backfist': 20, 
				'backkick': 10, 'cranekick': 10, 'sweep': 20}
var DAMAGE = {'jab': 3, 'raw': 5, 'kick': 5, 'uppercut': 15, ',backfist': 15, 
				'backkick': 15, 'cranekick': 20, 'sweep': 20}
var INFLICTION = {'jab': 5, 'kick': 2}

enum STATES {IS_PLAYER_GRABBED, DASH, PLAYING_KO, IS_HIT, REACHING_PLAYER, GOING_BACK, WAITING_FOR_PLAYER, IS_SENSIBLE, STOP_BEING_SENSIBLE, PERFORMING_ATTACK, DEAD}
var status = STATES.WAITING_FOR_PLAYER
enum MOVEMENTS {WALK, RUN, DASH, GUARD}
export var MOV_WALK_PERC = 5
export var MOV_RUN_PERC = 1
export var MOV_DASH_PERC = 1
export var MOV_GUARD_PERC = 3

var mov

signal dead
signal show_enemy_on_gui
signal hide_enemy_on_gui
signal add_score

export var DOJO = 'highschool'

var wait_for_player

var PSGNAME = 'enemy'

var area_entered_name
onready var max_attacks = 4 
onready var rng = RandomNumberGenerator.new()
onready var dash = false
onready var effect_base = preload("res://sound/effects/hit.combo.1.ogg")
onready var effect_combo = preload("res://sound/effects/hit.combo.2.ogg")
onready var effect_catch = preload("res://sound/effects/hit.guard.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	status = null
	going_back_direction = Vector2.ZERO
	dir_to_player = Vector2.RIGHT
	mov = MOVEMENTS.WALK
	$AnimatedSprite.frames = preload("res://animations/enemy.tres")
	$AnimatedSprite.animation='stand'
	$reach_player.wait_time = REACH_PLAYER_TIME
	$move.wait_time=SPEED_ACTION
	$going_back.wait_time = SPEED_GOING_BACK
#	$reach_player.start()
	grab_player_position = $grab_player.position
	ko_y_count = 0
	ko_y_max = KO_Y
	$effects.stream = effect_base
	rng.randomize()
	change_status(self.status, null, null, null, false, Vector2.ZERO)
	pass # Replace with function body.

func move(action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing):
	if johnny_global_position == null:
		johnny_global_position  = self.global_position + Vector2(rand_range(0, 100), rand_range(0, 100))
		#	print(self.name ,' _on_reach_player_timeout() ', get_tree().get_root().get_node("stage"))
		if get_tree().get_root().get_node("stage"):
			johnny_global_position = get_tree().get_root().get_node("stage").get_player_global_position()
#	print('Ricalcolo di movimento, al momento sempre ', mov, ' in stato verso reaching_player')
	var new_mov
	match mov:
		MOVEMENTS.WALK:
			var r = rng.randi_range(1,10)
			if r < MOV_WALK_PERC:
				new_mov = MOVEMENTS.WALK
				self.speed_movement = BASE_SPEED_MOVEMENT
			elif r < (MOV_WALK_PERC + MOV_RUN_PERC):
				new_mov = MOVEMENTS.RUN
				self.speed_movement = BASE_SPEED_MOVEMENT * 1.8
			elif r < (MOV_WALK_PERC + MOV_RUN_PERC + MOV_GUARD_PERC):
				new_mov = MOVEMENTS.GUARD
				self.speed_movement = 0
			else:
				#valutiamo il dash, considerando la distanza enemy-player
				var d = self.global_position.distance_to(johnny_global_position)
				if d > 80:
					new_mov = MOVEMENTS.DASH
					self.speed_movement = BASE_SPEED_MOVEMENT * 4
				else:
					new_mov = MOVEMENTS.RUN
					self.speed_movement = BASE_SPEED_MOVEMENT * 1.8	
		MOVEMENTS.DASH:
			new_mov = MOVEMENTS.WALK
			self.speed_movement = BASE_SPEED_MOVEMENT
		MOVEMENTS.RUN, MOVEMENTS.GUARD:
				new_mov = MOVEMENTS.WALK
				self.speed_movement = BASE_SPEED_MOVEMENT
#	print(self.name, ' decide di ', MOVEMENTS.keys()[new_mov])
	self.mov = new_mov
	if new_mov == MOVEMENTS.DASH:
		change_status(STATES.DASH, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing)
	else:
		change_status(STATES.REACHING_PLAYER, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing)

func change_status(s, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing):
	if johnny_global_position == null:
		johnny_global_position = self.global_position + Vector2(rand_range(0, 100), rand_range(0, 100))
#		print(self.name ,' _on_reach_player_timeout() ', get_tree().get_root().get_node("stage"))
		if get_tree().get_root().get_node("stage"):
			johnny_global_position = get_tree().get_root().get_node("stage").get_player_global_position()
#	print('going toward position ', johnny_global_position)
	if status == null:
		status = s
	if self.status == STATES.GOING_BACK and combo_complete:
		#print(self.name,' going_back, prevent changing_status')
		return
#	print(self.name, ' changing status from ', STATES.keys()[self.status],' to ', STATES.keys()[s])
	match s:
		STATES.DEAD:
			set_process(false)
			wait_for_player = false
			grab = false
			sensible = false
			$move.stop()
			$reach_player.stop()
			#disappear()
		STATES.WAITING_FOR_PLAYER:
			$trigger/c.set_deferred("disabled", false)
			print(self.PSGNAME, ' setting disabled false')
			wait_for_player = true
			$reach_player.paused = true
			$move.stop()
#			sensible = false #non lo cambio perchè non c'è relazione!
			grab = false
			
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
			else:
				$AnimatedSprite.animation='stand'
			$AnimatedSprite.play()
			$reach_player.paused = false
			$reach_player.start()
#			emit_signal('hide_enemy_on_gui', self)

		STATES.PLAYING_KO:
			sensible = false
			grab = false
			wait_for_player = false
			$reach_player.paused = true
			$move.stop()
			if $hit:
				$hit.queue_free()
			if $grab_player:
				$grab_player.disconnect('area_exited', self, '_on_grab_player_area_exited')
				$grab_player.disconnect('area_entered', self, '_on_grab_player_area_entered')
				$grab_player.queue_free()
			$AnimatedSprite.animation = 'hit_back'
			set_process(true)

		STATES.IS_HIT:
			set_process(false)
			wait_for_player = false
			$move.paused=true
			$move.stop()
			#print(self.name, ' hit by ', action)
			if action == 'backfist':
				$AnimatedSprite.animation = 'hit_back'
			else:
				$AnimatedSprite.animation = 'hit'
			$AnimatedSprite.frame=0
			$hit_sprite.frame=0
			$hit_sprite.play()
			$AnimatedSprite.play()
			going_back_direction.x = self.global_position.x - johnny_global_position.x
			going_back_direction = going_back_direction.normalized()
			var damage = DAMAGE.get(action)
			if self.HP > damage:
				$effects.stream = effect_base
				var parata = false
				if (self.mov == self.MOVEMENTS.GUARD and !combo_complete) or damage == 0:
					$effects.stream = effect_catch
					parata = true
				$effects.play()
				if !parata:
					self.HP = self.HP - damage
					emit_signal('add_score', self.SCORE.get(action))
					emit_signal('show_enemy_on_gui', self)
				if johnny_global_position.x < self.global_position.x:
					$AnimatedSprite.flip_h = true
				if action == 'backfist' || combo_complete:
					if !parata:
						$effects.stream = effect_combo
					change_status(STATES.GOING_BACK, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing)
		#		#print(self.name, ' ', self.HP, '/', self.HP_MAX)
			else:
				self.HP = self.HP - damage
				emit_signal('show_enemy_on_gui', self)
				change_status(STATES.PLAYING_KO, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing)
			$effects.play()
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
				change_status(STATES.PERFORMING_ATTACK, action, johnny_global_position, johnny_going_left, combo_complete, johnny_dashing)
			return
		
		STATES.PERFORMING_ATTACK:
			$move.paused=false
			$move.start()
		
		STATES.GOING_BACK:
			set_process(true)
			grab = false
			$AnimatedSprite.frame=0
			$AnimatedSprite.animation='hit_back'
			$AnimatedSprite.play()
			$going_back.start()

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
		
		STATES.DASH:
			dash = true
			$reach_player.paused = true
			$timer_dash.start()
			$AnimatedSprite.animation='dash'
			$AnimatedSprite.play()
			
	self.status = s

func _process(delta):
	match self.status:
		STATES.IS_HIT, STATES.PERFORMING_ATTACK, STATES.DEAD:
			return
		STATES.PLAYING_KO:
			if ko_y_count == KO_Y:
				$AnimatedSprite.stop()
				$AnimatedSprite.animation='dead'
				var efx_collision_car = load("res://sound/effects/collision_car.wav")
				$effects.stream = efx_collision_car
				$effects.play()
				if $c:
					$c.disabled = true
				emit_signal('dead', self)
				$AnimatedSprite.play()
				change_status(STATES.DEAD,null, null, null, false, Vector2.ZERO)
				return
			else:
				$AnimatedSprite.animation = 'hit_back'
				var movement = Vector2.ZERO
		#		#print(self.name,' going back x dir: ', going_back_direction)
				movement.x = going_back_direction.x * KO_X
				ko_y_count += 1
				ko_y_max -= 1
				movement.y = ko_y_count- ko_y_max
				var collision = self.move_and_slide(movement)
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
					$AnimatedSprite.play()
		STATES.DASH:
#			print('stato dash, movement ', mov, ' animation: ', $AnimatedSprite.animation)
			if $AnimatedSprite.animation != 'dash':
				$AnimatedSprite.frame = 0
				$AnimatedSprite.animation ='dash'
				$AnimatedSprite.play()
			go_to_player(delta)
		STATES.REACHING_PLAYER:
			if self.mov == MOVEMENTS.GUARD:
				if $AnimatedSprite.animation != 'guard':
					$AnimatedSprite.animation = 'guard'
#					print('enemy order play for guard animation')
					$AnimatedSprite.play()
			go_to_player(delta)
	pass

func go_to_player(delta):
	if self.HP > 0 and !grab and dir_to_player != Vector2.ZERO:
#		print(self.PSGNAME,' speed_movement ', self.speed_movement)
		var vEffectiveMovement = self.dir_to_player * self.speed_movement * delta
#		print('enemy:go_to_player() vEffectiveMovement=', vEffectiveMovement)
		if vEffectiveMovement != Vector2.ZERO:
			if $AnimatedSprite.animation != 'walk' and !dash:
				$AnimatedSprite.animation = 'walk'
			if vEffectiveMovement.x >= 0 and $AnimatedSprite.flip_h:
				$AnimatedSprite.flip_h = false
				$grab_player.position = grab_player_position
			elif vEffectiveMovement.x < 0 and $AnimatedSprite.flip_h == false:
				$AnimatedSprite.flip_h = true
				$grab_player.position.x = -grab_player_position.x
#			print('Boss playing ', $AnimatedSprite.animation, '?', $AnimatedSprite.playing)
			var collision = move_and_collide(vEffectiveMovement)
#			print('enemy collision: ', collision)
			if collision:
#				print('enemy:go_to_player() collision=', collision, ' ', collision)
				if collision.collider:
#					print('enemy:go_to_player() collision.collider=', collision.collider, ' ', collision.collider.name)
					if collision.collider.is_in_group('player'):
#						print(self.name, ' collided: ', collision.collider.name)
						$timer_dash.stop()
						_on_timer_dash_timeout()
						change_status(STATES.IS_PLAYER_GRABBED, null, null, null, false, Vector2.ZERO)
					elif collision.collider.is_in_group('group_enemies'):
						if collision.collider.status == STATES.GOING_BACK:
							change_status(STATES.GOING_BACK, null, null, null, false, Vector2.ZERO)
							pass
					else:# sono in collisione con un ostacolo fisico dell' ambiente
#						while collision:
						vEffectiveMovement = vEffectiveMovement.rotated(0.1)
						move_and_collide(vEffectiveMovement)

func _on_hit_area_entered(area):
	if area.get_parent().is_in_group('item_kicking'):
#		print(self.name, ' hit by an item_kicking! ', area.get_parent().name)
#		print('item_kicking moving ? ', area.get_parent().moving)
		if area.get_parent().moving:
			change_status(STATES.IS_HIT, 'raw', null, null, false, Vector2.ZERO)
	if area.get_parent().get_parent().is_in_group('player'):
		#print(self.PSGNAME, ' si sensibilizza su area entrante ', area.name)
		if area_entered_name == null:
			area_entered_name = area.name
			change_status(STATES.IS_SENSIBLE, null, null, null, false, Vector2.ZERO)
	pass

func _on_hit_area_exited(area):
	if area.get_parent().get_parent().is_in_group('player'):
		#print(self.PSGNAME, ' si desensibilizza su ', area.name)
		if self.status != self.STATES.PLAYING_KO: #area.name == area_entered_name and 
			if area_entered_name != null:
				area_entered_name = null
				change_status(STATES.STOP_BEING_SENSIBLE, null, null, null, false, Vector2.ZERO)
	pass # Replace with function body.

func hit(action, johnny_global_position, johnny_going_left, combo_completed):
#	print(self.PSGNAME, ' ricevo hit ma sono sensibile? ', self.sensible
	if sensible and (self.mov != self.MOVEMENTS.GUARD or combo_completed):
#		print(self.name, ' hit by ', action)
		change_status(STATES.IS_HIT, action, johnny_global_position, johnny_going_left, combo_completed, Vector2.ZERO)
	pass

func _on_reach_player_timeout():
#	print(self.name, ' reach_player timer timeout')
	#questo if perchè potrebbe essere morto e quindi in reload
	if status == STATES.WAITING_FOR_PLAYER:
		$reach_player.stop()
		return
	var pGpos = self.global_position + Vector2(rand_range(0, 100), rand_range(0, 100))
#	print(self.name ,' _on_reach_player_timeout() ', get_tree().get_root().get_node("stage"))
	if get_tree().get_root().get_node("stage"):
		pGpos = get_tree().get_root().get_node("stage").get_player_global_position()
	var eGpos = self.global_position
	if pGpos.x > eGpos.x:
		pGpos.x -= 15
	else:
		pGpos.x += 15
	var hit : Vector2 = Vector2.ZERO
	hit.x = pGpos.x - eGpos.x
	hit.y = pGpos.y - eGpos.y
	self.dir_to_player = hit.normalized()
#	print('ogni tanto non lo faccio proprio puntare al player, ma lo muovo solo sull asse x')
#	var r = rng.randi_range(1,2)
#	if r < 2:
#		self.dir_to_player.y = 0
	move(null, null, pGpos, false, Vector2.ZERO)
	pass # Replace with function body.

func _on_grab_player_area_entered(area):
#	print(self.name, ' grab area area entered: ', area.name, ', parent area name:', area.get_parent().name, ', area.get_parent().get_parent() name: ', area.get_parent().get_parent().name)
	if area.name == 'hit' and area.get_parent().get_parent().is_in_group('player'):
		var dashing_vector = Vector2.ZERO
		if area.get_parent().get_parent().dash:
			dashing_vector.x = area.get_parent().get_parent().global_position.x - self.global_position.x
			dashing_vector = dashing_vector.normalized()
#		print(self.name, ' invoking change_status(is_player_grabbed')
		change_status(STATES.IS_PLAYER_GRABBED, null, area.get_parent().get_parent().global_position, null, false, dashing_vector)
	pass # Replace with function body.

func _on_grab_player_area_exited(area):
#	if area.name == 'hit' and 
	if area.name == 'hit' and area.get_parent().get_parent().is_in_group('player'):
#		#print(self.name, ' grab area area exited: ', area.name, ', parent area name:', area.get_parent().name)
		grab = false
		if status != STATES.GOING_BACK:
			emit_signal('hide_enemy_on_gui', self)
			move(null, null, null, false, Vector2.ZERO)
	pass # Replace with function body.

func _on_move_timeout():
#	print(self.name, ' status=', status ,',  grab=', grab,' move timeout parte la ghega!')
	if self.HP <= 0 or self.status == STATES.WAITING_FOR_PLAYER:
		return
	if status == STATES.IS_HIT:
#		print('ristarto move_timer perchè nel mentre sono stato colpito')
		change_status(STATES.PERFORMING_ATTACK, null, null, null, false, Vector2.ZERO)
		#print('perform action')
	elif grab or grab_ignore:
		var attack = rng.randi_range(0 ,self.INFLICTION.size()-1)
#		print('è scaduto timeout, ho player ancora grab, starto animazione attacco')
		var r = INFLICTION.keys()[attack]
#		print('attack = ', attack, ' from infliction ', r)
		$AnimatedSprite.animation = r 
		$AnimatedSprite.play()
	else:
#		print('non l ho più grab, non sono stato colpito, torno in REACHING')
		move(null, null, null, false, Vector2.ZERO)
	pass

func _on_AnimatedSprite_animation_finished():
#	print(self.name, ' _on_AnimatedSprite_animation_finished ', $AnimatedSprite.animation)
	if status == STATES.PLAYING_KO || status == STATES.DASH:
		pass
	else:
		if $AnimatedSprite.animation in INFLICTION.keys():
#			print('emit_signal hit_player with infliction ', self.INFLICTION.get('jab'))
			emit_signal('hit_player', self.INFLICTION.get('jab'), self)
			$AnimatedSprite.animation='stand'
			if grab:
				$move.paused=false
				$move.start()
	#			#print(self.name, ' sends signal ')
			else:
				move(null, null, null, false, Vector2.ZERO)
		elif $AnimatedSprite.animation == 'hit':
#			print('terminata animazione hit colpo subito. grab? ', grab)
			$AnimatedSprite.animation='stand'
			if grab:
				change_status(STATES.PERFORMING_ATTACK, null, null, null, false, Vector2.ZERO)
			else:
				move(null, null, null, false, Vector2.ZERO)
		elif $AnimatedSprite.animation == 'dead' or $AnimatedSprite.animation == 'down':
			yield(get_tree().create_timer(REACTION_TIME), "timeout")
			if self.HP > 0:
				move(null, null, null, false, Vector2.ZERO)
			else:
				self.disappear()
	pass # Replace with function body.

func _on_timer_dash_timeout():
	dash = false
	$reach_player.paused = false
	move(null, null, null, false, Vector2.ZERO)
	pass # Replace with function body.

func disappear():
	self.queue_free()
	pass
#	yield(get_tree().create_timer(0.2), "timeout")
#	$AnimatedSprite.hide()
#	yield(get_tree().create_timer(0.2), "timeout")
#	$AnimatedSprite.show()
#	yield(get_tree().create_timer(0.2), "timeout")
#	$AnimatedSprite.hide()
#	yield(get_tree().create_timer(0.2), "timeout")
#	$AnimatedSprite.show()
#	yield(get_tree().create_timer(0.2), "timeout")
#	$AnimatedSprite.hide()
#	yield(get_tree().create_timer(0.2), "timeout")
#	$AnimatedSprite.hide()
#	yield(get_tree().create_timer(0.2), "timeout")
#	$AnimatedSprite.show()
#	yield(get_tree().create_timer(0.2), "timeout")
#	$AnimatedSprite.hide()
	
func pause_resume(paused, with_paused_menu):
#	print(self.PSGNAME, ' paused_resume() ', paused)
	set_process(!paused)
	if $reach_player.time_left > 0:
		$reach_player.paused = paused
	if $going_back.time_left > 0:
		$going_back.paused = paused
	if $move.time_left > 0:
		$move.paused = paused
	if $timer_dash.time_left > 0:
		$timer_dash.paused = paused
	if paused:
		$effects.stream = null
	$AnimatedSprite.playing = !paused

func _on_trigger_body_entered(body):
	if body.is_in_group('player'):
		print(self.name, ' parte')
		wait_for_player = false
		$trigger/c.set_deferred("disabled", true)
		change_status(STATES.REACHING_PLAYER, null, null, null, false, Vector2.ZERO)
	pass # Replace with function body.

func is_on_screen():
	return $v.is_on_screen()
