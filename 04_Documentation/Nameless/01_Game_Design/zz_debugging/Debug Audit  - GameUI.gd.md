
## ✅ **1. Debug Toggle**

You have a per‑script toggle:

gdscript

```
@export var debug_enabled: bool = false
```

Local only — not connected to a global system.

## ✅ **2. Debug Logging Helpers**

gdscript

```
func _log(msg: String) -> void:
    if debug_enabled:
        print(msg)

func _warn(msg: String) -> void:
    if debug_enabled:
        push_warning(msg)
```

These will eventually become:

gdscript

```
Debug.log("GameUI", msg)
Debug.warn("GameUI", msg)
```

## ✅ **3. Debug Calls Inside the Script**

### **A) Initialization Debug**

Inside `_ready()`:

gdscript

```
_log("GameUI ready — waiting for player to start match")
```

Category: **GameUI.Init**

### **B) Match Start Debug**

Inside `_on_yes_pressed()`:

gdscript

```
_log("Match confirmed — starting game")
```

Inside `_on_no_pressed()`:

gdscript

```
_log("Match cancelled")
```

Category: **GameUI.MatchStart**

### **C) Input Debug**

Inside `_process()`:

gdscript

```
_log("Restarting game")
_log("Rolling all dice")
_warn("Dice rolling disabled during phase: %s" % turn_manager.get_current_phase())
_warn("TurnManager not found in group")
```

Category: **GameUI.Input**

### **D) Dice Debug**

Inside `roll_all_dice()`:

gdscript

```
_log("Rolling %d dice" % dice_to_wait)
```

Inside `dice_finished()`:

gdscript

```
_log("Dice finished: %d / %d" % [dice_finished_count, dice_to_wait])
_warn("TurnManager not found in group")
```

Category: **GameUI.Dice**

### **E) Roll Outcome Debug**

Inside `preview_roll_outcome()`:

gdscript

```
_log("Preview roll outcome: P=%d, O=%d" % [player_total, enemy_total])
```

Category: **GameUI.RollOutcome**

### **F) Round Result Debug**

Inside `check_results()`:

gdscript

```
_log("Round result: P=%d, O=%d" % [player_total, enemy_total])
```

Category: **GameUI.RoundResult**

### **G) Game Over Debug**

Inside `check_game_over()`:

gdscript

```
_log("Game over — opponent wins")
_log("Game over — player wins")
```

Category: **GameUI.GameOver**

### **H) Restart Debug**

Inside `_restart_game()`:

gdscript

```
_log("Game restarted")
```

Category: **GameUI.Restart**

### **I) Input Toggle Debug**

Inside `enable_dice_input()`:

gdscript

```
_log("Dice input set to %s" % str(state))
```

Inside `enable_card_input()`:

gdscript

```
_log("Card input set to %s" % str(state))
```

Category: **GameUI.InputState**

### **J) Phase Message Debug**

Inside `show_phase_message()`:

gdscript

```
_log("Phase message shown: %s" % text)
```

Category: **GameUI.PhaseMessages**

### **K) End Phase Button Debug**

Inside `show_end_phase_button()`:

gdscript

```
_log("End phase button visibility: %s" % str(is_visible))
```

Category: **GameUI.UIState**

# 🧩 **4. Summary of Debug Elements in GameUI.gd**

|Category|Debug Elements Found|
|---|---|
|**GameUI.Init**|Ready message|
|**GameUI.MatchStart**|Match confirmed/cancelled|
|**GameUI.Input**|Accept key, invalid phase, missing TurnManager|
|**GameUI.Dice**|Rolling dice, dice finished|
|**GameUI.RollOutcome**|Preview roll totals|
|**GameUI.RoundResult**|Round result totals|
|**GameUI.GameOver**|Winner announcement|
|**GameUI.Restart**|Restarting game|
|**GameUI.InputState**|Dice/card input toggles|
|**GameUI.PhaseMessages**|Phase message shown|
|**GameUI.UIState**|End phase button visibility|
|**GameUI.General**|Local debug toggle + helpers|

# 🧩 **5. Proposed Debug Categories for GameUI**

### **GameUI**

General lifecycle.

### **GameUI.Init**

Ready state, UI setup.

### **GameUI.MatchStart**

Start/cancel match.

### **GameUI.Input**

Keyboard input, invalid actions.

### **GameUI.Dice**

Dice rolling, dice completion.

### **GameUI.RollOutcome**

Preview roll totals.

### **GameUI.RoundResult**

Round resolution.

### **GameUI.GameOver**

Match end.

### **GameUI.Restart**

Restart logic.

### **GameUI.InputState**

Dice/card input toggles.

### **GameUI.PhaseMessages**

Phase UI messages.

### **GameUI.UIState**

End phase button visibility.

These will map directly into your global debug system.