# 🎲 Game Design Document – Prototype: *Nameless* (Updated)

## 📜 Table of Contents
- [1. Overview](#1-overview)
- [2. Gameplay Mechanics](#2-gameplay-mechanics)
  - [2.1 Combat (Updated)](#21-combat-updated)
  - [2.2 Exploration (Updated)](#22-exploration-updated)
- [3. Art Direction](#3-art-direction)
  - [3.1 Environment](#31-environment)
  - [3.2 Boss / Character Design](#32-boss--character-design)
  - [3.3 Visual Style](#33-visual-style)
- [4. Audio](#4-audio)
- [5. MVP Features](#5-mvp-features)
- [6. Roadmap to MVP (Updated)](#6-roadmap-to-mvp-updated)
- [7. Combat Update – Fey Gamble Mechanic (Future Concept)](#7-combat-update--fey-gamble-mechanic-future-concept)
- [8. References & Influences](#8-references--influences)
- [9. Technical Considerations](#9-technical-considerations)
- [10. Future Ideas](#10-future-ideas)

---

## 1. Overview

**Title:** *(working title)* Nameless  
**Genre:** Turn-based strategy / dice + card combat / exploration  
**Platform:** PC / Godot Engine prototype  
**Perspective:** Top-down or 3/4 isometric for exploration, first-person for combat  

### Core Concept
The player controls **an Adventurer** who has lost their name.  
To reclaim it, they must navigate the **Feywild**, combat fey bosses in **dice-based card duels**, solve riddles, and overcome **environmental puzzles** that lead to the next encounter.

### Gameplay Loop
1. Explore small nodes of the Feywild  
2. Encounter a fey boss  
3. Engage in dice + card turn-based combat  
4. Defeat the boss → receive a card reward and a riddle pointing to the next node  
5. Collect new cards and explore further  

---

## 2. Gameplay Mechanics

### 2.1 Combat (Updated)

#### Combat Loop & Phases
Each round of combat is divided into distinct phases to allow simultaneous dice rolls, card play, and post-roll resolution:

1. **Pre-Roll Card Phase (Simultaneous)**
   - Player and enemy can play cards that affect dice outcomes.  
   - Both sides act at the same time; effects are applied immediately or queued.

2. **Dice Roll Phase (Simultaneous)**
   - Player and enemy roll dice simultaneously.  
   - Dice physics and animations run independently.  
   - (Optional) A slight enemy delay can be added for visual variety.  

3. **Post-Roll Card Phase (Simultaneous)**
   - Both sides can play cards triggered by the roll.  
   - All card effects (buffs, debuffs, modifiers) are resolved.  

4. **Resolution Phase**
   - Dice totals are compared.  
   - HP or points are applied/updated after both sides complete the post-roll phase.  
   - Round results are displayed via UI and narrative text.  

#### 🎲 Dice System
- Each dice roll represents an **attack or influence check**.  
- Higher total roll wins the round.  
- Dice outcomes are affected by card effects (pre- or post-roll).  

#### 🃏 Card System
- Cards modify dice outcomes (*double roll, swap dice, impose disadvantage*).  
- Both players and enemies have decks; cards are earned or found during exploration.  
- Card timing is tied to combat phases (*pre-roll or post-roll*).  

#### 🤖 Enemy AI
- Weighted rule-based AI with HP-based phases.  
- Makes card and dice decisions simultaneously with the player.  
- Uses **telegraphed attacks** for clarity and fairness.  

#### 🎮 Player Interaction
- Players select cards to play during pre-roll and post-roll phases.  
- Dice roll automatically after the pre-roll card phase.  

---

### 2.2 Exploration (Updated)

Nodes are small, distinct locations — starting with **“Shimmering Glade.”**

Each node contains:
- Environmental clues for riddles and puzzles.  
- Collectible cards.  
- Visual markers for paths to the next node.  
- Minimal movement/exploration focus — visually engaging and interactive.  

Puzzle elements provide:
- Additional challenge.  
- Narrative context.  
- Rewards beyond combat.  

---

## 3. Art Direction

### 3.1 Environment
**Shimmering Glade Node:**
- Mossy ground, glowing blue/purple flowers.  
- Twisted silver-barked trees.  
- Crystalline pond, floating light motes.  
- Subtle mist and interactive objects (glowing mushrooms, stones).  

### 3.2 Boss / Character Design
**Adventurer:**  
Slender build, undercut hairstyle, simple adventuring garb.  

**Lurielle:**  
Slender fey, silver sheen skin, flowing translucent hair with motes, gossamer gown.  
Subtle magical orbiting flora to indicate interaction.  

### 3.3 Visual Style
- Semi-realistic painterly textures.  
- Emphasis on magical glow (bioluminescent plants, dice/card effects).  
- **Influences:** *Ori and the Blind Forest*, *Studio Ghibli*, *Trine*, *Death’s Door*.  

---

## 4. Audio
- Ambient Feywild sounds: soft wind, chimes, rustling leaves.  
- Dice rolls: subtle clatter.  
- Card effects: light magical chimes, glow or shimmer cues.  
- Boss telegraphs: musical cues for upcoming attacks.  

---

## 5. MVP Features

### 5.1 Core Features
- Player dice roll + card selection system.  
- Enemy AI with weighted dice/card decisions.  
- One boss fight (*Lurielle*) with phases and telegraphed attacks.  
- Exploration node (*Shimmering Glade*) with collectible cards and puzzles.  
- Riddle/puzzle hint for next encounter.  
- Fully functional turn-based combat loop.  

### 5.2 Optional MVP Additions
- Basic animations for dice, cards, and boss abilities.  
- Simple particle effects for magical ambiance.  

---

## 6. Roadmap to MVP (Updated)

| **Phase** | **Goal** | **Description / Notes** |
|------------|-----------|--------------------------|
| **1** | Core Mechanics | Dice roll system, basic player health, placeholder enemy with weighted AI. |
| **2** | Card System | Implement card classes and effects for player and boss. |
| **3** | Turn Manager / Phase System | Divide combat into pre-roll, roll, post-roll, and resolution phases. |
| **4** | First Boss Prototype | Implement Lurielle with weighted AI and card interactions. |
| **5** | Exploration Node | Build *Shimmering Glade* with collectible cards, puzzles, and path cues. |
| **6** | Player Integration | Full input system; test combat loop with phased cards. |
| **7** | Polish | Add animations, particle effects, UI polish. |
| **8** | MVP Test | Playtest single node + boss + combat system; evaluate balance, clarity, and fun. |

---

## 7. Combat Update – Fey Gamble Mechanic (Future Concept)

### Concept Overview
A **betting phase** where players and enemies wager points or resources at the start of each round.

#### Flow
1. **Betting Phase:** Choose wager amount.  
2. **Card Draw:** Number of cards drawn depends on wager.  
3. **Dice Roll:** Simultaneous rolls with card modifiers.  
4. **Points Exchange:** Winner gains opponent’s wagered points.  
5. **Narrative Flavor:** Described as Feywild “stories” influencing fate.  

**Strategic Implications:**
- High wagers → more cards/faster progress, higher risk.  
- Low wagers → safer play, fewer options.  

---

## 8. References & Influences

### Visual / Atmosphere
- *Ori and the Blind Forest*  
- *Studio Ghibli*  
- *Darkest Dungeon*  

### Gameplay / Mechanics
- Tabletop dice/card games.  
- *XCOM*, *Slay the Spire*.  

---

## 9. Technical Considerations
- **Engine:** Godot (GDScript).  
- Modular nodes for player, enemy, cards, and turn manager.  
- Particle pooling and animation staggering for optimization.  
- Signals for communication between systems.  

---

## 10. Future Ideas

### 🎰 Wager System
- To balance risk/reward, ensure wager choice is meaningful.  
- Players might always choose the highest wager unless disincentivized.  

### 🎲 Dice & Card Customization
- Unlockable skins earned through gameplay.  
- New dice and deck skins obtained by defeating bosses or exploration secrets.  
- Some bosses may **steal dice** as a cheat mechanic.  
- Players may attempt to “cheat” if the opponent isn’t paying attention — timing-based system during idle animations.  

---

*© 2025 Nameless Prototype — Game Design Document (Updated)*
