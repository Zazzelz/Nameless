extends Node

# === Phase Enum ===
enum Phase {
	BEGIN,
	PLAYER_TURN,
	ENEMY_TURN,
	ROLL_DICE,
	PLAYER_TURN_2,
	ENEMY_TURN_2,
	RESOLVE,
	GAME_OVER
}

# === Signals ===
signal phase_changed(new_phase: Phase)

# === State ===
var current_phase: Phase = Phase.BEGIN
var round_number: int = 1

@onready var game_ui: Control = null

func _ready():
	add_to_group("TurnManager")
	call_deferred("_late_init")

func _late_init():
	var ui_nodes = get_tree().get_nodes_in_group("GameUI")
	if ui_nodes.size() > 0:
		game_ui = ui_nodes[0]
		game_ui.start_match_confirmed.connect(_on_start_match_confirmed)
		game_ui.start_match_cancelled.connect(_on_start_match_cancelled)
		print("GameUI connected to TurnManager.")
	else:
		print("GameUI not found in group.")

# === Match Start ===
func _on_start_match_confirmed():
	round_number = 1
	_set_phase(Phase.PLAYER_TURN)

func _on_start_match_cancelled():
	print("Match cancelled. Quitting game.")
	get_tree().quit()

# === Phase Control ===
func _set_phase(new_phase: Phase):
	current_phase = new_phase
	emit_signal("phase_changed", current_phase)

	match current_phase:
		Phase.BEGIN:
			if game_ui:
				game_ui.show_phase_message("Welcome! Ready to begin?")
				game_ui.enable_dice_input(false)

		Phase.PLAYER_TURN:
			if game_ui:
				game_ui.show_phase_message("Phase One: Play Pre-Roll cards")
				game_ui.show_end_phase_button(true)
				game_ui.enable_dice_input(false)
				game_ui.enable_card_input(true)

		Phase.ENEMY_TURN:
			print("Enemy Turn begins")
			if game_ui:
				game_ui.show_phase_message("Enemy thinking...")
			await get_tree().create_timer(2.0).timeout
			_set_phase(Phase.ROLL_DICE)

		Phase.ROLL_DICE:
			print("Phase Two: Roll the Dice")
			if game_ui:
				game_ui.show_phase_message("Phase Two: Roll the Dice", 4.0)
				game_ui.enable_dice_input(true)
				game_ui.enable_card_input(false)

		Phase.PLAYER_TURN_2:
			print("Phase Three: Play Post-Roll cards")
			if game_ui:
				await game_ui.preview_roll_outcome()
				game_ui.show_phase_message("Phase Three: Play Post-Roll cards")
				game_ui.show_end_phase_button(true)
				game_ui.enable_dice_input(false)
				game_ui.enable_card_input(true)

		Phase.ENEMY_TURN_2:
			print("Enemy reacts...")
			if game_ui:
				game_ui.show_phase_message("Enemy reacting...")
			await get_tree().create_timer(2.0).timeout
			_set_phase(Phase.RESOLVE)

		Phase.RESOLVE:
			print("Resolving round outcome...")
			if game_ui:
				game_ui.show_phase_message("Resolving round outcome...", 3.0)
				game_ui.enable_dice_input(false)
				game_ui.enable_card_input(false)

				await game_ui.check_results()
				await get_tree().create_timer(2.0).timeout
				game_ui._clear_result_labels()

				if game_ui.check_game_over():
					_set_phase(Phase.GAME_OVER)
				else:
					round_number += 1
					game_ui.show_phase_message("Beginning Round " + str(round_number), 3.0)
					await get_tree().create_timer(2.0).timeout
					_set_phase(Phase.PLAYER_TURN)
			
		Phase.GAME_OVER:
			print("Game Over")
			if game_ui:
				game_ui.show_phase_message("Game Over")
				game_ui.enable_dice_input(false)
				game_ui.enable_card_input(false)

func _check_game_over_or_next_round():
	if game_ui and game_ui.check_game_over():
		_set_phase(Phase.GAME_OVER)
	else:
		_set_phase(Phase.PLAYER_TURN)

# === Public Helpers ===
func get_current_phase() -> Phase:
	return current_phase

func can_roll_dice() -> bool:
	return current_phase == Phase.ROLL_DICE

func is_game_over() -> bool:
	return current_phase == Phase.GAME_OVER

func end_player_phase():
	if current_phase == Phase.PLAYER_TURN:
		_set_phase(Phase.ENEMY_TURN)
	elif current_phase == Phase.PLAYER_TURN_2:
		_set_phase(Phase.ENEMY_TURN_2)

func advance_to_post_roll():
	if current_phase == Phase.ROLL_DICE:
		_set_phase(Phase.PLAYER_TURN_2)

func advance_to_resolution():
	if current_phase == Phase.ENEMY_TURN_2:
		_set_phase(Phase.RESOLVE)
