
## ✅ **1. Debug Toggle**

You have a per‑script toggle:

gdscript

```
@export var debug_enabled: bool = false
```

This is local only — not connected to any global system.

## ✅ **2. Debug Logging Functions**

Two helpers:

gdscript

```
func _log(msg: String) -> void:
    if debug_enabled:
        print(msg)

func _warn(msg: String) -> void:
    if debug_enabled:
        push_warning(msg)
```

These are simple wrappers, but:

- They don’t include the script name
    
- They don’t support categories
    
- They don’t integrate with a global debug controller
    

We’ll replace these with:

gdscript

```
Debug.log("Card", msg)
Debug.warn("Card", msg)
```

## ✅ **3. Debug Calls Inside the Script**

### **A) UI Application Debug**

gdscript

```
_warn("Card: SubViewport never became ready")
_warn("Card: CardUi never appeared inside SubViewport")
_warn("Card: apply_card_data() called with no card_data")
_warn("Card: CardUi missing at apply time")
_log("Card UI applied: %s" % card_data.card_name)
```

These belong to a category like:

**Category: Card.UI**

### **B) Interaction Debug**

There is **no debug logging** inside:

- `_on_area_3d_input_event`
    
- `_on_card_double_clicked`
    

We may want to add:

- Click detection
    
- Double‑click detection
    
- Zone routing
    
- Play‑card events
    

But for now: **no debug present**.

### **C) Setup / Lifecycle Debug**

There is **no debug** in:

- `_ready()`
    
- `setup_from_data()`
    
- `reset_state()`
    
- `update_zone_info()`
    

We may want to add optional debug later, but currently: **none**.

# 🧩 **4. Summary of Debug Elements in Card.gd**

|Category|Debug Elements Found|
|---|---|
|**Card.UI**|`_warn()` calls for missing UI, `_log()` for applied UI|
|**Card.General**|Local debug toggle + logging helpers|
|**Card.Interaction**|_No debug yet_|
|**Card.ZoneInfo**|_No debug yet_|
|**Card.Lifecycle**|_No debug yet_|

# 🧩 **5. Proposed Debug Categories for Card.gd**

Here’s what makes sense for this script:

### [[**Card**]]

- General card lifecycle
    
- Setup/reset
    
- Zone updates
    

### **Card.UI**

- SubViewport readiness
    
- CardUi loading
    
- Label/icon population
    

### **Card.Input**

- Clicks
    
- Double‑clicks
    
- Drag/drop (if added later)
    

These categories will map into your global debug system.