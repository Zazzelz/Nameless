extends Control

@onready var player_result_label = $PlayerRollResult
@onready var opponent_result_label = $OpponentRollResult
@onready var result_label = $GameResult
var player_dice: Array = []
var enemy_dice: Array = []

func _ready():
	player_dice = get_tree().get_nodes_in_group("Player_Dice")
	enemy_dice = get_tree().get_nodes_in_group("Enemy_Dice")

	player_result_label.text = ""
	opponent_result_label.text = ""
	result_label.hide()
	
func roll_all_dice():
	player_result_label.text = ""
	opponent_result_label.text = ""
	
	result_label.hide()
	player_result_label.hide()
	opponent_result_label.hide()
	
	for die in player_dice:
		die.roll()
	for die in enemy_dice:
		die.roll()

func check_results():
	var player_total = 0
	var enemy_total = 0

	for die in player_dice:
		var result = die.get_roll_value()
		player_total += result
		player_result_label.text = die.dice_name + " rolled: " + str(result)
		player_result_label.show()

	for die in enemy_dice:
		var result = die.get_roll_value()
		enemy_total += result
		opponent_result_label.text = die.dice_name + " rolled: " + str(result)
		opponent_result_label.show()
	
	await get_tree().create_timer(1.5).timeout
	
	var msg = ""
	if player_total > enemy_total:
		msg = "Player wins!"
	elif enemy_total > player_total:
		msg = "Enemy wins!"
	else:
		msg = "It’s a tie!"

	result_label.text = msg
	result_label.show()
	
	
