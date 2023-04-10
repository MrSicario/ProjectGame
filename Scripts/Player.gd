extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if is_on_floor():
		if not Input.is_anything_pressed():
			$Sprite.play("Idle")
		if Input.is_action_pressed("Right"):
			velocity.x = SPEED
			$Sprite.flip_h = false
			$Sprite.play("Run")
		elif Input.is_action_pressed("Left"):
			velocity.x = -SPEED
			$Sprite.flip_h = true
			$Sprite.play("Run")
		if Input.is_action_pressed("Left") and Input.is_action_pressed("Right"):
			velocity.x = 0
			$Sprite.play("Idle")
		else:
			velocity.x = lerp(velocity.x, 0.0, .5)
		if Input.is_action_just_pressed("Up"):
			velocity.y += JUMP_VELOCITY
			$Sprite.play("Jump")
	if not is_on_floor():
		velocity.y += delta * gravity
		if -20<=velocity.y and velocity.y<=0:
			$Sprite.play("Jump_peak")
		if velocity.y > 0:
			$Sprite.play("Fall")
		if Input.is_action_pressed("Right"):
			velocity.x = SPEED*.75
			$Sprite.flip_h = false
		elif Input.is_action_pressed("Left"):
			velocity.x = -SPEED*.75
			$Sprite.flip_h = true
		else:
			velocity.x = lerp(velocity.x, 0.0, .4)
		
	if Input.is_action_pressed("Attack1"):
		$Sprite.play("Attack")
	
	move_and_slide()
