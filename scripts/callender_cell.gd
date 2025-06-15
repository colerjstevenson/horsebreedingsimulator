extends Control

var race: Season.Race
 


func setup(_race: Season.Race):
	race = _race
	
	$Button/name.text = race.race_name
	$Button/length.text = str(race.length) + 'm'
	$Button/purse.text = '$' + str(race.purse)
	
	$Button/crown.visible = race.crown
	
	if race.week < Season.week and not race.horse is Horse:
		$Button/horse.text = "Race Skipped"
		$Button/horse.visible = true
		$Button.color = Color("542a11")
	elif race.horse is Horse:
		$Button/horse.text = race.horse.horse_name
		$Button/horse.visible = true
		$Button.color = Color("542a11")
		
		if race.result == 'W':
			$Button/win.visible = true
		else:
			$Button/loss.visible = true
		
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



		
	
