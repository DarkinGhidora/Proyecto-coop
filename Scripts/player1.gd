
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
	# Detectar el impulso
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
	var moviendo := false

	if Input.is_action_pressed("izquierda"):
		player.position.x -= delta * velocidad
		direccion_mirada = Vector2.LEFT
		_reproducir_animacion("izquierda")
		moviendo = true

	elif Input.is_action_pressed("derecha"):
		player.position.x += delta * velocidad
		direccion_mirada = Vector2.RIGHT
		_reproducir_animacion("derecha")
		moviendo = true

	elif Input.is_action_pressed("arriba"):
		player.position.y -= delta * velocidad
		direccion_mirada = Vector2.UP
		_reproducir_animacion("arriba")
		moviendo = true

	elif Input.is_action_pressed("abajo"):
		player.position.y += delta * velocidad
		direccion_mirada = Vector2.DOWN
		_reproducir_animacion("abajo")
		moviendo = true

	# Si no se mueve, mantener el quieto según la última dirección
	if not moviendo:
		_reproducir_animacion_quieto()

	move_and_slide()


func _reproducir_animacion(nombre: String) -> void:
	# No reiniciar la animación si ya está reproduciéndose
	if animacion.animation != nombre:
		animacion.play(nombre)


func _reproducir_animacion_quieto() -> void:
	if direccion_mirada == Vector2.LEFT:
		_reproducir_animacion("quieto_izquierda")

	elif direccion_mirada == Vector2.RIGHT:
		_reproducir_animacion("quieto_derecha")

	elif direccion_mirada == Vector2.UP:
		_reproducir_animacion("quieto_detras")

	else:
		_reproducir_animacion("quieto_frente")


func _iniciar_impulso() -> void:
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
