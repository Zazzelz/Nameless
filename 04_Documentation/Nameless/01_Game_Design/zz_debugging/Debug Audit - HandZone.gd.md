
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
        print("[HandZone] %s" % msg)

func _warn(msg: String) -> void:
    if debug_enabled:
        push_warning("[HandZone] %s" % msg)
```

These will eventually become:

gdscript

```
Debug.log("HandZone", msg)
Debug.warn("HandZone", msg)
```

## ✅ **3. Debug Calls Inside the Script**

### **A) Initialization Debug**

Inside `_ready()`:

gdscript

```
_log("Ready")
```

Category: **HandZone.Init**

### **B) Camera Assignment Debug**

Inside `set_camera()`:

gdscript

```
_log("Camera assigned")
```

Category: **HandZone.Camera**

### **C) Layout Debug**

Inside `layout_hand()`:

#### Missing camera:

gdscript

```
_warn("No camera assigned")
```

Category: **HandZone.Errors**

#### No cards:

gdscript

```
_log("No cards to layout")
```

Category: **HandZone.Layout**

#### Successful layout:

gdscript

```
_log("Laid out %d hand cards" % total)
```

Category: **HandZone.Layout**

## 🧩 **4. Summary of Debug Elements in HandZone.gd**

|Category|Debug Elements Found|
|---|---|
|**HandZone.Init**|Ready message|
|**HandZone.Camera**|Camera assigned|
|**HandZone.Layout**|No cards, layout success|
|**HandZone.Errors**|Missing camera|
|**HandZone.General**|Local debug toggle + helpers|

## 🧩 **5. Proposed Debug Categories for HandZone**

### **HandZone**

General lifecycle.

### **HandZone.Init**

Ready state, metadata setup.

### **HandZone.Camera**

Camera assignment, camera‑dependent behavior.

### **HandZone.Layout**

Card positioning, spacing, orientation.

### **HandZone.Errors**

Missing camera, invalid state.

These will map directly into your global debug system.