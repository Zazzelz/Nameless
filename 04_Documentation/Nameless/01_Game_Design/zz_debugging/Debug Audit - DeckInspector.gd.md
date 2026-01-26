
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
Debug.log("DeckInspector", msg)
Debug.warn("DeckInspector", msg)
```

## ✅ **3. Debug Calls Inside the Script**

### **A) File Missing / Error Debug**

gdscript

```
_warn("Deck file not found at: %s" % path)
_warn("Failed to open deck file.")
_warn("Invalid JSON format in deck file.")
```

Category: **DeckInspector.Errors**

### **B) Deck Contents Debug**

gdscript

```
_log("📦 Deck contents:")
_log("  %s: %s" % [key, result[key]])
```

Category: **DeckInspector.Read**

This is useful for verifying deck JSON structure.

### **C) Missing Debug Opportunities**

There are no debug logs for:

- `_ready()`
    
- Successful file open
    
- JSON parse success
    
- Path being read
    

We don’t need to add these now, but the new debug system will make it easy if you want them later.

# 🧩 **4. Summary of Debug Elements in DeckInspector.gd**

|Category|Debug Elements Found|
|---|---|
|**DeckInspector.Errors**|Missing file, failed open, invalid JSON|
|**DeckInspector.Read**|Deck contents printed|
|**DeckInspector.General**|Local debug toggle + helpers|

# 🧩 **5. Proposed Debug Categories for DeckInspector**

### **DeckInspector**

General lifecycle, file operations.

### **DeckInspector.Read**

Deck JSON contents, key/value output.

### **DeckInspector.Errors**

File missing, invalid JSON, failed open.

These will map directly into your global debug system.