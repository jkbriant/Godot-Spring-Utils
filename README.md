# Godot-Spring-Utils
A utility for easily implementing damped spring based motion in the Godot engine.

## Example
```py
extends Node3D

var spring := DampedSpring.new() # Spring cache
var target_x: float = -1.0 # Initial position

func _process(delta: float) -> void:
	# Change the target position
	if Input.is_action_just_pressed("ui_right"):
		target_x -= 1.0
	if Input.is_action_just_pressed("ui_left"):
		target_x += 1.0

	# Nudge the spring
	if Input.is_action_just_pressed("ui_down"):
		spring.nudge(-1.0)

	# Update the spring state
	var angular_frequency = 8.0
	var damping_ratio = 0.5
	spring.step(delta, target_x, angular_frequency, damping_ratio)

	# Applying the normalized springs position and velocity to update the game state
	global_position.x = spring.position * 4.0
	global_rotation_degrees.y = spring.velocity * 10.0
	scale.y = (1.0 - absf(spring.velocity) * 0.1) 
```
