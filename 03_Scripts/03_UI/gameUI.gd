extends Control
class_name GameUI

# ------------------------------------------------------------------------------
# GameUI
# Handles all user‑facing UI for the match:
# - Start match confirmation
# - Dice rolling and results
# - HP display
# - Phase transitions
# - Game over flow
# ------------------------------------------------------------------------------

# --- Node References -----------------------------------------------------------
@onready var player_result_label: Label = find_child("PlayerRollResult", true, false)
@onready var opponent_result_label: Label = find_child("OpponentRollResult", true, false)
@onready var player_hp_container: Control = find_child("PlayerHP", true, false)
@onready var opponent_hp_container: Control = find_child("OpponentHP", true, false)
@onready var outcome_label: Label = find_child("OutcomeLabel", true, false)
@onready var style_manager: Node = find_child("LabelStyleManager", true, false)
@onready var start_overlay: Control = find_child("StartMatchOverlay", true, false)
@onready var yes_button: Button = find_child("YesButton", true, false)
@onready var no_button: Button = find_child("NoButton", true, false)
@onready var end_phase_button: Button = find_child("EndPhaseButton", true, false)

# --- Signals -------------------------------------------------------------------
signal start_match_confirmed
signal start_match_cancelled

# --- Dice + HP State -----------------------------------------------------------
var player_dice: Array = []
var enemy_dice: Array = []
var dice_to_wait: int = 0
var dice_finished_count: int = 0

var player_hp: int = 3
var opponent_hp: int = 3
var game_over: bool = false

var dice_input_enabled: bool = false
var card_input_enabled: bool = false


# ------------------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------------------

func _ready() -> void:
	add_to_group("GameUI")
	outcome_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	player_dice = get_tree().get_nodes_in_group("Player_Dice")
	enemy_dice = get_tree().get_nodes_in_group("Enemy_Dice")

	player_hp = player_hp_container.get_child_count()
	opponent_hp = opponent_hp_container.get_child_count()

	_clear_result_labels()
	_update_hp_ui()

	# Show start overlay and pause game
	start_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	start_overlay.visible = true
	get_tree().paused = true

	yes_button.pressed.connect(_on_yes_pressed)
	no_button.pressed.connect(_on_no_pressed)
	end_phase_button.pressed.connect(_on_end_phase_pressed)
	end_phase_button.visible = false

	DebugTools.log("GameUI.Init", "GameUI ready — waiting for player to start match")


# ------------------------------------------------------------------------------
# Match Start / Cancel
# ------------------------------------------------------------------------------

func _on_yes_pressed() -> void:
	get_tree().paused = false
	start_overlay.hide()

	emit_signal("start_match_confirmed")
	DebugTools.log("GameUI.MatchStart", "Match confirmed — starting game")


func _on_no_pressed() -> void:
	emit_signal("start_match_cancelled")
	DebugTools.log("GameUI.MatchStart", "Match cancelled")
	get_tree().quit()


# ------------------------------------------------------------------------------
# Input Handling
# ------------------------------------------------------------------------------

func _process(_delta: float) -> void:
	if get_tree().paused:
		return

	if Input.is_action_just_pressed("ui_accept"):
		if game_over:
			DebugTools.log("GameUI.Restart", "Restarting game")
			_restart_game()
		elif dice_input_enabled:
			DebugTools.log("GameUI.Dice", "Rolling all dice")
			roll_all_dice()
		else:
			var managers := get_tree().get_nodes_in_group("TurnManager")
			if managers.size() > 0:
				var turn_manager = managers[0]
				DebugTools.warn("GameUI.Input", "Dice rolling disabled during phase: %s" % turn_manager.get_current_phase())
			else:
				DebugTools.warn("GameUI.Errors", "TurnManager not found in group")


# ------------------------------------------------------------------------------
# Dice Rolling
# ------------------------------------------------------------------------------

func roll_all_dice() -> void:
	_clear_result_labels()
	dice_to_wait = player_dice.size() + enemy_dice.size()
	dice_finished_count = 0

	DebugTools.log("GameUI.Dice", "Rolling %d dice" % dice_to_wait)

	for die in player_dice:
		die.roll()

	for die in enemy_dice:
		await get_tree().create_timer(0.1).timeout
		die.roll()


func dice_finished() -> void:
	dice_finished_count += 1
	DebugTools.log("GameUI.Dice", "Dice finished: %d / %d" % [dice_finished_count, dice_to_wait])

	if dice_finished_count >= dice_to_wait:
		var managers := get_tree().get_nodes_in_group("TurnManager")
		if managers.size() > 0:
			managers[0].advance_to_post_roll()
		else:
			DebugTools.warn("GameUI.Errors", "TurnManager not found in group")


# ------------------------------------------------------------------------------
# Roll Preview
# ------------------------------------------------------------------------------

