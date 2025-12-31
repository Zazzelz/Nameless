---
banner: pixel-banner-images/NamelessBanner04.png
banner-x: 49
banner-y: 87
banner-fade: -40
banner-radius: 47
banner-height: 590
content-start: 581
banner-display: contain
banner-repeat: false
---
# **Nameless (Working Title)**

## **Game Design Document — Prototype v2.0**

Find Pineapples Studios | November 2025
## **Table of Contents**

- [[#1-executive-summary|1. Executive Summary]]
- [[#2-game-overview|2. Game Overview]]
- [[#3-gameplay-mechanics|3. Gameplay Mechanics]]  
     - [[#31-exploration-nodes|3.1 Exploration Nodes]]  
     - [[#32-combat-nodes|3.2 Combat Nodes]]  
     - [[#33-wager-system|3.3 Wager System]]  
     - [[#34-persistent-deck--progression|3.4 Persistent Deck & Progression]]  
     - [[#35-procedural-adventurer-system|3.5 Procedural Adventurer System]]
- [[#4-mvp--proof-of-concept-plan|4. MVP / Proof of Concept Plan]]  
     - [[#41-core-mvp-goals|4.1 Core MVP Goals]]  
     - [[#42-mvp-phase-overview|4.2 MVP Phase Overview]]  
     - [[#43-phase-details-development-notes|4.3 Phase Details (Development Notes)]]
- [[#5-technical-design|5. Technical Design]]
- [[#6-art--animation-direction|6. Art & Animation Direction]]
- [[#7-audio-direction|7. Audio Direction]]
- [[#8-post-mvp-roadmap|8. Post-MVP Roadmap]]
- [[#9-creative-expansion|9. Creative Expansion]]  
     - [[#91-boss-compendium|9.1 Boss Compendium]]  
     - [[#92-exploration-node-aesthetic-direction|9.2 Exploration Node Aesthetic Direction]]
- [[#10-appendices|10. Appendices]]
## 1. Executive Summary

_Nameless_ is a folklore-inspired rogue-lite where mortals are pawns in a cosmic game of chance.

Players oversee an Adventurer — a stop-motion puppet exploring eerie diorama worlds. The Player themselves is an unseen otherworldly being, wagering the Adventurer’s fate against rival entities in games of cards and dice.

The Adventurer seeks to reclaim their lost name — a fragment of their identity bartered away. Through exploration, puzzles, and duels, the Player collects cards, wagers fate, and uncovers the truth: they are not a savior, but another puppeteer in an endless cycle.



---

## 2. Game Overview

**Genre:** Turn-based rogue-lite / folklore strategy  
**Platform:** PC (Godot Engine)  
**Perspective:** Dual — Isometric Exploration & First-Person Combat
## **Core Gameplay Loop**
![[GDD2-1.png |300]]
Explore folklore-inspired nodes (puzzles, card collection, lore fragments).

Engage in dice-and-card duels against powerful spirits.

Wager the Adventurer’s being for clues and rewards.

Defeat bosses to progress toward the final realm.

Lose, and the Adventurer fades — a new puppet takes their place.



---

# **3. Gameplay Mechanics**

## **3.1 Exploration Nodes**

- Diorama-style scenes viewed from an isometric 3/4 perspective.
- Player indirectly manipulates the Adventurer to solve puzzles and gather cards.
- Adventurer occasionally shows awareness — hesitant glances or pauses.
- Nodes contain lore collectibles and environmental riddles.
- Aesthetic draws from world folklore: roots, lanterns, mist, rituals.
- 
**Visual Placeholder:** _Diorama concept — glowing fungi, fog, puppet Adventurer with thread joints._

---

## **3.2 Combat Nodes**

- Perspective shifts to first-person; the Player faces a boss across a cosmic table.
- The Adventurer stands beside them, fading as wagers are lost.
- Combat blends tactical card play, dice physics, and boss “cheat” mechanics.
### **Combat Flow**

1. **Pre-Roll Card Phase:** Cards modify dice outcomes.
2. **Dice Roll Phase:** Both sides roll; physics-based randomness.
3. **Post-Roll Phase:** Reactive cards trigger.
4. **Resolution Phase:** Totals compared, wagers applied, narrative feedback.

**Diagram Placeholder:** _Combat timeline — Pre-roll → Roll → Post-roll → Resolution._

---

## **3.3 Wager System**

- Player selects Low, Medium, or High stakes each round.
- Winning yields clues or riddles.
- Losing weakens the Adventurer (fade, stiffness, dice penalties).
- Boss temperament modifies wager outcomes:
    - Tricksters reward boldness.
    - Guardians punish risk.
    - Fate entities randomize stakes.
- Some bosses force wagers.

**Visual Placeholder:** _Wager UI — three glowing sigils with boss reactions._

---

## **3.4 Persistent Deck & Progression**

- Players select a starting deck before each run.
- Deck persists across playthroughs.
- Cards represent memories, whispers, folkloric boons.
- Wager outcomes can unlock rare cards.

**MVP Deck Scope:**

- 12 base cards
- 3 unlockables from MVP boss

**Visual Placeholder:** _Card sheet — hand-painted textures, stitched borders._

---

## **3.5 Procedural Adventurer System**

- Each run creates a unique Adventurer (appearance, clothing, demeanor).
- Retains puppet construction with variation in material and tone.
- Reinforces the theme of countless previous souls.    

**Visual Placeholder:** _Lineup of puppet variants._

---

# **4. MVP / Proof of Concept Plan**

## **4.1 Core MVP Goals**

- Functional dice + card systems.
- One exploration node: **The Glimmering Glade**.
- One boss encounter: **The Glimmering Dryad**.
- Active cheat + wager systems.    
- Simplified persistent deck + procedural Adventurer.
- Diegetic tutorial via encounter design.

---

## **4.2 MVP Phase Overview**

| Phase | Focus                              | Status      |
| ----- | ---------------------------------- | ----------- |
| 1     | Core Dice + Health Systems         | ✅ Complete  |
| 2     | Card Architecture & UI             | In Progress |
| 3     | Turn Manager & Combat Flow         | Planned     |
| 4     | Boss: The Glimmering Dryad         | Planned     |
| 5     | Exploration Node: Glimmering Glade | Planned     |
| 6     | System Integration                 | Planned     |
| 7     | Polish (Animation, UI, FX)         | Planned     |
| 8     | MVP Playtest & Balance             | Pending     |

---

## **4.3 Phase Details (Development Notes)**

### **MVP Boss: The Glimmering Dryad**

- **Folklore Inspiration:** Tree spirits / nature guardians
- **Cheat Mechanic:** _Living Roots_ — moves dice subtly or entangles cards
- **Visuals:** Bark humanoid, glowing leaves, vine hair with bioluminescence
- **Arena:** Silver trees, glowing fungi, soft mist
- **Design Intent:** Introduce cheats + wagers gently

**Visual Placeholder:** _Dryad concept art — roots entangling cards._

---

# **5. Technical Design**

**Engine:** Godot (GDScript)

### **Core Systems**

- `CardManager`
- `DiceManager`
- `TurnManager`
- `NodeManager`
### **Architecture**

- Signal-based modular flow between UI and logic
- Combat nodes modular for easy boss swapping
### **Data**

- MVP uses `.tres` card data
- Future: JSON for modding & persistence
### **Procedural Adventurer**

- Seed-based randomization
- Seed stored for replay consistency

**Diagram Placeholder:** _Deck ↔ Dice ↔ Wager ↔ Reward systems._

---

# **6. Art & Animation Direction**

- **Aesthetic:** Folkloric stop-motion realism
- **Adventurer:** Animated on 2s–3s, stuttery, visible seams
- **Bosses/Entities:** Animated on 1s — smooth, uncanny contrast
- **Lighting:** Miniature volumetrics, candlelight
- **Palette:** Earth tones + spectral hues

**Visual Placeholder:** _Stop-motion Adventurer vs fluid being._

---

# **7. Audio Direction**

- **Ambient:** Winds, creaks, water trickles
- **Combat:** Wooden dice, parchment pulls, chimes
- **Boss Themes:** Regional folk instruments per boss
- **Dialogue:** Text-based with ambient modulation

**Visual Placeholder:** _Audio board — folk instruments, waveform moods._

---

# **8. Post-MVP Roadmap**

|Milestone|Focus|Timeline|
|---|---|---|
|Vertical Slice|MVP Node + Boss|3–4 months|
|Additional Nodes|+2–3 Bosses|+5–6 months|
|Deck Expansion|New cards + rarities|+2 months|
|Wager Expansion|Boss-specific preferences|+2–3 months|
|Narrative Systems|Foreshadowing, meta-events|+3 months|
|Beta|4–5 Node Loop|~12–14 months|
|Full Release|QA + Steam Launch|~16 months|

---

# **9. Creative Expansion**

## **9.1 Boss Compendium**

| Boss                      | Folklore             | Cheat               | Visuals               | Arena             |
| ------------------------- | -------------------- | ------------------- | --------------------- | ----------------- |
| **The Glimmering Dryad**  | Tree spirit          | Living Roots        | Bark + glowing leaves | Silver forest     |
| **The Hollow Cailleach**  | Celtic winter hag    | Frostbite Swap      | Ice cloak             | Frozen grove      |
| **The Whispering Nymph**  | Greek Naiad          | Rippling Reflection | Liquid teal form      | Crystal pond      |
| **The Trickster Hare**    | Trickster folklore   | Moonlit Mischief    | Hare spirit           | Moon meadow       |
| **The Lantern Shade**     | Yōkai                | Shadow Swap         | Lantern-headed shadow | Foggy forest      |
| **The Crimson Piper**     | Pied Piper           | Hypnotic Melody     | Faceless musician     | Twilight ruins    |
| **Weeping Willow Warden** | Slavic               | Tendrils of Sorrow  | Willow giant          | Riverbank         |
| **The Nameless Stitch**   | Trickster/fate deity | Threads of Fate     | Threaded faces        | Surreal platforms |

**Placeholder:** _Boss lineup thumbnails._

---

## **9.2 Exploration Node Aesthetic Direction**

- **The Glimmering Glade:** Silver trees, glowing moss
- **The Frozen Hollow:** Ice, wind-chimes
- **The River Mirror:** Reflective pools
- **The Moon Meadow:** Lunar grassland
- **The Ember Court:** Candle ruins
- **The Stitching Loom:** Abstract void

**Placeholder:** _Node moodboard._

---

# **10. Appendices**

- **Appendix A:** Base Card List
- **Appendix B:** Boss AI Behavior Matrix
- **Appendix C:** Procedural Adventurer Variables
- **Appendix D:** Shader & Lighting Reference

**Placeholder:** _Example card table and flow map._