extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if is_on_floor():
		if velocity.y == 0 and $Sprite.animation == "Fall":
			$Sprite.stop()
		if not $Sprite.is_playing():
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
		if Input.is_action_just_pressed("Attack1"):
			$Sprite.play("Attack")
		if Input.is_action_just_released("Right") or Input.is_action_just_released("Left"):
			$Sprite.stop()
	if not is_on_floor():
#		TODO Player slows if is attacking on a wall
		if is_on_wall() and Input.is_action_pressed("Attack2"):
			velocity.y = 0
			velocity.x = 0
			var collision = get_last_slide_collision()
			$Sprite.play("WallSlide")
			if collision.get_normal().x > 0:
				$Sprite.flip_h = false
			elif collision.get_normal().x < 0:
				$Sprite.flip_h = true
		else:
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
			if Input.is_action_just_pressed("Attack1"):
				$Sprite.play("Attack")
	
	move_and_slide()