func preview_roll_outcome() -> void:
	var player_total := 0
	var enemy_total := 0

	for die in player_dice:
		var result: int = die.get_roll_value()
		player_total += result
		player_result_label.text = "%s rolled: %d" % [die.dice_name, result]
		player_result_label.show()

	for die in enemy_dice:
		var result: int = die.get_roll_value()
		enemy_total += result
		opponent_result_label.text = "%s rolled: %d" % [die.dice_name, result]
		opponent_result_label.show()

	await get_tree().create_timer(1.5).timeout

	if player_total > enemy_total:
		outcome_label.text = "Player currently has the higher roll"
		outcome_label.label_settings = style_manager.label_styles.get("PlayerWinSettings")
	elif enemy_total > player_total:
		outcome_label.text = "Opponent currently has the higher roll"
		outcome_label.label_settings = style_manager.label_styles.get("OpponentWinSettings")
	else:
		outcome_label.text = "It's a tie so far"
		outcome_label.label_settings = style_manager.label_styles.get("TieOutcomeSettings")

	outcome_label.show()

	DebugTools.log("GameUI.RollOutcome", "Preview roll outcome: P=%d, O=%d" % [player_total, enemy_total])

# ------------------------------------------------------------------------------
# Round Resolution
# ------------------------------------------------------------------------------

func check_results() -> void:
	var player_total := 0
	var enemy_total := 0

	for die in player_dice:
		player_total += die.get_roll_value()
	for die in enemy_dice:
		enemy_total += die.get_roll_value()

	await get_tree().create_timer(1.5).timeout

	if player_total > enemy_total:
		opponent_hp -= 1
		_update_hp_ui()
		outcome_label.text = "Player wins the round"
		outcome_label.label_settings = style_manager.label_styles.get("PlayerWinSettings")
	elif enemy_total > player_total:
		player_hp -= 1
		_update_hp_ui()
		outcome_label.text = "Opponent wins the round"
		outcome_label.label_settings = style_manager.label_styles.get("OpponentWinSettings")
	else:
		outcome_label.text = "It's a tie"
		outcome_label.label_settings = style_manager.label_styles.get("TieOutcomeSettings")

	outcome_label.show()

	DebugTools.log("GameUI.RoundResult", "Round result: P=%d, O=%d" % [player_total, enemy_total])


# ------------------------------------------------------------------------------
# Game Over Check
# ------------------------------------------------------------------------------

func check_game_over() -> bool:
	if player_hp <= 0:
		outcome_label.text = "Opponent wins the match!"
		outcome_label.label_settings = style_manager.label_styles.get("OpponentWinSettings")
		outcome_label.show()
		game_over = true

		DebugTools.log("GameUI.GameOver", "Game over — opponent wins")
		return true

	elif opponent_hp <= 0:
		outcome_label.text = "Player wins the match!"
		outcome_label.label_settings = style_manager.label_styles.get("PlayerWinSettings")
		outcome_label.show()
		game_over = true

		DebugTools.log("GameUI.GameOver", "Game over — player wins")
		return true

	return false


# ------------------------------------------------------------------------------
# HP + UI Helpers
# ------------------------------------------------------------------------------

func _update_hp_ui() -> void:
	for i in range(player_hp_container.get_child_count()):
		player_hp_container.get_child(i).visible = (i < player_hp)

	for i in range(opponent_hp_container.get_child_count()):
		opponent_hp_container.get_child(i).visible = (i < opponent_hp)


func _clear_result_labels() -> void:
	player_result_label.text = ""
	opponent_result_label.text = ""
	player_result_label.hide()
	opponent_result_label.hide()
	outcome_label.text = ""
	outcome_label.hide()


# ------------------------------------------------------------------------------
# Phase Controls
# ------------------------------------------------------------------------------

func _on_end_phase_pressed() -> void:
	end_phase_button.visible = false

	var turn_manager_nodes := get_tree().get_nodes_in_group("TurnManager")
	if turn_manager_nodes.size() > 0:
		turn_manager_nodes[0].end_player_phase()
	else:
		DebugTools.warn("GameUI.Errors", "TurnManager not found in group")


# ------------------------------------------------------------------------------
# Restart Logic
# ------------------------------------------------------------------------------

func _restart_game() -> void:
	player_hp = player_hp_container.get_child_count()
	opponent_hp = opponent_hp_container.get_child_count()
	game_over = false

	_clear_result_labels()
	_update_hp_ui()

	start_overlay.visible = true
	start_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	get_tree().paused = true

	DebugTools.log("GameUI.Restart", "Game restarted")


# ------------------------------------------------------------------------------
# Input Toggles
# ------------------------------------------------------------------------------

func enable_dice_input(state: bool) -> void:
	dice_input_enabled = state
	DebugTools.log("GameUI.InputState", "Dice input set to %s" % str(state))


func enable_card_input(state: bool) -> void:
	card_input_enabled = state
	DebugTools.log("GameUI.InputState", "Card input set to %s" % str(state))


# ------------------------------------------------------------------------------
# Phase Messaging
# ------------------------------------------------------------------------------

func show_phase_message(text: String, duration := 3) -> void:
	outcome_label.text = text
	outcome_label.label_settings = style_manager.label_styles.get("PhaseStartUISetting")
	outcome_label.show()

	await get_tree().create_timer(duration).timeout
	outcome_label.hide()

	DebugTools.log("GameUI.PhaseMessages", "Phase message shown: %s" % text)


# ------------------------------------------------------------------------------
# End Phase Button Visibility
# ------------------------------------------------------------------------------

func show_end_phase_button(is_visible: bool) -> void:
	end_phase_button.visible = is_visible
	DebugTools.log("GameUI.UIState", "End phase button visibility: %s" % str(is_visible))
