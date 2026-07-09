extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if is_on_wall() and velocity.y >= 0:
			#si toca la pared y no esta en el piso entonces se quedara estatico
			velocity.y = 0.0
		else:
			#velocidad normal de caida libre
			velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("saltar"):
		if is_on_floor():
			#Salto normal desde el suelo
			velocity.y = JUMP_VELOCITY
		elif is_on_wall():
			# salto de pared
			velocity.y = JUMP_VELOCITY
			var wall_normal = get_wall_normal()
			velocity.x = wall_normal.x * SPEED * 1.5

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("mover_izquierda", "mover_derecha")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
