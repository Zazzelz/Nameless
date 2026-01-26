
## ✅ **1. Debug Toggle**

You have a per‑script toggle:

gdscript

```
@export var debug_enabled: bool = false
```

This is local only and not connected to any global system.

## ✅ **2. Debug Logging Helpers**

Two local helpers:

gdscript

```
func _log(msg: String) -> void:
    if debug_enabled:
        print("[CardGameManager] %s" % msg)

func _warn(msg: String) -> void:
    if debug_enabled:
        push_warning("[CardGameManager] %s" % msg)
```

These include the script name in the message, which is good — but they will eventually be replaced with:

gdscript

```
Debug.log("CardGameManager", msg)
Debug.warn("CardGameManager", msg)
```

## ✅ **3. Debug Calls Inside the Script**

### **A) Initialization Debug**

Inside `_ready()`:

gdscript

```
_log("CardGameManager ready — waiting for UI to start match")
```

Category: **CardGameManager.Init**

### **B) Game Start Debug**

Inside `start_game()`:

gdscript

```
_warn("Game already started")
_log("Starting game — initializing decks")
_log("Decks initialized")
```

Category:

- **CardGameManager.Errors**
    
- **CardGameManager.GameStart**
    

### **C) Signal Connection Debug**

Inside `_connect_deck_signals()`:

gdscript

```
_log("Connected deal_requested from %s" % zone_key)
```

Category: **CardGameManager.Signals**

### **D) Deck State Debug**

Inside `_on_deck_state_changed()`:

gdscript

```
_log("Ignoring deck_state_changed — game not started yet")
```

Category: **CardGameManager.DeckState**

### **E) Deal Request Debug**

Inside `_on_deal_requested()`:

gdscript

```
_warn("Cannot deal — game not started")
_warn("Player already drew this turn")
_log("Deal requested → dealing top card to player hand")
```

Category:

- **CardGameManager.Errors**
    
- **CardGameManager.Dealing**
    

### **F) Deal Execution Debug**

Inside `_deal_card_to_player()`:

gdscript

```
_warn("Player deck is empty, cannot deal")
```

Category: **CardGameManager.Errors**

# 🧩 **4. Summary of Debug Elements in CardGameManager.gd**

|Category|Debug Elements Found|
|---|---|
|**CardGameManager.Init**|Ready message|
|**CardGameManager.GameStart**|Deck initialization logs|
|**CardGameManager.Errors**|Game already started, cannot deal, deck empty|
|**CardGameManager.Signals**|Deal signal connection|
|**CardGameManager.DeckState**|Ignoring deck updates before game start|
|**CardGameManager.Dealing**|Deal request + deal action|
|**CardGameManager.General**|Local debug toggle + helpers|

# 🧩 **5. Proposed Debug Categories for CardGameManager**

Here’s the clean category structure that fits your architecture:

### **CardGameManager**

General lifecycle, ready state, initialization.

### **CardGameManager.GameStart**

Deck initialization, match start.

### **CardGameManager.Signals**

Zone signal connections.

### **CardGameManager.DeckState**

Deck updates, ignored updates, state changes.

### **CardGameManager.Dealing**

Deal requests, deal execution, draw logic.

### **CardGameManager.Errors**

Invalid states, double‑draw attempts, empty deck.

These will map directly into your global debug system.