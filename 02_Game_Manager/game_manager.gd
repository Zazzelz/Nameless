extends Control

@onready var player_result_label = $PlayerRollResult
@onready var opponent_result_label = $OpponentRollResult
@onready var result_label = $GameResult

@onready var opponent_hp_container: HBoxContainer = $"../GameUi/OpponentUI/HBoxContainer"
@onready var player_hp_container: HBoxContainer = $"../GameUi/PlayerUI/HBoxContainer"

var player_dice: Array = []
var enemy_dice: Array = []
var dice_to_wait: int = 0
var dice_finished_count: int = 0

var player_hp: int = 3
var opponent_hp: int = 3

var game_over: bool = false

func _ready():
	player_dice = get_tree().get_nodes_in_group("Player_Dice")
	enemy_dice = get_tree().get_nodes_in_group("Enemy_Dice")

	player_result_label.text = ""
	opponent_result_label.text = ""
	result_label.hide()
	
	_update_hp_ui()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		opponent_result_label.hide()
		player_result_label.hide()
		result_label.hide()
		roll_all_dice()
	if game_over and Input.is_action_just_pressed("ui_accept"):
		_restart_game()

func roll_all_dice():
	player_result_label.text = ""
	opponent_result_label.text = ""
	result_label.hide()
	player_result_label.hide()
	opponent_result_label.hide()

	# Set the total dice count before rolling
	dice_to_wait = player_dice.size() + enemy_dice.size()
	print("counted", dice_to_wait, "on the table")
	dice_finished_count = 0
	print("Rolling all dice, waiting for ", dice_to_wait, " dice.")
	
	for i in range(player_dice.size()):
		player_dice[i].roll()
	for i in range(enemy_dice.size()):
		await get_tree().create_timer(0.1).timeout 
		enemy_dice[i].roll()
	
func dice_finished():
	dice_finished_count += 1
	print("Dice finished count: ", dice_finished_count, "/", dice_to_wait)
	if dice_finished_count >= dice_to_wait:
		print("All dice done, checking results")
		check_results()
	
func check_results():
	print("check_results() STARTED at frame: ", Engine.get_frames_drawn())
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
		result_label.text = "Player wins this round"
	elif enemy_total > player_total:
		player_hp -= 1
		result_label.text = "Opponent wins this round"
	else:
		result_label.text = "It’s a tie!"
	
	_update_hp_ui()
	result_label.show()
	_check_game_over()
	
func _update_hp_ui():
	# --- Player discs ---
	var p_count = player_hp_container.get_child_count()
	for i in range(p_count):
		var disc = player_hp_container.get_child(i)
		# Show only leftmost N discs, so rightmost disappear first
		disc.visible = (i < player_hp)

	# --- Opponent discs ---
	var e_count = opponent_hp_container.get_child_count()
	for i in range(e_count):
		var disc = opponent_hp_container.get_child(i)
		disc.visible = (i < opponent_hp)
	
func _check_game_over():
	if player_hp <= 0:
		result_label.text = "Opponent wins the match!"
		game_over = true
	elif opponent_hp <= 0:
		result_label.text = "Player wins the match!"	
		game_over = true

func _restart_game():
	player_hp = player_hp_container.get_child_count()
	opponent_hp = opponent_hp_container.get_child_count()
	player_result_label.text = ""
	opponent_result_label.text = ""
	result_label.hide()

	_update_hp_ui()
	game_over = false
	
