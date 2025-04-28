extends CharacterBody2D
class_name Horse

var horseColors = ["blonde", "black", "red"]

enum HorseState {
	STATE_WALKING,
	STATE_STANDING,
	STATE_EATING
}

var mut_rate = 10 # rate of mutation
var dom_ratio = 65 # ration of dominant gene

var current_state = HorseState.STATE_WALKING
var state_timer = 0.0
var random = RandomNumberGenerator.new()

var screen_width
var screen_height

var stats = {}
var wins

var horse_name: String
var sex: String
var pregnant: bool
var age: int
var color: String

func _init():
	randomize()
	sex = "Female" if randf_range(0,100) > 50 else "Male"
	position = Vector2(randf_range(100, 600), randf_range(100, 700))
	wins = []
	pregnant = false

func _ready():
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y
	set_state(HorseState.STATE_WALKING)


#set up for start of game horses
func setup():
	stats["speed"] = randf_range(0, 100)
	stats["acceleration"] = randf_range(0, 100)
	stats["stamina"] = randf_range(0, 100)
	stats["vitality"] = 100
	stats["fertility"] = randf_range(50, 100)
	
	color = horseColors.pick_random()
	horse_name = get_horse_name()
	age = randi_range(0,3)
	print(horse_name)




# returns a new horse bred from the inputs
# or returns null if breeding failed
func breed(mother: Horse, father: Horse): 
	if mother.fireBlanks() or father.fireBlanks():
		return null
	
	if mother.stats["fertility"] > father.stats["fertility"]:
		merge_genes(mother, father)
	else:
		merge_genes(father, mother)
		
	age = 0
	stats["vitality"] = 100
	horse_name = get_horse_name()
	
	return self
	
	
func merge_genes(dom, sub):
	var properties = ["speed", "acceleration", "stamina", "fertility"]
	
	for p in properties:
		if randf_range(0, 100) > dom_ratio:
			stats[p] = sub.stats[p]
		else:
			stats[p] = dom.stats[p]
			
			
	if randf_range(0, 100) > dom_ratio:
		color = sub.color
	else:
		color = dom.color 





#used to determine sucessful breeding
func fireBlanks():
	return randf_range(0, 100) > stats["fertility"]



func set_state(new_state: HorseState):
	current_state = new_state
	match current_state:
		HorseState.STATE_WALKING:
			state_timer = random.randf_range(2.0, 5.0)  # Walk for 2 to 5 seconds
			var angle = random.randf_range(0, 2 * PI)
			velocity = Vector2(cos(angle), sin(angle)) * 50  # Adjust speed as necessary
			update_animation("walking")
		HorseState.STATE_STANDING:
			state_timer = random.randf_range(1.0, 3.0)  # Stand for 1 to 3 seconds
			velocity = Vector2.ZERO
			update_animation("standing")
		HorseState.STATE_EATING:
			state_timer = random.randf_range(2.0, 4.0)  # Eat for 2 to 4 seconds
			velocity = Vector2.ZERO
			update_animation("eating")



func update_animation(action: String):
	var anim_name = color + "_"
	anim_name += "right_" if velocity.x >= 0 else "left_"
	anim_name += action
	$AnimatedSprite2D.play(anim_name)



func _physics_process(delta: float) -> void:
	state_timer -= delta
	if state_timer <= 0:
		if current_state == HorseState.STATE_WALKING:
			set_state(HorseState.STATE_STANDING if random.randf() < 0.5 else HorseState.STATE_EATING)
		else:
			set_state(HorseState.STATE_WALKING)

	if current_state == HorseState.STATE_WALKING:
		move_and_slide()
		if position.x < 0 or position.x > screen_width or position.y < 0 or position.y > screen_height:
			position.x = clamp(position.x, 0, screen_width)
			position.y = clamp(position.y, 0, screen_height)
			velocity = -velocity
			update_animation("walking")
			

# return random horse name from list
func get_horse_name() -> String:
	var file = FileAccess.open("res://horseNames.txt", FileAccess.READ)
	if file:
		var selected_line = ""
		var line_count = 0
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			line_count += 1
			if rng.randi() % line_count == 0:
				selected_line = line
		file.close()
		return selected_line
	return "horse"
