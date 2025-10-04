Game Design Document – Prototype: Nameless (Updated)
1. Overview
Title: (working title) Nameless
 Genre: Turn-based strategy / dice + card combat / exploration
 Platform: PC / Godot Engine prototype
 Perspective: Top-down or 3/4 isometric for exploration, first-person for combat
Core Concept:
 The player controls an Adventurer who has lost their name. To reclaim it, they must navigate the Feywild, combat fey bosses in dice-based card duels, solve riddles, and overcome environmental puzzles that lead to the next encounter.
Gameplay Loop:
Explore small nodes of the Feywild.
Encounter a fey boss.
Engage in dice + card turn-based combat.
Defeat the boss → receive a card reward and a riddle pointing to the next node.
Collect new cards and explore further.



2. Gameplay Mechanics
2.1 Combat (Updated)
Combat Loop & Phases
 Each round of combat is divided into distinct phases to allow simultaneous dice rolls, card play, and post-roll resolution:
Pre-Roll Card Phase (Simultaneous)


Player and enemy can play cards that affect dice outcomes.
Both sides act at the same time, effects are applied immediately or queued.


Dice Roll Phase (Simultaneous)


Player and enemy roll dice.
Dice physics and animations run independently; slight enemy delay can be added in the future for visual variety.
Dice values are reported once they finish rolling.


Post-Roll Card Phase (Simultaneous)


Both sides can play cards triggered by the roll.
All card effects (buffs, debuffs, modifiers) are resolved.


Resolution Phase


Dice totals are compared.
HP or points are applied/updated only after both sides have completed the post-roll card phase.
Round results displayed via UI and narrative flavor text.


Dice System
Each dice roll represents an attack or influence check.
Higher total roll wins the round.
Dice are affected by card effects pre- or post-roll.


Card System
Cards modify dice outcomes (double roll, swap dice, impose disadvantage).
Players and enemies have decks; cards are earned or found during exploration.
Card timing is linked to the combat phase (pre-roll or post-roll).


Enemy AI
Weighted rule-based AI with HP-based phases.
Makes decisions for cards and dice simultaneously with the player.
Uses telegraphed attacks for clarity.


Player Interaction
Players select cards to play during the pre-roll and post-roll phases.
Dice roll automatically after pre-roll card phase.



2.2 Exploration (Updated)
Nodes are small, distinct locations (starting with “Shimmering Glade”).
Each node contains:
Environmental clues for riddles and puzzles — players may need to solve visual, logic, or interactive puzzles to progress.
Collectible cards.
Visual markers for paths to the next node.
Minimal movement/exploration focus; nodes are visually engaging and interactive.
Puzzle elements provide additional challenge, narrative context, and rewards beyond combat.



3. Art Direction
3.1 Environment
Shimmering Glade Node: mossy ground, glowing flowers (blue/purple), twisted silver-barked trees, crystalline pond, floating light motes.
Subtle mist and interactive objects (glowing mushrooms, stones).


3.2 Boss / Character Design
Adventurer: slender build, undercut hairstyle, simple adventuring garb.
Lurielle: slender fey, silver sheen skin, flowing translucent hair with motes, gossamer gown.
Subtle magical orbiting flora to indicate interaction.


3.3 Visual Style
Semi-realistic painterly textures.
Emphasis on magical glow (bioluminescent plants, dice/card effects).
Influences: Ori and the Blind Forest, Studio Ghibli forests, Trine, Death's Door.



4. Audio
Ambient Feywild sounds: soft wind, chimes, rustling leaves.
Dice rolls: subtle clatter.
Card effects: light magical chimes, glow or shimmer cues.
Boss telegraphs: musical cues to indicate upcoming attacks.



5. MVP Features
Goal: Prototype the first node, combat system, and one boss fight.
5.1 Core Features
Player dice roll + card selection system.
Enemy AI with weighted dice/card decisions.
One boss fight (Lurielle) with phases and telegraphed attacks
Small exploration node (“Shimmering Glade”) with collectible cards and puzzles.
Riddle/puzzle hint for next encounter (text or visual).
Turn-based combat flow fully functional.


5.2 Optional MVP Additions
Basic animations for dice, cards, and boss abilities.
Simple particle effects for magical ambiance.



6. Roadmap to MVP (Updated)
Phase 1 – Core Mechanics: Dice roll system, basic player health, placeholder enemy with weighted AI.
 Phase 2 – Card System: Implement card classes and effects for player and boss.
 Phase 3 – Turn Manager / Phase System:
Combat divided into pre-roll card, dice roll, post-roll card, and resolution phases.
Track phase completion for both player and enemy
Phase 4 – First Boss Prototype: Lurielle with weighted AI, phases, and card interactions.
Phase 5 – Exploration Node: Shimmering Glade with collectible cards, puzzles, and pathing cues.
Phase 6 – Player Integration: Full input system; test combat loop with phased cards.
Phase 7 – Polish: Animations, particle effects, UI polish.
Phase 8 – MVP Test: Playtest single node + boss + combat system; evaluate balance, clarity, fun.


Optional Future Addition – Wager System:
Prototype post-phase: players and enemies wager points or resources to influence card draws and dice outcomes.


Timing: linked to pre-roll card phase.


Low/medium/high wagers affect number of cards drawn and potential gains/losses.


Currently conceptual; to be implemented after core card and phase system is stable.



7. Combat Update – Fey Gamble Mechanic (Future Concept)
Betting Phase: players and enemies wager points or resources at round start.


Card Draw: number of cards drawn depends on wager.


Dice Roll: simultaneous rolls, card effects modify outcomes.


Points Exchange: winner gains opponent’s wagered points.


Narrative Flavor: all outcomes described as Feywild story beats.


Strategic Implications: high wagers → more cards/faster progress; low wagers → safer but fewer options.



8. References & Influences
Visual / Atmosphere: Ori and the Blind Forest, Studio Ghibli, Darkest Dungeon.
 Gameplay / Mechanics: Tabletop dice/card games, XCOM, Slay the Spire.

9. Technical Considerations
Godot Engine (GDScript)


Modular nodes for player, enemy, cards, turn manager


Particle pooling and animation staggering for optimization


Signals for communication between turn manager, player, and enemy



10. Future Ideas
Wager Mechanic at the start of each round 
Potentially a lot of balancing issues
More thought needs to be done on how to make it so it is actually a choice for players and opponent to choose between the wager options 
Liklihood players always choose highest game is high if they get more cards to play 


Dice and Card customisation skins 
Unlockable by playing the game 
each boss defeat gives you an new dice and deck skin
Found during exploration of nodes (secrets?)
Some Bosses can steal dice? (could be one pf their cheat mechanics)
Players can attempt to cheat if the the opponent isn’t paying attention 
Add times in idle animation where the opponent looks away or closes their eyes to think or something? 



