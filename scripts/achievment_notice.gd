extends Control

var time = 3

func setup(name):
	var tracker = preload("res://scenes/controls/AchievmentList.tscn").instantiate()
	var achvmt = tracker.find_child(name)
	$panel/text.text = achvmt.find_child("text").text
	$panel/icon.texture = achvmt.find_child("icon").texture




func start_animation():
	$panel.visible = true
	$panel.modulate.a = 0.0
	$panel.position.y = -$panel.size.y

	var tween = create_tween()
	tween.tween_property($panel, "modulate:a", 1.0, 0.25)
	tween.tween_property($panel, "position:y", 0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_interval(time)
	tween.tween_property($panel, "modulate:a", 0.0, 0.5)
	tween.tween_callback(self._on_panel_hidden)


func _ready():
	start_animation()


func _on_panel_hidden():
	$panel.visible = false
	queue_free()
