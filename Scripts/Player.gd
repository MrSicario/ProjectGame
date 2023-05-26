extends CharacterBody2D


const SPEED = 400.0
const ACCELERATION = .2
const JUMP_VELOCITY = -400.0
const TOP_ANI = ["Attack", "WallSlide"]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var clinging = false
var spear_cd = true
var balance_time = 0.25

func get_Fall_Speed(delta, clinging):
	if clinging and is_on_wall_only():
		var collision = get_last_slide_collision()
		velocity.y = 1
		velocity.x = 0
		if collision.get_normal().x > 0:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
		if $Sprite.animation != "Attack":
			$Sprite.play("WallSlide")
	else:
		velocity.y += gravity * delta
		clinging = false

func get_Input():
	var direction = 0
	if Input.is_action_pressed("Right"):
		direction += 1
	if Input.is_action_pressed("Left"):
		direction -= 1
	if direction != 0:
		velocity.x = lerp(velocity.x, SPEED*direction, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, ACCELERATION)

func play_Animation():
	if not $Sprite.is_playing():
		$Sprite.play("Idle")
	if not $Sprite.animation in TOP_ANI:
		if is_on_floor():
			if $Sprite.animation == "Fall":
				$Sprite.stop()
			if Input.is_action_pressed("Right"):
				$Sprite.flip_h = false
				if velocity.x > 0:
					$Sprite.play("Run")
			if Input.is_action_pressed("Left"):
				$Sprite.flip_h = true
				if velocity.x < 0:
					$Sprite.play("Run")
			if Input.is_action_just_released("Right") or Input.is_action_just_released("Left"):
				$Sprite.stop()
		if not is_on_floor():
			if velocity.y in range(-20, 20):
				$Sprite.play("JumpPeak")
			elif velocity.y > 0:
				$Sprite.play("Fall")
			elif velocity.y < 0:
				$Sprite.play("Jump")

func play_Attack():
	$Sprite.stop()
	$Sprite.play("Attack")

func poleJump():
	if (abs(velocity.x) > 350
	and $RayCast2D.is_colliding()
	and not is_on_floor()
	and spear_cd):
		velocity.y = JUMP_VELOCITY*1.5
		spear_cd = false
		
func _physics_process(delta):
	if is_on_floor():
		clinging = false
		spear_cd = true
	get_Input()
	get_Fall_Speed(delta, clinging)
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if clinging:
			$Sprite.stop()
			clinging = false
			velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("Attack1"):
		play_Attack()
		if is_on_wall_only():
			clinging = true
		poleJump()
	if Input.is_action_just_pressed("Attack2"):
		if !is_on_floor():
			gravity = 0
			await get_tree().create_timer(balance_time).timeout
			gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
			
	play_Animation()
	move_and_slide()
