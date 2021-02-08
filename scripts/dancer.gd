extends KinematicBody2D


enum TYPE {AISHA, BLONDIE_BLACK, BROWN, KUMIKO_GRAY_RED, KUMIKO_ORANGE, KUMIKO_YELLOW, SKELETON, MOONWALKER}
enum DANCE {NORMAL, BOOGIE, MOON, STAND, TALK}

var anim_dance
var anim_type

func _ready():
	pass 
 
func config(type, dance):
	#print('configuring type ', type, ' dance ', dance)
	match type:
		TYPE.AISHA:
			print('match with TYPE.AISHA')
			$a.animation = 'aisha'
		TYPE.BLONDIE_BLACK:
			anim_type = 'blondie_black_'
		TYPE.BROWN:
			anim_type = 'brown_black_'
		TYPE.KUMIKO_GRAY_RED:
			anim_type = 'kumiko_gray_red_'
		TYPE.KUMIKO_ORANGE:
			anim_type = 'kumiko_orange_'
		TYPE.KUMIKO_YELLOW:
			anim_type = 'kumiko_yellow_'
		TYPE.MOONWALKER:
			print('match with TYPE.MOONWALKER')
			anim_type = 'moonwalker'
		TYPE.SKELETON:
			anim_type = 'skeleton'
	if type != TYPE.SKELETON and type != TYPE.MOONWALKER:
		match dance:
			DANCE.NORMAL:
				anim_dance = 'normal'
			DANCE.STAND:
				anim_dance = 'stand'
			DANCE.BOOGIE:
				anim_dance = 'boogie'
			DANCE.TALK:
				anim_dance = 'talk'
	if type == TYPE.MOONWALKER:
		anim_dance = 'moonwalker'
	var animation = anim_type
	if anim_dance:
		animation = str(anim_type, anim_dance)
#	print(animation)
	$a.animation = animation
	
func dance():
#	print('dance func, anim_dance : ', anim_dance)
	match anim_dance:
		'normal':
			$a.playing = true
		'boogie':
			$a.playing = true
		'talk':
			$a.playing = true
		'moonwalker':
			print('codice per animazione moonwalker')
			
func flip():
	$a.flip_h = true
