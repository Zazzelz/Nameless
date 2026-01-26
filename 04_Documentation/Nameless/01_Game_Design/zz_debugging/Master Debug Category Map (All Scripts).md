
Below is the full set of categories your project naturally expresses. I’m grouping them by script, but the final system will flatten these into a single dictionary you can toggle globally or per‑category.

## **Card**

- [[Card.UI ]]— SubViewport readiness, CardUi loading, label/icon population
    
- Card.General — Local debug toggle, apply_card_data logs
    
- Card.Errors — Missing UI, missing card_data
    
- Card.Input — (Potential future category)
    
- Card.ZoneInfo — (Potential future category)
    

## **CardFactory**

- CardFactory.Spawn — Card instantiation, zone placement
    
- CardFactory.Errors — Null CardData
    
- CardFactory.Signals — Signal connection
    
- CardFactory.General — Local toggle, helpers
    

## **CardGameManager**

- CardGameManager.Init — Ready state
    
- CardGameManager.GameStart — Deck initialization
    
- CardGameManager.Signals — Deal signal connections
    
- CardGameManager.DeckState — Deck updates
    
- CardGameManager.Dealing — Deal requests, draw logic
    
- CardGameManager.Errors — Invalid states
    
- CardGameManager.General — Local toggle
    

## **DeckInspector**

- DeckInspector.Read — JSON deck contents
    
- DeckInspector.Errors — Missing file, invalid JSON
    
- DeckInspector.General — Local toggle
    

## **DeckManager**

- DeckManager.TemplateLoad — Loading `.tres` templates
    
- DeckManager.Init — Deck initialization
    
- DeckManager.Save — Saving deck JSON
    
- DeckManager.Load — Loading deck JSON
    
- DeckManager.Errors — Missing templates, invalid JSON
    
- DeckManager.General — Local toggle
    
- DeckManager.Draw — (Potential future category)
    
- DeckManager.Moves — (Potential future category)
    

## **DeckZone**

- DeckZone.Init — Ready state
    
- DeckZone.Layout — Camera‑relative layout
    
- DeckZone.Input — Click + double‑click
    
- DeckZone.Raycast — Ray lines, hit spheres, collider info
    
- DeckZone.Errors — Missing camera, missing Area3D
    
- DeckZone.General — Local toggle
    

## **Dice**

- Dice.Roll — Roll start, roll finish
    
- Dice.Value — Orientation → value mapping
    
- Dice.Errors — Missing UI
    
- Dice.General — Local toggle
    

## **DiscardZone**

- DiscardZone.Init — Ready state
    
- DiscardZone.Layout — Card stacking
    
- DiscardZone.General — Local toggle
    

## **GameUI**

- GameUI.Init — Ready state
    
- GameUI.MatchStart — Start/cancel match
    
- GameUI.Input — Accept key, invalid actions
    
- GameUI.Dice — Rolling dice, dice finished
    
- GameUI.RollOutcome — Preview roll totals
    
- GameUI.RoundResult — Round resolution
    
- GameUI.GameOver — Match end
    
- GameUI.Restart — Restart logic
    
- GameUI.InputState — Dice/card input toggles
    
- GameUI.PhaseMessages — Phase UI messages
    
- GameUI.UIState — End phase button visibility
    
- GameUI.General — Local toggle
    

## **HandZone**

- HandZone.Init — Ready state
    
- HandZone.Camera — Camera assignment
    
- HandZone.Layout — Card positioning
    
- HandZone.Errors — Missing camera
    
- HandZone.General — Local toggle
    

## **PlayZone**

- PlayZone.Init — Ready state
    
- PlayZone.Layout — Card placement
    
- PlayZone.General — Local toggle
    

## **ZoneManager**

- ZoneManager.Init — Ready state
    
- ZoneManager.Register — Zone discovery
    
- ZoneManager.Camera — Camera assignment
    
- ZoneManager.General — Local toggle