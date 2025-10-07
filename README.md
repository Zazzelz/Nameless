

![Project Logo](./00_Assets/00_Concept_Art/NamelessBanner01.png)  <!-- Add your logo here -->

# 🎴 Game Design Document – Prototype: **Nameless**

**Version:** 1.2  
**Author:** Beth Hooper  
**Studio:** Find Pineapples Studios  
**Date:** October 6, 2025  

---

## 📖 Table of Contents
- [1. Executive Summary](#1-executive-summary)
- [2. Game Overview](#2-game-overview)
- [3. Gameplay Mechanics](#3-gameplay-mechanics)
  - [3.1 Combat](#31-combat)
  - [3.2 Exploration](#32-exploration)
- [4. MVP / PoC Plan](#4-mvp--poc-plan)
  - [4.1 Core MVP Goals](#41-core-mvp-goals)
  - [4.2 MVP Phase Overview](#42-mvp-phase-overview)
  - [4.3 Phase Details (Development Notes)](#43-phase-details-development-notes)
- [5. Technical Design](#5-technical-design)
- [6. Art & Audio Direction](#6-art--audio-direction)
- [7. Post-MVP Roadmap](#7-post-mvp-roadmap)
- [8. Future Concepts](#8-future-concepts)
- [9. Appendices](#9-appendices)

---

## 1. Executive Summary

> *"In the Feywild, even a name can be stolen."*

**Nameless** is a turn-based strategy game set in the whimsical and mysterious **Feywild**.  
Players control an adventurer who has lost their name and must reclaim it by exploring magical nodes, solving environmental puzzles, and dueling fey bosses using dice-and-card combat.

The game blends **strategic card play**, **risk/reward dice rolls**, and **painterly visuals** to create a unique indie experience.

🟥 **INSERT CONCEPT ART OF ADVENTURER OR NODE HERE**

---

## 2. Game Overview

**Genre:** Turn-based strategy / Dice + card combat / Exploration  
**Platform:** PC (Godot Engine)  
**Perspective:** Top-down or 3/4 isometric for exploration; first-person for combat  

### Core Concept
Players navigate the Feywild, collecting cards, unlocking dice and UI themes, solving riddles, and dueling fey bosses to reclaim their lost name.  
Each node blends puzzles, exploration, and combat into a cohesive experience.

### Gameplay Loop
1. Explore a node in the Feywild  
2. Encounter a fey boss  
3. Engage in turn-based dice + card combat  
4. Defeat boss → earn card rewards and riddle clues  
5. Progress to next node, collect new cards, uncover secrets  

🟥 **INSERT GAMEPLAY LOOP DIAGRAM HERE**

---

## 3. Gameplay Mechanics

### 3.1 Combat

<details>
<summary><b>Combat Phases</b></summary>

- **Pre-Roll Card Phase:** Play cards that modify dice outcomes (applied immediately or queued).  
- **Dice Roll Phase:** Player and enemy roll dice simultaneously with physics-based randomness.  
- **Post-Roll Card Phase:** Reactively play cards after seeing results.  
- **Resolution Phase:** Compare totals → apply HP/points → display narrative flavor text.

🟥 **INSERT COMBAT FLOWCHART HERE**

</details>

#### Dice System
- D6 dice represent attacks or skill checks.  
- Cards can reroll, swap, or buff dice.  

#### Card System
- Cards categorized by **timing**: pre-roll / post-roll.  
- Modify dice outcomes, stats, or trigger special effects.  
- Earn new cards from exploration or boss fights.  

#### Enemy AI
- Weighted, rule-based behavior reacting to player patterns.  
- Telegraphed attacks for clarity and fairness.  

#### Player Interaction
- Players select cards during pre/post phases.  
- Dice rolls occur automatically post-selection.  

---

### 3.2 Exploration

Nodes are compact, visually distinct areas containing puzzles, rewards, and clues.

**Example Node – Shimmering Glade**  
> A luminous grove of glowing flora, silver-barked trees, and crystal ponds.  
> Contains environmental puzzles and collectible cards.

Puzzle types include **logic**, **visual**, and **interactive** challenges.

🟥 **INSERT NODE LAYOUT / PUZZLE MOCKUP HERE**

---

## 4. MVP / PoC Plan

### 4.1 Core MVP Goals

- 🔄 Player dice + card selection system  
-  Enemy AI with weighted logic  
-  One boss fight (Lurielle) with “Cheat” mechanics  
-  Exploration node: *Shimmering Glade*  
-  Turn-based combat phases  
- Optional: basic animations and particle effects  

---

### 4.2 MVP Phase Overview

| Phase | Focus | Status |
|:------|:-------|:-------|
| **1** | Core Mechanics (dice, HP, match flow) | ✅ Completed |
| **2** | Card System (base data, effects) | 🔄 In Progress |
| **3** | Turn Manager / Phase Flow | ⏳ Planned |
| **4** | Boss Prototype (Lurielle) | ⏳ Planned |
| **5** | Exploration Node (Shimmering Glade) | ⏳ Planned |
| **6** | Player Integration | ⏳ Planned |
| **7** | Polish Pass | ⏳ Planned |
| **8** | MVP Playtest | ⏳ Planned |

---

### 4.3 Phase Details (Development Notes)

<details>
<summary><b>Phase 1 – Core Mechanics ✅</b></summary>

- Implemented D6 dice with random physics  
- HP UI and round resolution logic  
- Basic match messaging system  

🟥 **INSERT SCREENSHOT / MOCKUP OF MVP DICE COMBAT HERE**

</details>

<details>
<summary><b>Phase 2 – Card System 🔄</b></summary>

- Base Card scripts + `.tres` data files  
- Deck creation and dealing logic  
- Hover/selection animations  
- In progress: placement + discard logic  

🟥 **INSERT CARD UI MOCKUP HERE**

</details>

<details>
<summary><b>Phase 4 – First Boss Prototype</b></summary>

- **Boss:** *Lurielle* – Silver-skinned Fey boss with 3 phases (Defensive → Aggressive → Cheat)  
- Unique “Cheat” ability: steal dice / manipulate rolls  

🟥 **INSERT BOSS COMBAT UI MOCKUP HERE**

</details>

<details>
<summary><b>Phase 5 – Exploration Node</b></summary>

- Build *Shimmering Glade* with puzzles, collectibles, and light interactivity  

🟥 **INSERT NODE PUZZLE DIAGRAM OR ENVIRONMENT CONCEPT ART HERE**

</details>

---

## 5. Technical Design

### 5.1 Architecture
- **Engine:** Godot (GDScript)  
- **Structure:** Modular nodes (`CardManager`, `TurnManager`, `NodeManager`)  
- **Flow:** Signals + deferred calls for async UI and logic  

### 5.2 Card & Deck Data (MVP)
- `.tres` files store: name, type, phase, cost, effect  
- Decks and hands stored in runtime dictionaries  

### 5.3 Planned JSON Architecture
Post-MVP migration to JSON for:  
- Easier editing and modding  
- Deck import/export  
- Serialized player progress  

### 5.4 Save & Reward System
- Stores: decks, unlocked skins, boss progress  
- Rewards: cards, dice skins, UI themes  
- JSON save planned post-MVP  

🟥 **INSERT SAVE SYSTEM DIAGRAM / JSON STRUCTURE HERE**

---

## 6. Art & Audio Direction

### 6.1 Visual Style
- 3D with **painterly / watercolor textures**  
- Magical glow for dice, cards, and landscapes  
- **Inspirations:** *Ori and the Blind Forest*, *Studio Ghibli*, *Trine*  

🟥 **INSERT STYLE REFERENCE IMAGES HERE**

### 6.2 Characters
- **Adventurer:** Slender, modest garb, faint magical aura  
- **Lurielle:** Silver-skinned, gossamer gown, ethereal hair  

🟥 **INSERT CHARACTER CONCEPT ART HERE**

### 6.3 Audio
- **Ambient:** Feywild wind, chimes, rustling leaves  
- **Dice:** tactile roll sounds  
- **Cards:** shimmer effects  
- **Boss:** melodic telegraphs  

---

## 7. Post-MVP Roadmap

| Milestone | Focus | Est. Timeline (Part-Time) |
|:-----------|:--------|:--------------------------|
| **Vertical Slice (MVP)** | 1 Node + 1 Boss | 3–4 months |
| **Additional Nodes** | 2–3 more nodes + bosses | +4–6 months |
| **Thematic Unlocks** | Card/Dice/UI skins | +2 months |
| **Wager System** | Fey Gamble mechanic | +2–3 months |
| **Narrative & Polish** | Lore + dialogue | +3 months |
| **Beta Build** | Full progression | ~12–14 months |
| **Full Release** | QA, Marketing, Steam | ~16 months |

---

## 8. Future Concepts

### Fey Gamble Mechanic
> Risk/reward betting influencing dice rolls and draws.

### Customization & Unlocks
> Dice and card skins with theme-based UI sets.

### Boss Mechanics
> Cheating, card/dice theft, multi-phase behavior.

### UI Abstraction & Skin System

Refactor `apply_card_data()` into a modular `CardUIController.gd` to support themed UI and skin customization.

```gdscript
func apply_card_data(card_data: CardData, card_ui: Control):
    # Assign name, description, icon, and visuals

```
Benefits:

>Modular and testable UI

>Supports unlockables, modding, and polish

🟥 INSERT MOCKUP OF SKINNED CARD UI HERE

## 9. Appendices

🟥 INSERT FULL CARD LIST HERE
🟥 INSERT BOSS MECHANICS TABLE HERE
🟥 INSERT PUZZLE DESCRIPTIONS / LAYOUTS HERE
🟥 INSERT ASSET INVENTORY HERE
