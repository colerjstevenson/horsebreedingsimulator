extends Control


func _ready():
	if Settings.difficulty == "EASY":
		$Easy.disabled = true
		$Normal.disabled = false
		$Hard.disabled = false
	elif Settings.difficulty == "NORMAL":
		$Easy.disabled = false
		$Normal.disabled = true
		$Hard.disabled = false
	else:
		$Easy.disabled = false
		$Normal.disabled = false
		$Hard.disabled = true
		
	if Settings.music_player.volume_db == 0:
		$On.disabled = true
		$Off.disabled = false
	else:
		$On.disabled = false
		$Off.disabled = true


func _on_music_pressed(type):
	if type == "ON":
		$On.disabled = true
		$Off.disabled = false
		Settings.music_player.volume_db = 0
	else:
		$On.disabled = false
		$Off.disabled = true
		Settings.music_player.volume_db = -80
		

func _on_difficulty_pressed(type):
	if type == "EASY":
		$Easy.disabled = true
		$Normal.disabled = false
		$Hard.disabled = false
		Settings.difficulty = "EASY"
	elif type == "NORMAL":
		$Easy.disabled = false
		$Normal.disabled = true
		$Hard.disabled = false
		Settings.difficulty = "NORMAL"
	else:
		$Easy.disabled = false
		$Normal.disabled = false
		$Hard.disabled = true
		Settings.difficulty = "HARD"
