extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -530.0

# Implementacion del tiempo coyote para mejorar el tiempo de respuesta
const COYOTE_DURATION = 0.15 
var coyote_timer = 0.0
const WALL_COYOTE_DURATION = 0.15 #tolerancia para las paredes
var wall_coyote_timer = 0.0
var last_wall_normal = Vector2.ZERO # Guarda la direccion de la ultima pared tocada


func _physics_process(delta: float) -> void:
	
	# Control del temporizador Coyote
	if is_on_floor():
		coyote_timer = COYOTE_DURATION # Si toca el suelo, el colchón está lleno
	else:
		coyote_timer -= delta # Si está en el aire, el tiempo se empieza a agotar
		
	if is_on_wall():
		wall_coyote_timer = WALL_COYOTE_DURATION
		last_wall_normal = get_wall_normal()
	else:
		wall_coyote_timer -= delta
	
	# Add the gravity.
	if not is_on_floor():
		if is_on_wall() and velocity.y >= 0:
			#si toca la pared y no esta en el piso entonces se quedara estatico
			velocity.y = 0.0
		else:
			#velocidad normal de caida libre
			velocity += get_gravity() * delta
			
	
	if is_on_wall():
		var wall_normal = last_wall_normal
		var input_dir = Input.get_axis("mover_izquierda","mover_derecha")
		
		# Despegue sutil bajo
		if Input.is_action_just_pressed("bajar"):
			velocity.x = wall_normal.x * SPEED * 1.2
			wall_coyote_timer = 0.0 # tolerancia se consume inmediatamente
			
		# salto parabolico desde pared
		if (wall_normal.x > 0 and input_dir > 0) or (wall_normal.x < 0 and input_dir < 0):
			velocity.y = JUMP_VELOCITY
			velocity.x = wall_normal.x * SPEED
			wall_coyote_timer = 0.0 # la tolerancia se consume inmediatamente
			print("Salto parabolico con tolerancia")

	# Handle jump.
	if Input.is_action_just_pressed("saltar"):
		
		if coyote_timer > 0.0:
			velocity.y = JUMP_VELOCITY
			coyote_timer = 0.0 # consume el temporizador para evitar saltos dobles en el aire (se considerará en un futuro la implementacion de saltos dobles por lo que esto podria cambiar)
			print("Salto con coyote time")
			
		elif is_on_wall() or wall_coyote_timer > 0.0:
			# salto de pared con despegue sutil
			velocity.y = JUMP_VELOCITY
			var wall_normal = last_wall_normal
			velocity.x = wall_normal.x * SPEED * 1.2
			wall_coyote_timer = 0.0
			print("Salto sutil con tolerancia")


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("mover_izquierda", "mover_derecha")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
