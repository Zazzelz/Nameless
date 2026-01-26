
## ✅ 1. Debug Toggle

You have a per‑script toggle:

gdscript

```
@export var debug_enabled: bool = false
```

Local only — not connected to a global system.

## ✅ 2. Debug Logging Helpers

gdscript

```
func _log(msg: String) -> void:
    if debug_enabled:
        print("[TurnManager] %s" % msg)

func _warn(msg: String) -> void:
    if debug_enabled:
        push_warning("[TurnManager] %s" % msg)
```

These will eventually become:

gdscript

```
Debug.log("TurnManager", msg)
Debug.warn("TurnManager", msg)
```

## ✅ 3. Debug Calls Inside the Script

### **A) Initialization Debug**

Inside `_late_init()`:

- GameUI connected to TurnManager
    
- GameUI not found in group
    
- CardGameManager connected to TurnManager
    
- CardGameManager not found in group
    

Category: **TurnManager.Init**

### **B) Match Start Debug**

Inside `_on_start_match_confirmed()`:

- Cannot start match — CardGameManager is NULL
    

Inside `_on_start_match_cancelled()`:

- Match cancelled. Quitting game
    

Category: **TurnManager.MatchStart**

### **C) Phase Change Debug**

Inside `_set_phase()`:

- Phase changed → X
    

Category: **TurnManager.PhaseChange**

### **D) Phase Handler Debug**

Inside `_handle_roll_dice()`:

- Phase Two: Roll the Dice
    

Inside `_handle_game_over()`:

- Game Over
    

Inside `_handle_enemy_turn()`:

- Enemy Turn begins
    

Inside `_handle_player_turn_2()`:

- Phase Three: Play Post-Roll cards
    

Inside `_handle_enemy_turn_2()`:

- Enemy reacts…
    

Inside `_handle_resolve_phase()`:

- Resolving round outcome…
    

Category: **TurnManager.PhaseHandlers**

### **E) Missing Debug Opportunities**

There are several places where debug logging _could_ exist but currently doesn’t:

- When advancing phases (`end_player_phase`, `advance_to_post_roll`, etc.)
    
- When round number increments
    
- When GameContext.board is missing
    
- When async waits complete
    

These aren’t required, but your new debug system will make it easy to add them later.

# 🧩 4. Summary of Debug Elements in TurnManager.gd

|Category|Debug Elements Found|
|---|---|
|TurnManager.Init|UI + manager connection logs|
|TurnManager.MatchStart|Start/cancel match|
|TurnManager.PhaseChange|Phase changed logs|
|TurnManager.PhaseHandlers|Begin, Player Turn, Enemy Turn, Roll Dice, Resolve, Game Over|
|TurnManager.Errors|Missing UI, missing CardGameManager|
|TurnManager.General|Local debug toggle + helpers|

# 🧩 5. Proposed Debug Categories for TurnManager

### **TurnManager**

General lifecycle.

### **TurnManager.Init**

Connecting UI, connecting CardGameManager.

### **TurnManager.MatchStart**

Start/cancel match.

### **TurnManager.PhaseChange**

Phase transitions.

### **TurnManager.PhaseHandlers**

Begin, Player Turn, Enemy Turn, Roll Dice, Post-Roll, Resolve, Game Over.

### **TurnManager.Errors**

Missing UI, missing CardGameManager, invalid state.

These will map directly into your global debug system.