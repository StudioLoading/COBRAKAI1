extends Node2D


onready var SPAWNERS = ['bri', 'cestino', 'lynn', 'rj', 'philippe', 'peter', 'dimitri', 'yazlaker', 'samlaker', 'moonlaker', 'aj']
onready var diags_spawned = {"rj": {"stage1":{'diags': 
	['Hey buddy','If you see Philippe,\nplease say hi!', 
	'ok? I guess\nhe has something for yah!'], 
											'achieved': false, 
											'achieved_to': 'philippe',
											'achieved_diags':['Good to see you bud!']
							}},
							"bri": {"stage1":{'diags': 
	['Hi, have you seen Peter?\nPlease tell him ', 
	'we got to record a new\npodcast interview!',
	'Ralph\'s gonna join us\nHe\'s my favourite!!'], 
											'achieved': false,
											'achieved_to': 'peter',
											'achieved_diags':['Thank you so much!\nSee you at Miyagi-Do!', 
															'<3\n...and please\ndon\'t hurt my Ralphie!\n<3'],
							},
							"stage6":{'diags': 
	['Hey, you know\nyour SCORE will be\nvaluable', 
	'at the end\nof this game',
	'reachin 100.000\nmeans something!\nyou\'ll see...'], 
											'achieved': false,
											'achieved_to': 'bri',
											'achieved_diags':['Hey, you know\nyour SCORE will be\nvaluable', 
															'at the end\nof this game',
															'reachin 100.000\nmeans something!\nyou\'ll see...'],
							}},
							"philippe": {"stage1":{'diags': 
	['Have you see RJ?\nYou know the one', 'with sunglass\nand cool looking...?'],
											'achieved': false,
											'achieved_to': '',
											'achieved_diags':['So you met RJ, is he cool\nor what ??'],
											'achieved_notyetspawned_diags': ['... and take this!!', 'It is ONE LIFE!']
							},
										"stage6":{'diags': 
	['I see...', 'You know how\nto kick some a... chairs!?'], 
											'achieved': false,
											'achieved_to': 'peter',
											'achieved_diags':['I see...', 'You know how\nto kick some a... chairs!?']
							}},
							"peter": {"stage1":{'diags': 
	['Hi, do you know\nCobra Kai Kompanion?\nIt is our podcast!', 
	'Listen to us\nyou will learn a lot\nof things!'], 
											'achieved': false,
											'achieved_to': 'bri',
											'achieved_diags':['So Bri told you?\nok then.\n'],
											'achieved_notyetspawned_diags': ['... and take this!!', 'It is some TIME!']
							},
							"stage6":{'diags': 
	['Are you ready?',
	'Watch how the\nreal crane kick\nis!'], 
											'achieved': false,
											'achieved_to': 'peter',
											'achieved_diags':['Are you ready?', 'Watch how the\nreal crane kick\nis!']
							}},
							"eli": {"stage4":{'diags': 
	['...'
	], 
											'achieved': false, 
											'achieved_to': 'eli',
											'achieved_diags':['Plastic surgeon...', '...\nfix lips.']
							}},
							"dimitri": {"stage4":{'diags': 
	['A skeleton, classy!!','... Sorcerer? Please!\nI\'m a Necromancer ?!','Here\'s our Eli,\nhow are you dressed?'
	], 
											'achieved': false, 
											'achieved_to': 'eli',
											'achieved_diags':['...']
							}},
							"yazlaker": {"stage4":{'diags': 
	['Where\'s Sam ?!', 'Tell her to get \nher ass over here.'], 
											'achieved': false, 
											'achieved_to': 'samlaker',
											'achieved_diags':['What do you want?']
							}},
							"samlaker": {"stage4":{'diags': 
	['Hey I am Sam\n but I should talk\nto Aisha...'], 
								'achieved': false, 
								'achieved_to': 'yazlaker',
								'achieved_diags':['Yaz callin?\nOk I go.', 'Tell Moon\nto join us!'],
								'achieved_notyetspawned_diags': ['... and take this!!', 'It is ONE LIFE!']
							}},
							"moonlaker": {"stage4":{'diags': 
	[''], 
								'achieved': true, 
								'achieved_to': 'moonlaker',
								'achieved_diags':['Hey I am Moon.', 'Yaz callin?\nOk I go.'],
								'achieved_notyetspawned_diags': ['... and take this!!', 'It is some SCORE!']
							}},
							"aj": {"stage6":{'diags': 
	['Hi', 'Have a smashin day\nwith some SCORE!',], 
											'achieved': false, 
											'achieved_to': 'aj',
											'achieved_diags':['"It\'s easy like a sunda..."','Wait, what day is it ?'],
											'achieved_notyetspawned_diags': ['Tuesday!']
							}},
							
							
							}
func _ready():
	pass 
