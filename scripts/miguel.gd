extends "res://scripts/Johnny.gd"

var step_train
var efx_flex

signal flex
signal flex_completed
signal jab
signal raw
signal kick
signal backkick


func _ready():
	$AnimatedSprite.frames = load("res://animations/Miguel.tres")
	efx_flex = preload("res://sound/effects/lesss.ogg")
	PSGNAME='Miguel'
	TIMER_DASH = 0.25
	TIMER_INPUT_FREQ = 0.3
#	$timer_input_freq.paused = true
	breaths = [{'attack': 'jab', 'breath': 8}, {'attack': 'raw', 'breath': 16},
	{'attack': 'uppercut', 'breath': 24}, {'attack': 'kick', 'breath': 8}, 
	{'attack': 'backkick', 'breath': 12}, {'attack': 'cranekick', 'breath': 24},
	{'attack': 'backfist', 'breath': 16}]
	combo_unlocked = [false, false, false, false, false]
	$timer_dash.wait_time = TIMER_DASH
	$timer_input_freq.wait_time = TIMER_INPUT_FREQ
	pass

func _input(event):
#	print('Miguel _input() on_train?', on_train)
	if on_train:
		if event.is_pressed():
#			print('timer_input_freq ', $timer_input_freq.time_left)
			if !$timer_input_freq.paused and $timer_input_freq.time_left > 0:
				print('MIGUEL scarto input perche troppo vicino al precedente')
				return
			$timer_input_freq.paused = false
			$timer_input_freq.start()
#			print('Miguel step_train: ', step_train)
			match step_train:
				'flex':
#					print('flex!')
					emit_signal('flex')
					if $AnimatedSprite.frame == 3:
#						print('Miguel: flex on frame 2 emitsignal flex_completed')
						$effect.stream = efx_flex
						$effect.play()
						emit_signal('flex_completed')
				'jabs':
					if event.is_action('ui_punch'):
#						print('Miguel: jab captured in _input')
						$AnimatedSprite.animation='jab'
						$AnimatedSprite.play()
				'kicks':
					if event.is_action('ui_kick'):
#						print('Miguel: kick captured in _input')
						$AnimatedSprite.animation='kick'
						$AnimatedSprite.play()
				'raws':
					if event.is_action('ui_punch'):
						if last_three_inputs.size() == 0:
							$timer_combo.start()
						last_three_inputs.push_back('jab')
						if last_three_inputs.size() > 3:
							print('Miguel input on_train raws last_three_inputs > 3')
							last_three_inputs.clear()
							$timer_combo.start()
						var combo_base_completed = false
						if last_three_inputs.size() == 3:
							combo_base_completed = true
							for i in last_three_inputs:
								if i != 'jab':
									combo_completed = false
							print('Miguel input on_train raws last_three_inputs == 3')							
							last_three_inputs.clear()
						if combo_base_completed:
							$AnimatedSprite.animation='raw'
							$AnimatedSprite.play()
						else:
							$AnimatedSprite.animation='jab'
							$AnimatedSprite.play()
					else:
						last_three_inputs.push_back('other')
				'backkicks':
					if event.is_action('ui_kick'):
						if last_three_inputs.size() == 0:
							$timer_combo.start()
						last_three_inputs.push_back('kick')
						if last_three_inputs.size() > 3:
							print('Miguel input on_train backkicsk last_three_inputs > 3')
							last_three_inputs.clear()
							$timer_combo.start()
						var combo_completed = false
						if last_three_inputs.size() == 3:
							combo_completed = true
							for i in last_three_inputs:
								if i != 'kick':
									combo_completed = false
							print('Miguel input on_train backkicks last_three_inputs == 3')
							last_three_inputs.clear()
						if combo_completed:
							$AnimatedSprite.animation='backkick'
							$AnimatedSprite.play()
						else:
							$AnimatedSprite.animation='kick'
							$AnimatedSprite.play()
					else:
						last_three_inputs.push_back('other')
				'dodge':
#					print('MIGUEL event on step dodge')
					if event.is_action('ui_up'):
						$AnimatedSprite.animation = 'dodge_up'
					elif event.is_action('ui_down'):
						$AnimatedSprite.animation = 'dodge_down'
					elif event.is_action('ui_left'):
						$AnimatedSprite.animation = 'dodge_left'
					elif event.is_action('ui_right'):
						$AnimatedSprite.animation = 'dodge_right'
					$AnimatedSprite.play()
					

func on_train_AnimatedSprite_animation_finished():
#	print('on_train_AnimatedSprite_animation_finished step_train=', step_train, ' animation=', $AnimatedSprite.animation)
#	print('miguel on train animation finished')
	match step_train:
		'jabs':
			if $AnimatedSprite.animation == 'jab':
				print('miguel finished animation jab, emit jab signal')
				emit_signal('jab')
				$AnimatedSprite.animation='guard'
				$AnimatedSprite.play()
		'raws':
			if $AnimatedSprite.animation == 'jab':
				emit_signal('jab')
				$AnimatedSprite.animation='guard'
				$AnimatedSprite.play()
			if $AnimatedSprite.animation == 'raw':
				emit_signal('raw')
				$AnimatedSprite.animation='guard'
				$AnimatedSprite.play()
		'kicks':
			if $AnimatedSprite.animation == 'kick':
				print('miguel finished animation kick, emit kick signal')
				emit_signal('kick')
				$AnimatedSprite.animation='guard'
				$AnimatedSprite.play()
		'backkicks':
			if $AnimatedSprite.animation == 'kick':
				emit_signal('kick')
				$AnimatedSprite.animation='guard'
				$AnimatedSprite.play()
			if $AnimatedSprite.animation == 'backkick':
				emit_signal('backkick')
				$AnimatedSprite.animation='guard'
				$AnimatedSprite.play()
		'dodge':
				$AnimatedSprite.animation='dodge_guard'
				$AnimatedSprite.play()
	pass

func on_train_timer_combo_timeout():
	if on_train:
		match step_train:
			'raws':
				print('Miguel on_train_timer_combo_timeout on_train raws')
				last_three_inputs.clear()
			'backkicks':
				print('Miguel on_train_timer_combo_timeout on_train backkicks')
				last_three_inputs.clear()
	pass

