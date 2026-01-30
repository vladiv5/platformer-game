extends CharacterBody2D

@onready var player = $"."

@export var walk_speed = 100.0
@export var run_speed = 150.0
@export var crouch_speed = 50.0
@export var down_speed = 1.8

@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1

@export var jump_force = -350.0
@export_range(0, 1) var decelerate_on_jump_release = 0.5

@export var dash_speed = 600.0
@export var dash_max_distance = 100.0
@export var dash_curve : Curve
@export var dash_cooldown = 2.0

var is_dashing_animation = false
@onready var teleport_cooldown = $"Teleport Cooldown"

@onready var animated_sprite= $Animation

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_crouching = false
var is_dashing = false
var dash_start_position = 0
var dash_direction = 0
var dash_timer = 0


func _physics_process(delta):
	# Add the gravity
	
	if not is_on_floor():
		if Input.is_action_pressed("down"):
			velocity.y += gravity * delta * down_speed
		else:
			velocity.y += gravity * delta
		
	var speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	elif Input.is_action_pressed("crouch"):
		speed = crouch_speed
	else:
		speed = walk_speed
		
	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Apply movement
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
		animated_sprite.flip_h = direction == -1
		
		if is_on_floor() and not is_dashing_animation:
			if Input.is_action_pressed("run"):
				animated_sprite.play("run")
			elif is_crouching:
				if animated_sprite.frame != 3:
					animated_sprite.play("crouch")
					speed = crouch_speed
			else:
				animated_sprite.play("walk")
		
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
		if is_on_floor():
			if is_crouching:
				if animated_sprite.frame != 3:
					animated_sprite.play("crouch")
			else:
				animated_sprite.play("idle")
	
	#Crouching
	if Input.is_action_just_pressed("crouch"):
		crouch()
		
	elif Input.is_action_just_released("crouch"):
		stand()
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		animated_sprite.play("jump")
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release
		
	
	# Dash
	if Input.is_action_just_pressed("teleport") and direction and not is_dashing and dash_timer <= 0:
		animated_sprite.play("teleport")
		teleport_cooldown.start()
		is_dashing_animation = true
		is_dashing = true
		dash_start_position = position.x
		dash_direction = direction
		dash_timer = dash_cooldown
		
	# Perform actual dash
	if is_dashing:
		var current_distance = abs(position.x - dash_start_position)
		if current_distance >= dash_max_distance or is_on_wall():
			is_dashing = false
		else:
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			velocity.y = 0
			
	
	# Reduces the dash timer
	if dash_timer > 0:
		dash_timer -= delta
	
	move_and_slide()


func crouch():
	if is_crouching:
		return
	is_crouching = true

func stand():
	if is_crouching == false:
		return 
	is_crouching = false


func _on_teleport_cooldown_timeout():
	is_dashing_animation = false
