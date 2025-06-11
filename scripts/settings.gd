extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var difficulty = "NORMAL"
var tutorial = false

func _ready():
	add_child(music_player)
	music_player.stream = preload("res://audio/music/basic_theme_v1.wav")
	music_player.finished.connect(_on_music_finished)
	music_player.play()

func _on_music_finished():
	music_player.play()
