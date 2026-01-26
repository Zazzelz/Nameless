
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
Debug.log("DeckManager", msg)
Debug.warn("DeckManager", msg)
```

## ✅ **3. Debug Calls Inside the Script**

### **A) Template Loading Debug**

Inside `load_base_cards()`:

gdscript

```
_warn("DeckManager: CardData missing template_id at %s" % path)
_log("DeckManager: Loaded templates: %s" % str(base_cards.keys()))
```

Categories:

- **DeckManager.Errors**
    
- **DeckManager.TemplateLoad**
    

### **B) Deck Initialization Debug**

Inside `initialize_deck()`:

gdscript

```
_warn("DeckManager: No templates loaded; cannot initialize deck")
_log("DeckManager: Initialized %s deck → %s" % [side, deck_state[deck_key]])
```

Categories:

- **DeckManager.Errors**
    
- **DeckManager.Init**
    

### **C) Save Deck Debug**

Inside `save_deck_to_json()`:

gdscript

```
_log("DeckManager: Saved %s deck → %s" % [side, path])
_warn("DeckManager: Could not save deck to %s" % path)
```

Categories:

- **DeckManager.Save**
    
- **DeckManager.Errors**
    

### **D) Load Deck Debug**

Inside `load_deck_from_json()`:

gdscript

```
_warn("DeckManager: No deck file at %s" % path)
_warn("DeckManager: Invalid JSON deck file")
_log("DeckManager: Loaded %s deck from %s" % [side, path])
```

Categories:

- **DeckManager.Errors**
    
- **DeckManager.Load**
    

### **E) Missing Debug Opportunities**

There are several places where debug logging _could_ exist but currently doesn’t:

#### **1. draw_card()**

- No debug for drawing a card
    
- No debug for empty deck
    
- No debug for new hand state
    

#### **2. move_card()**

- No debug for invalid zone names
    
- No debug for missing instance_id
    
- No debug for successful move
    

#### **3. cleanup_play_zone()**

- No debug for number of cards moved
    

#### **4. reshuffle_discard_into_deck()**

- No debug for shuffle results
    

We don’t need to add these now — but your new debug system will make it easy if you want them later.

# 🧩 **4. Summary of Debug Elements in DeckManager.gd**

|Category|Debug Elements Found|
|---|---|
|**DeckManager.TemplateLoad**|Loaded templates, missing template_id|
|**DeckManager.Init**|Deck initialization logs|
|**DeckManager.Save**|Deck saved|
|**DeckManager.Load**|Deck loaded|
|**DeckManager.Errors**|Missing file, invalid JSON, no templates, save failure|
|**DeckManager.General**|Local debug toggle + helpers|

# 🧩 **5. Proposed Debug Categories for DeckManager**

Here’s the clean category structure that fits your architecture:

### **DeckManager**

General lifecycle, state changes.

### **DeckManager.TemplateLoad**

Loading `.tres` files, missing template IDs.

### **DeckManager.Init**

Deck initialization, random deck generation.

### **DeckManager.Save**

Saving deck JSON.

### **DeckManager.Load**

Loading deck JSON.

### **DeckManager.Errors**

Missing files, invalid JSON, missing templates, save failures.

### **DeckManager.Moves** _(optional future category)_

Card movement between zones.

### **DeckManager.Draw** _(optional future category)_

Card draw events.

These will map directly into your global debug system.