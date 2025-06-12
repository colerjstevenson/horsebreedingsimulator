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

var pregnant: bool
var training

var id: float
var horse_name: String
var sex: String
var age: int
var color: String

var mother
var father

func _init():
	randomize()
	id = randf()
	sex = "Female" if randf_range(0,100) > 49 else "Male"
	position = Vector2(randf_range(100, 600), randf_range(100, 700))
	wins = []
	pregnant = false
	training = null
	
	mother = null
	father = null

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
	age = randi_range(1,3)
	#print(horse_name)
	return self
	
	
func setup_race():
	
	var ranges = {
		"EASY": [40, 60],
		"NORMAL": [60,80],
		"HARD": [80, 100]}
		
	var range = ranges[Settings.difficulty]
	if Season.season == 1 and Season.week == 1:
		range = ranges["EASY"]
	
	if Season.races[Season.week-1].crown:
		range[0] += 10
		range[1] = 100
	
	stats["speed"] = randf_range(range[0], range[1])
	stats["acceleration"] = randf_range(range[0], range[1])
	stats["stamina"] = randf_range(range[0], range[1])
	stats["vitality"] = randf_range(range[0]+20, 100)
	stats["fertility"] = 100
	
	color = horseColors.pick_random()
	horse_name = get_horse_name()
	age = randi_range(1,3)
	#print(horse_name)
	return self




# returns a new horse bred from the inputs
# or returns null if breeding failed
func breed(_mother: Horse, _father: Horse): 
	if _mother.fireBlanks() or _father.fireBlanks():
		return null
	
	merge_genes(_father, _mother)
		
	age = 0
	stats["vitality"] = 100
	horse_name = get_horse_name()
	mother = _mother.id
	father = _father.id
	if _mother.stats["fertility"] > _father.stats["fertility"]:
		color = _mother.color
	else:
		color = _father.color
	return self
	
	


func merge_genes(a, b):
	var mutation_rate = 0.15
	
	var traits = ["speed", "acceleration", "stamina", "fertility"]
	for i in traits:
		var gene = 0
		var max = max(a.stats[i], b.stats[i])
		var min = min(a.stats[i], b.stats[i])
		gene = randf_range(min, max)
		
		var f = (a.stats["fertility"] + b.stats["fertility"])/100

		if randf() < mutation_rate:
			gene *= f
			
		if a.is_sibling(b) or a.is_child(b):
			gene *= randf_range(0.4, 1.0)
			if i == "fertility":
				gene *= 0.5

		gene = clamp(gene, 1, 100)
		stats[i] = gene
	




#used to determine sucessful breeding
func fireBlanks():
	var blank
	if Settings.difficulty == "EASY":
		blank = randf_range(0, 100) > stats["fertility"]+40
	elif Settings.difficulty == "NORMAL":
		blank = randf_range(0, 100) > stats["fertility"]+20
	else:
		blank = randf_range(0, 100) > stats["fertility"]
	
	return Season.season != 1 and blank



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
	if age == 0:
		$HorseAnim.visible = false
		$FoleAnim.visible = true
	else:
		$HorseAnim.visible = true
		$FoleAnim.visible = false

	var anim_name = color + "_"
	anim_name += "right_" if velocity.x >= 0 else "left_"
	anim_name += action
	$HorseAnim.play(anim_name)
	$FoleAnim.play(anim_name)



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
	var file = FileAccess.open("res://lists/horseNames.txt", FileAccess.READ)
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


func apply_training():
	if training:
		var amount
		if stats["vitality"] < 50:
			amount = 1
		elif age == 0:
			amount = 8
		else:
			amount = 5
		
		stats[training] += amount
		fatigue("TRAIN")
		training = null


func age_factor() -> float:
	if age <= 4.5:
		return clamp(age / 4.5, 0.0, 1.0)  # Rises from 0 at birth to 1 at 4.5
	else:
		# Decline 1 → 0 by age 8 (decline period ≈ 7.5 years)
		return clamp(1.0 - ((age - 4.5) / 3.5), 0.0, 1.0)


func fatigue(type="RACE"):
	var s = clamp(stats["stamina"] / 100.0, 0.0, 1.0)
	var af = age_factor()
	var base_loss
	# Base: between 15 and 5 points lost depending on stamina
	if type == "RACE":
		base_loss = lerp(20.0, 10.0, s)
	else:
		base_loss = lerp(15, 5, s)
	# Age penalty: low age or old age increases loss
	var age_penalty = lerp(1.0, 1.5, abs(af - 1.0))
	stats["vitality"] =  int(clamp(stats["vitality"] - (base_loss*age_penalty), 0, 100))


func recovery():
	var s = clamp(stats["stamina"] / 100.0, 0.0, 1.0)
	var af = age_factor()
	# Base recover between 10 and 25
	var base_rec = lerp(10.0, 25.0, s)
	# Actual recovery scales with prime age
	var max = clamp(100 + 20*(4-age), 10, 100)
	stats["vitality"] = int(clamp(stats["vitality"]+(base_rec * af), 0, max))


func is_sibling(horse:Horse):
	if mother and father:
		return mother == horse.mother or father == horse.father
	
	return false
	
func is_child(horse:Horse):
	var child = (mother and father) and (mother == horse.id or father == horse.id)
	var parent = (horse.mother and horse.father) and (horse.mother == id or horse.father == id)
	return parent or child
		

func to_dict():
	var dict = {
		"horse_name": horse_name,
		"age": age,
		"color": color,
		"sex": sex,
		"pregnant": pregnant,
		"wins": wins,
		"stats": stats,
		"mother": mother,
		"father": father,
		"id" : id
	}
	
	return dict


func from_dict(horse):
	horse_name = horse["horse_name"]
	age = horse["age"]
	sex = horse["sex"]
	color = horse["color"]
	pregnant = horse["pregnant"]
	wins = horse["wins"]
	stats = horse["stats"]
	
	if "mother" in horse.keys():
		mother = horse["mother"]
	else:
		mother = null
		
	if "father" in horse.keys():
		father = horse["father"]
	else:
		father = null
		
	if "id" in horse.keys():
		id = horse["id"]
	else:
		id = randf()
