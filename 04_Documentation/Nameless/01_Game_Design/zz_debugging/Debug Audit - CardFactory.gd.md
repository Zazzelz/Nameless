
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
        print(msg)

func _warn(msg: String) -> void:
    if debug_enabled:
        push_warning(msg)
```

These will eventually be replaced with:

gdscript

```
Debug.log("CardFactory", msg)
Debug.warn("CardFactory", msg)
```

## ✅ **3. Debug Calls Inside the Script**

### **A) Error / Warning Debug**

gdscript

```
_warn("CardFactory received null CardData")
```

Category: **CardFactory.Errors**

### **B) Card Spawn Debug**

Inside `update_cards()`:

gdscript

```
_log("Spawned %s in zone %s (%s/%s)" % [
    instance_id,
    zone_key,
    card.zone_owner,
    card.zone_type
])
```

This is the main debug output for this script.

Category: **CardFactory.Spawn**

This is extremely useful and should definitely be preserved in the new system.

### **C) Missing Debug Opportunities**

There are several places where debug logging _could_ exist but currently doesn’t:

#### **1. create_card()**

- No debug for card creation success
    
- No debug for reuse vs instantiate
    
- No debug for owner assignment
    
- No debug for group assignment
    

#### **2. _connect_card_signals()**

- No debug for signal connection
    
- No debug for already‑connected signals
    

#### **3. update_cards()**

- No debug for:
    
    - Clearing old visuals
        
    - Zone not found
        
    - Missing template_id
        
    - Missing card_data
        
    - Layout method chosen
        

We don’t need to add these now, but the new debug system will make it easy if you want them later.

# 🧩 **4. Summary of Debug Elements in CardFactory.gd**

|Category|Debug Elements Found|
|---|---|
|**CardFactory.Errors**|`_warn("CardFactory received null CardData")`|
|**CardFactory.Spawn**|`_log("Spawned %s in zone %s ...")`|
|**CardFactory.General**|Local debug toggle + helpers|
|**CardFactory.Signals**|_No debug yet_|
|**CardFactory.Layout**|_No debug yet_|

# 🧩 **5. Proposed Debug Categories for CardFactory**

Here’s the clean category structure that fits your architecture:

### **CardFactory**

General lifecycle, card creation, reuse, group assignment.

### **CardFactory.Spawn**

Card instantiation, zone placement, instance_id tracking.

### **CardFactory.Errors**

Null data, missing template, missing zone, etc.

### **CardFactory.Signals**

Signal connection, duplicate connection detection.

### **CardFactory.Layout**

Which layout method was chosen (layout_cards, layout_hand, etc.)

These will map directly into your global debug system.