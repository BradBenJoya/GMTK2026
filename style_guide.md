# IF I MISSED ANYTHING OR IF ANYTHING COMES UP WHILE WE ARE DEVELOPING DON'T HESITATE TO TELL ME

@Coder
# Naming conventions

@everybody some of the things here might apply to you

### Functions and variables

All functions and variables must be snake_case. This is considered the standard for GDScript so we will be following it. The only exception are signals where their name will start with an underscore. class_name will be in PascalCase

```python
class_name PlayerBase

var cool_variable: int = 5

func cool_function(cool_variable: int) -> void:
	pass
	
signal _cool_signal
```

All functions and variables should also be strongly typed as to increase clarity.

Avoid using `const` for variables and prefer to use `@export` instead (more on that later).

### Files

Files have the same naming conventions with the only difference being that they begin the owners name.

```python
player_movement.gd
enemy_pathfinding.gd
player_walking.mp3
etc
```

### Nodes

Nodes will also use PascalCase

```python
PlayerBase
PlayerMovement
PlayerCamera
```

# Code structure

### Base classes

Every scene that isn't purely visual (for example a level) will have a base node (for example a Character2D) that will have a script that's called "base" and the name of the scene.
```python
player_base.gd
enemy_base.gd
```

The script will look something like this:

```python
extends CharacterBody2D
class_name Player

@export_group("References")
@export var player_movement: PlayerMovement
@export var player_camera: PlayerCamera
@export var player_camera_node: Camera2D

@export_group("Settings")
@export_subgroup("Movement")
@export var move_speed: float = 5.0
@export var jump_force: float = 10.0

@export_subgroup("Abilities")
@export var ability_cooldown: float = 1.5

enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

var current_direction: Direction = Direction.UP


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	player_movement.handle_movement(delta)
	player_camera.handle_camera(delta)


func get_player_direction() -> Vector2:
	match current_direction:
		Direction.LEFT:
			return Vector2.LEFT
		Direction.RIGHT:
			return Vector2.RIGHT
		Direction.UP:
			return Vector2.UP
		Direction.DOWN:
			return Vector2.DOWN
		_:
			return Vector2.ZERO
```

There are quite a bit of things to unpack here so let's go step by step. First of all the `class_name`, this keyword should appear in every script that's possible, it provides better clarity in the sense that it's much easier to tell what a node/script is supposed to do. Secondly, it provides IntelliSense for the node so that there are no guessing games when trying to access a signal or function.

There are also quite a bit of `exports` so let's go over them as well.

The first one is labeled "References". Although quite self explanatory to what it should represent, one thing to note is the naming of them. Let's take `player_camera` and `player_camera_node`. Both have similar names but are different types and serve different roles. In short anything that ends in `node` is a physical object/node that doesn't contain a script. Where a reference that doesn't end with a "node" does contain a script (note that ones that are nodes with scripts have their `class_name`)

### Regular scripts

Here is the default script Godot creates for the Character2D node, however altered to how it should look:
```python
extends Node
class_name PlayerMovement

@export_group("References")
@export var player: Player


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.velocity.y = player.jump_force

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		player.velocity.x = direction * player.move_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.move_speed)

	player.move_and_slide()
```

The first thing that should be noticeable is that the script extends `Node`. Because Godot doesn't allow multiple scripts on one node, it is best when possible to split your scripts into Nodes and just refer to the player when you need a certain function or variable, like for example `velocity` and `move_and_slide()`.

### Signals

Signals should always be declared with typed parameters, same as functions. This keeps things clear when you're connecting to them later and lets Godot catch mistakes for you instead of finding out at runtime.

```python
signal _health_changed(new_health: int, max_health: int)
signal _died
```

When it comes to connecting signals, always do it through code in `_ready()`, never through the editor. Editor connections are invisible when reading the script and it's very easy for someone to rename a function and break a connection without realizing it since nothing shows up as an error until you actually run the game.

```python
func _ready() -> void:
	player.health_changed.connect(_on_health_changed)
```

### Lifecycle functions

`_ready()` and `_init()` should always be placed at the top of the script, right after your exports and variables and before any other functions. This is where all your setup logic goes, connecting signals, grabbing references, initializing state, etc. Keeping this consistent means anyone opening a script knows exactly where to look for "what happens when this loads in."

### Comments and documentation

Any exported variable or function that isn't immediately obvious what it does should have a `##` doc comment above it. Godot pulls these into the built in documentation panel so it also doubles as in editor documentation for the whole team.

```python
## The amount of time in seconds before the player can use their ability again.
@export var ability_cooldown: float = 1.5
```

# Project structure

The project is split into 3 main folders, `scripts`, `scenes`, and `assets`. `assets` contains external files like sprite sheets and music, `scripts` contains all scripts, and `scenes` contains all scenes.

Within each of these, files are organized by feature, meaning the player will have its own folder inside `scripts`, its own folder inside `scenes`, and its own folder inside `assets`.

```python
res://scripts/player/player_base.gd
res://scripts/player/player_movement.gd

res://scenes/player/player_base.tscn

res://assets/player/player_spritesheet.png
res://assets/player/player_walking.mp3
```

This keeps things consistent, everyone knows to check the `player` folder under whichever main folder they're working in, and it makes it easy to find or move everything related to one feature without it being scattered across the whole project.
