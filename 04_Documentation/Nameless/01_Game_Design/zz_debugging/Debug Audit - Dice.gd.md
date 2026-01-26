
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
Debug.log("Dice", msg)
Debug.warn("Dice", msg)
```

## ✅ **3. Debug Calls Inside the Script**

### **A) Roll Debug**

Inside `roll()`:

gdscript

```
_log("Dice rolled: %s" % dice_name)
```

Category: **Dice.Roll**

This is essential for tracking dice interactions.

### **B) Finish‑Rolling Debug**

Inside `_process()`:

gdscript

```
_log("Dice finished reporting: %s at frame %d" %
    [dice_name, Engine.get_frames_drawn()])
```

Category: **Dice.Roll**

This is extremely useful for timing and physics debugging.

### **C) Missing UI Debug**

Inside `_process()`:

gdscript

```
_warn("GameUI not found when reporting dice result")
```

Category: **Dice.Errors**

### **D) Roll Value Debug**

Inside `get_roll_value()`:

gdscript

```
_log("Dice %s roll value evaluated as %d" % [dice_name, value])
```

Category: **Dice.Value**

This is perfect for verifying orientation‑based dice logic.

## 🧩 **4. Summary of Debug Elements in Dice.gd**

|Category|Debug Elements Found|
|---|---|
|**Dice.Roll**|Rolled, finished reporting|
|**Dice.Value**|Roll value evaluation|
|**Dice.Errors**|Missing GameUI|
|**Dice.General**|Local debug toggle + helpers|

## 🧩 **5. Proposed Debug Categories for Dice**

### **Dice**

General lifecycle.

### **Dice.Roll**

Roll start, roll finish, physics state.

### **Dice.Value**

Orientation → value mapping.

### **Dice.Errors**

Missing UI, invalid state.

These will map directly into your global debug system.