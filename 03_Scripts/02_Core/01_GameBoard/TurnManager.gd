extends Node
class_name TurnManager

var card_game_manager: CardGameManager

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

func _ready() -> void:
	add_to_group("TurnManager")
	call_deferred("_late_init")

	
func _late_init() -> void:
	var ui_nodes := get_tree().get_nodes_in_group("GameUI")
	if ui_nodes.size() > 0:
		game_ui = ui_nodes[0]
		game_ui.start_match_confirmed.connect(_on_start_match_confirmed)
		game_ui.start_match_cancelled.connect(_on_start_match_cancelled)
		print("GameUI connected to TurnManager.")
	else:
		print("GameUI not found in group.")

	var game_nodes := get_tree().get_nodes_in_group("CardGameManager")
	if game_nodes.size() > 0:
		card_game_manager = game_nodes[0]
	else:
		push_warning("CardGameManager not found in group.")

# === Match Start ===
func _on_start_match_confirmed() -> void:
	round_number = 1
	card_game_manager._setup_game()
	_set_phase(Phase.PLAYER_TURN)


func _on_start_match_cancelled() -> void:
	print("Match cancelled. Quitting game.")
	get_tree().quit()

# === Phase Control ===
func _set_phase(new_phase: Phase) -> void:
	current_phase = new_phase
	emit_signal("phase_changed", current_phase)

	match current_phase:
		Phase.BEGIN:
			_handle_begin_phase()
		Phase.PLAYER_TURN:
			_handle_player_turn()
		Phase.ENEMY_TURN:
			await _handle_enemy_turn()
		Phase.ROLL_DICE:
			_handle_roll_dice()
		Phase.PLAYER_TURN_2:
			await _handle_player_turn_2()
		Phase.ENEMY_TURN_2:
			await _handle_enemy_turn_2()
		Phase.RESOLVE:
			await _handle_resolve_phase()
		Phase.GAME_OVER:
			_handle_game_over()

# === Phase Handlers ===
func _handle_begin_phase() -> void:
	if game_ui:
		game_ui.show_phase_message("Welcome! Ready to begin?")
		game_ui.enable_dice_input(false)

func _handle_player_turn() -> void:
	if game_ui:
		game_ui.show_phase_message("Phase One: Play Pre-Roll cards")
		game_ui.show_end_phase_button(true)
		game_ui.enable_dice_input(false)
		game_ui.enable_card_input(true)

func _handle_roll_dice() -> void:
	print("Phase Two: Roll the Dice")
	if game_ui:
		game_ui.show_phase_message("Phase Two: Roll the Dice", 4.0)
		game_ui.enable_dice_input(true)
		game_ui.enable_card_input(false)

func _handle_game_over() -> void:
	print("Game Over")
	if game_ui:
		game_ui.show_phase_message("Game Over")
		game_ui.enable_dice_input(false)
		game_ui.enable_card_input(false)

# === Async Phase Handlers ===
func _handle_enemy_turn() -> void:
	print("Enemy Turn begins")
	if game_ui:
		game_ui.show_phase_message("Enemy thinking...")
	await get_tree().create_timer(2.0).timeout
	_set_phase(Phase.ROLL_DICE)

func _handle_player_turn_2() -> void:
	print("Phase Three: Play Post-Roll cards")
	if game_ui:
		await game_ui.preview_roll_outcome()
		game_ui.show_phase_message("Phase Three: Play Post-Roll cards")
		game_ui.show_end_phase_button(true)
		game_ui.enable_dice_input(false)
		game_ui.enable_card_input(true)

func _handle_enemy_turn_2() -> void:
	print("Enemy reacts...")
	if game_ui:
		game_ui.show_phase_message("Enemy reacting...")
	await get_tree().create_timer(2.0).timeout
	_set_phase(Phase.RESOLVE)

func _handle_resolve_phase() -> void:
	print("Resolving round outcome...")
	if game_ui:
		game_ui.show_phase_message("Resolving round outcome...", 3.0)
		game_ui.enable_dice_input(false)
		game_ui.enable_card_input(false)

		await game_ui.check_results()

		if GameContext.board:
			var board := GameContext.board
			board.cleanup_play_zones()
			board.check_and_reshuffle_deck("player")
			board.check_and_reshuffle_deck("opponent")

		await get_tree().create_timer(2.0).timeout
		game_ui._clear_result_labels()

		if game_ui.check_game_over():
			_set_phase(Phase.GAME_OVER)
		else:
			round_number += 1
			game_ui.show_phase_message("Beginning Round " + str(round_number), 3.0)
			await get_tree().create_timer(2.0).timeout
			_set_phase(Phase.PLAYER_TURN)

# === Public Helpers ===
func get_current_phase() -> Phase:
	return current_phase

func can_roll_dice() -> bool:
	return current_phase == Phase.ROLL_DICE

func is_game_over() -> bool:
	return current_phase == Phase.GAME_OVER

func end_player_phase() -> void:
	match current_phase:
		Phase.PLAYER_TURN:
			_set_phase(Phase.ENEMY_TURN)
		Phase.PLAYER_TURN_2:
			_set_phase(Phase.ENEMY_TURN_2)

func advance_to_post_roll() -> void:
	if current_phase == Phase.ROLL_DICE:
		_set_phase(Phase.PLAYER_TURN_2)

func advance_to_resolution() -> void:
	if current_phase == Phase.ENEMY_TURN_2:
		_set_phase(Phase.RESOLVE)
