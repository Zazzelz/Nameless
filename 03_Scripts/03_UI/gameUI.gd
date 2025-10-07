extends Control

@onready var player_result_label: Label = find_child("PlayerRollResult", true, false)
@onready var opponent_result_label: Label = find_child("OpponentRollResult", true, false)

@onready var player_hp_container: Control = find_child("PlayerHP", true, false)
@onready var opponent_hp_container: Control= find_child("OpponentHP", true, false)

@onready var outcome_label: Label = find_child("OutcomeLabel", true, false)

@onready var style_manager := $LabelStyleManager

func apply_win_style():
	var style = style_manager.label_styles.get("PlayerWinSettings")
	if style:
		$WinLabel.label_settings = style

var player_dice: Array = []
var enemy_dice: Array = []
var dice_to_wait: int = 0
var dice_finished_count: int = 0

var player_hp: int = 3
var opponent_hp: int = 3

var game_over: bool = false

func _ready():
	add_to_group("GameUI")
	outcome_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	
	player_dice = get_tree().get_nodes_in_group("Player_Dice")
	enemy_dice = get_tree().get_nodes_in_group("Enemy_Dice")

	player_hp = player_hp_container.get_child_count()
	opponent_hp = opponent_hp_container.get_child_count()

	_clear_result_labels()
	_update_hp_ui()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if game_over:
			_restart_game()
		else:
			roll_all_dice()

func roll_all_dice():
	_clear_result_labels()

	dice_to_wait = player_dice.size() + enemy_dice.size()
	dice_finished_count = 0

	for die in player_dice:
		die.roll()
	for die in enemy_dice:
		await get_tree().create_timer(0.1).timeout
		die.roll()

func dice_finished():
	dice_finished_count += 1
	if dice_finished_count >= dice_to_wait:
		check_results()

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

	if player_total > enemy_total:
		opponent_hp -= 1
		_update_hp_ui()
		outcome_label.text = "Player wins the round"
		outcome_label.label_settings = style_manager.label_styles.get("PlayerWinSettings")

		outcome_label.show()
	elif enemy_total > player_total:
		player_hp -= 1
		_update_hp_ui()
		outcome_label.text = "Opponent wins the round"
		outcome_label.label_settings = style_manager.label_styles.get("OpponentWinSettings")
		outcome_label.show()
	else:
		outcome_label.text = "It's a tie"
		outcome_label.label_settings = style_manager.label_styles.get("TieOutcomeSettings")
		outcome_label.show()
	
	_check_game_over()
	


func _check_game_over():
	if player_hp <= 0:
		outcome_label.text = "Opponent wins the match!"
		outcome_label.label_settings = style_manager.label_styles.get("OpponentWinSettings")
		outcome_label.show()
		game_over = true
	elif opponent_hp <= 0:
		outcome_label.text = "Player wins the match!"
		outcome_label.label_settings = style_manager.label_styles.get("PlayerWinSettings")
		outcome_label.show()
		game_over = true
	print("Checking game over: Player HP =", player_hp, " Opponent HP =", opponent_hp)

	

func _update_hp_ui():
	for i in range(player_hp_container.get_child_count()):
		player_hp_container.get_child(i).visible = (i < player_hp)

	for i in range(opponent_hp_container.get_child_count()):
		opponent_hp_container.get_child(i).visible = (i < opponent_hp)

func _restart_game():
	player_hp = player_hp_container.get_child_count()
	opponent_hp = opponent_hp_container.get_child_count()
	game_over = false

	_clear_result_labels()
	_update_hp_ui()

func _clear_result_labels():
	player_result_label.text = ""
	opponent_result_label.text = ""
	player_result_label.hide()
	opponent_result_label.hide()

	outcome_label.text = ""
	outcome_label.hide()
