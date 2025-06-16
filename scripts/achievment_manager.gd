extends Node


var tracker ={
	"triple_crown_easy": false,
	"triple_crown_normal": false,
	"triple_crown_hard": false,
	"10000_dollars": false,
	"50000_dollars": false,
	"100000_dollars": false,
	"1000000_dollars": false,
	"10_horses": false,
	"perfect_horse": false,
	"fresh_start": false,
	"perfect_season": false,
	"breed_100": false,
	"win_100": false,
	"auction_100": false,
	"1000_bet": false,
	"5000_bet": false,
	"10000_bet": false,
	"10000_loss": false
}

func check_achievements():
	check_triple_crown()
	check_money()
	check_horses()
	check_gambling()
	check_numbers()
	
	
func check_triple_crown():
	if Season.races[-1].result == 'W' and Season.races[-2].result == 'W' and Season.races[-3].result == 'W': 
		trigger_achievment("triple_crown_" + Settings.difficulty)
	
	if Season.week == Season.season_length and Season.races.all(func(n):return n.results == "W"):
		trigger_achievment("perfect_season")


func check_money():
	if Season.money >= 10000:
		trigger_achievment("10000_dollars")
	if Season.money >= 50000:
		trigger_achievment("50000_dollars")
	if Season.money >= 100000:
		trigger_achievment("100000_dollars")
	if Season.money >= 1000000:
		trigger_achievment("1000000_dollars")


func check_horses():
	if len(HorseManager.horses) >= 10:
		trigger_achievment("10_horses")
		
	if len(HorseManager.horses) == 0 and Season.week == 1 and Season.season == 1:
		trigger_achievment("fresh_start")


func check_gambling():
	if Season.gamblingEarnings >= 1000:
		trigger_achievment("1000_bet")
	if Season.gamblingEarnings >= 5000:
		trigger_achievment("5000_bet")
	if Season.gamblingEarnings >= 10000:
		trigger_achievment("10000_bet")
	if Season.gamblingEarnings <= -10000:
		trigger_achievment("10000_loss")


func trigger_achievment(name):
	if not tracker[name]:
		run_popup(name)
		tracker[name] = true
		

func check_numbers():
	pass


func run_popup(name):
	var pop_window =  preload("res://scenes/controls/AchievmentNotice.tscn")
	var window = pop_window.instantiate()
	window.setup(name)
	
	
	await get_tree().root.child_entered_tree
	var cs = get_tree().current_scene
	while cs.scene_file_path != "res://scenes/mainMenu.tscn":
		await get_tree().root.child_entered_tree
		cs = get_tree().current_scene
	
	
	var scene = get_tree().current_scene
	scene.add_child(window)



func openAchievments():
	var pop_window =  preload("res://scenes/controls/AchievmentList.tscn")
	var window = pop_window.instantiate()
	var scene = get_tree().current_scene
	scene.add_child(window)


func save_achievments():
	pass
