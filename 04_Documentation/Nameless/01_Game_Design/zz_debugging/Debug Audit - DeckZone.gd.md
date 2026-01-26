
## ✅ **1. Debug Toggle**

You have a per‑script toggle:

gdscript

```
@export var debug_enabled: bool = false
```

Local only — not connected to a global system.

## ✅ **2. Debug Logging Helper**

gdscript

```
func _log(msg: String) -> void:
    if debug_enabled:
        print("[DeckZone] %s" % msg)
```

⚠️ **Important:** There is **no** `_warn()` **function**, but you call `_warn()` inside `_is_mouse_over_deck()`:

gdscript

```
_warn("No camera found")
_warn("Top card has no Area3D")
```

This means `_warn()` is missing and will error if those branches run.

We’ll fix this when we unify the debug system.

## ✅ **3. Debug Calls Inside the Script**

### **A) Initialization Debug**

Inside `_ready()`:

gdscript

```
_log("Ready")
```

Category: **DeckZone.Init**

### **B) Layout Debug**

Inside `layout_card()`:

gdscript

```
_log("No camera found for layout")
_log("Laid out card %s at index %d" % [card.name, index])
```

Category: **DeckZone.Layout**

This is extremely useful for debugging camera‑relative positioning.

### **C) Input Debug**

Inside `_input()`:

gdscript

```
_log("DeckZone received input")
```

Category: **DeckZone.Input**

### **D) Double‑Click Debug**

Inside `_on_double_click()`:

gdscript

```
_log("Deck double-clicked → deal_requested emitted")
```

Category: **DeckZone.Input**

### **E) Raycast Debug**

Inside `_is_mouse_over_deck()`:

#### **Warnings**

gdscript

```
_warn("No camera found")
_warn("Top card has no Area3D")
```

Category: **DeckZone.Errors**

#### **Raycast visualization**

gdscript

```
DebugDraw3D.draw_line(from, to, Color.RED, 0.05)
_log("Ray from %s to %s" % [str(from), str(to)])
```

Category: **DeckZone.Raycast**

#### **Hit debug**

gdscript

```
_log("Ray hit collider: %s" % str(result.collider))
_log("Hit position: %s" % str(result.position))
DebugDraw3D.draw_sphere(result.position, 0.05, Color.GREEN)
```

Category: **DeckZone.Raycast**

#### **Miss debug**

gdscript

```
_log("Raycast missed all colliders")
```

Category: **DeckZone.Raycast**

#### **Card collider debug**

gdscript

```
_log("Top card Area3D: %s at %s" % [str(card_area), str(card_area.global_transform.origin)])
```

Category: **DeckZone.Raycast**

# 🧩 **4. Summary of Debug Elements in DeckZone.gd**

|Category|Debug Elements Found|
|---|---|
|**DeckZone.Init**|Ready message|
|**DeckZone.Layout**|Layout success, missing camera|
|**DeckZone.Input**|Input received, double‑click|
|**DeckZone.Raycast**|Ray line, hit sphere, hit info, miss info, collider info|
|**DeckZone.Errors**|Missing camera, missing Area3D|
|**DeckZone.General**|Local debug toggle + helpers|

# 🧩 **5. Proposed Debug Categories for DeckZone**

### **DeckZone**

General lifecycle.

### **DeckZone.Init**

Ready state, metadata setup.

### **DeckZone.Layout**

Camera‑relative card positioning.

### **DeckZone.Input**

Click + double‑click detection.

### **DeckZone.Raycast**

Raycast visualization, hit/miss info, collider info.

### **DeckZone.Errors**

Missing camera, missing Area3D.

These will map directly into your global debug system.

# 🧩 **6. Important Note: Missing** `_warn()`

You call `_warn()` but never define it.

This will be fixed automatically when we switch to:

gdscript

```
Debug.warn("DeckZone", msg)
```