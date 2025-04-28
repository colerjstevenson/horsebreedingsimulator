extends Control

var race_state

var length
var race_name

var time

var horses = []
var leader

func setup(_length, _name, _player):
	length = _length
	race_name = _name
	
	$EndTile/text.text = "[center]" + str(length)
	
	var main_tile = $MainTile
	var finish_tile = $EndTile
	
	for x in range(0, length, 100):
		var new = main_tile.duplicate()
		new.get_child(0).text = "[center]" + str(x+100)
		new.visible = true
		$Track.add_child(new)
	
	var new = finish_tile.duplicate()
	new.visible = true
	$Track.add_child(new)
	
	# add horse to scene
	var scene = get_tree().current_scene
	var rh_obj =  preload("res://scenes/entities/raceHorse.tscn")
	for x in range(4):
		var rh = rh_obj.instantiate()
		rh.setup_new(x)
		rh.set_pos(320, 480+(x*45)) # TODO: fix hard coding
		rh.stand()
		add_child(rh)
		horses.append(rh)
	
	#add player horse to the scene
	var player = rh_obj.instantiate()
	player.setup(_player, 5)
	player.set_pos(320, 660) # TODO: fix hard coding
	player.stand()
	add_child(player)
	horses.append(player)
	
	time = 0
	race_state = "READY"
	


func _start_race():
	race_state = "RUNNING"
	for h in horses:
		h.run()

func finish_race():
	HorseManager.progressTime()
	if horses[-1].pos == leader:
		horses[-1].wins.append(race_name)
		HorseManager.money += 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if race_state == "RUNNING":
		time += delta
		update_horses()
		
	if $Track.position.x <= -1*($Track.size.x - get_viewport().size.x):
		race_state = "DONE"
		finish_race()
	
	
func update_horses():
	leader = 0
	for h in horses:
		var curr = h.get_pos(time)
		if curr > leader:
			leader = curr
	
	$Track.position.x = -1* ((leader*get_viewport().size.x)/100)
	
	for h in horses:
		h.update_pos(leader)
