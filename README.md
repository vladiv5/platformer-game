# 2D Platformer Game

## Description

This project is a 2D side-scrolling platformer developed as an introduction to game development using **Godot Engine 4** and **GDScript**.

Although it started as a tutorial-guided project, it served as a practical entry point into understanding Godot’s node-based architecture, 2D physics system, and basic game state management. The focus was on learning how gameplay logic, physics, animations, and interactions are structured inside a real game engine.

---

## Tech Stack

- **Engine:** Godot Engine 4.3  
- **Language:** GDScript  
- **Physics:** CharacterBody2D, Area2D  
- **Architecture:** Node-based scene system  

---

## Implemented Features

### Player Controller

A custom player controller was implemented using `CharacterBody2D`, handling movement and physics manually. Horizontal movement is based on input vectors, while gravity and jump forces are applied inside `_physics_process(delta)` to ensure frame-rate independent behavior. Player animations are dynamically switched between *Idle*, *Run*, and *Jump* states based on velocity and movement state.

### Interaction System

Collectible objects (coins) detect player interaction using `body_entered` signals. When collected, they notify a central game manager to update the score and trigger audio feedback. Hazard zones such as spikes or pits reset the level state when touched. A `Timer` node is used to introduce a short delay before reloading the scene, providing visual feedback on player death.

### Basic Enemy AI

Enemy behavior is implemented using `RayCast2D` nodes. Enemies patrol platforms automatically and reverse their movement direction when detecting walls or platform edges. Sprite orientation is updated accordingly to reflect the current movement direction.

### Game State Management

A global game manager script is used to track and manage the score across the game. It acts as a central hub that receives signals from collectibles and updates the user interface in real time.

---

## Project Structure

```text
platformer-game/
├── assets/             # Sprites, fonts, and audio files
├── scenes/             # Reusable scene files (Player, Enemy, Level)
├── scripts/            # GDScript logic files
│   ├── player.gd       # Player movement and physics logic
│   ├── coin.gd         # Collectible interaction logic
│   ├── killzone.gd     # Death and respawn logic
│   └── game_manager.gd # Global score management
└── project.godot       # Main project configuration
```

How to Run

Install Godot Engine.

Clone this repository.

Open Godot and import the project by selecting the project.godot file from the root directory.

Press F5 to start the game.

Credits

Assets: Pixel Adventure and Brackeys tutorial assets

Engine: Godot Engine
