
extends CharacterBody2D

const velocidad = 100.0
const fuerza_impulso = 300.0
const duracion_impulso = 0.15

@onready var player = $".."
@onready var animacion = $AnimatedSprite2D

var direccion_mirada: Vector2 = Vector2.DOWN
var impulsando: bool = false
var tiempo_impulso: float = 0.0
var direccion_impulso: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	# Detectar la tecla del impulso
	if Input.is_action_just_pressed("impulso") and not impulsando:
		_iniciar_impulso()

	# Ejecutar el impulso
	if impulsando:
		tiempo_impulso -= delta
		player.position += direccion_impulso * fuerza_impulso * delta

		if tiempo_impulso <= 0.0:
			impulsando = false
			_reproducir_animacion_quieto()

		return

	# Movimiento normal
	if Input.is_action_pressed("izquierda"):
		player.position.x -= delta * velocidad
		direccion_mirada = Vector2.LEFT
		animacion.play("izquierda")

	elif Input.is_action_pressed("derecha"):
		player.position.x += delta * velocidad
		direccion_mirada = Vector2.RIGHT
		animacion.play("derecha")

	elif Input.is_action_pressed("arriba"):
		player.position.y -= delta * velocidad
		direccion_mirada = Vector2.UP
		animacion.play("arriba")

	elif Input.is_action_pressed("abajo"):
		player.position.y += delta * velocidad
		direccion_mirada = Vector2.DOWN
		animacion.play("abajo")

	else:
		# Si no se presiona ninguna dirección,
		# mantener la animación de quieto correspondiente.
		_reproducir_animacion_quieto()

	move_and_slide()


func _reproducir_animacion_quieto() -> void:
	if direccion_mirada == Vector2.LEFT:
		animacion.play("quieto_izquierda")

	elif direccion_mirada == Vector2.RIGHT:
		animacion.play("quieto_derecha")

	elif direccion_mirada == Vector2.UP:
		animacion.play("quieto_espalda")

	else:
		animacion.play("quieto_frente")


func _iniciar_impulso() -> void:
	# Priorizar la dirección que se está presionando.
	var direccion := Vector2.ZERO

	if Input.is_action_pressed("izquierda"):
		direccion = Vector2.LEFT
	elif Input.is_action_pressed("derecha"):
		direccion = Vector2.RIGHT
	elif Input.is_action_pressed("arriba"):
		direccion = Vector2.UP
	elif Input.is_action_pressed("abajo"):
		direccion = Vector2.DOWN
	else:
		direccion = direccion_mirada

	direccion_impulso = direccion.normalized()
	tiempo_impulso = duracion_impulso
	impulsando = true
