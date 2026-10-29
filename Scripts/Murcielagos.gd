
extends CharacterBody2D

enum Estado {
	PATRULLANDO,
	PERSIGUIENDO,
	ATACANDO,
	RETROCEDIENDO,
	RECUPERANDO
}

@export_group("Zona de patrullaje")
@export var ancho_zona: float = 300.0
@export var alto_zona: float = 160.0
@export var velocidad_minima: float = 30.0
@export var velocidad_maxima: float = 65.0
@export var tiempo_cambio_rumbo: float = 1.2

@export_group("Persecucion")
@export var velocidad_persecucion: float = 100.0
@export var distancia_inicio_ataque: float = 85.0

@export_group("Ataque")
@export var velocidad_ataque: float = 300.0
@export var duracion_embestida: float = 0.20
@export var duracion_retroceso: float = 0.25
@export var tiempo_recuperacion: float = 0.45

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $"../DetectionArea"

var estado: Estado = Estado.PATRULLANDO
var jugador: Node2D = null

var centro_zona: Vector2
var objetivo: Vector2
var direccion_ataque: Vector2 = Vector2.ZERO

var tiempo_estado: float = 0.0
var tiempo_rumbo: float = 0.0


func _ready() -> void:
	randomize()

	centro_zona = global_position
	elegir_objetivo()

	detection_area.body_entered.connect(_al_detectar_cuerpo)
	detection_area.body_exited.connect(_al_salir_cuerpo)

	sprite.play("aletea")


func _physics_process(delta: float) -> void:
	match estado:
		Estado.PATRULLANDO:
			patrullar(delta)

		Estado.PERSIGUIENDO:
			perseguir()

		Estado.ATACANDO:
			tiempo_estado -= delta
			velocity = direccion_ataque * velocidad_ataque

			if tiempo_estado <= 0.0:
				estado = Estado.RETROCEDIENDO
				tiempo_estado = duracion_retroceso

		Estado.RETROCEDIENDO:
			tiempo_estado -= delta
			velocity = -direccion_ataque * velocidad_ataque

			if tiempo_estado <= 0.0:
				estado = Estado.RECUPERANDO
				tiempo_estado = tiempo_recuperacion

		Estado.RECUPERANDO:
			tiempo_estado -= delta
			velocity = Vector2.ZERO

			if tiempo_estado <= 0.0:
				if is_instance_valid(jugador):
					estado = Estado.PERSIGUIENDO
				else:
					estado = Estado.PATRULLANDO
					elegir_objetivo()

	move_and_slide()

	if abs(velocity.x) > 1.0:
		sprite.flip_h = velocity.x < 0.0


func patrullar(delta: float) -> void:
	tiempo_rumbo -= delta

	var mitad_ancho: float = ancho_zona / 2.0
	var mitad_alto: float = alto_zona / 2.0

	var fuera_de_zona: bool = (
		abs(global_position.x - centro_zona.x) > mitad_ancho
		or abs(global_position.y - centro_zona.y) > mitad_alto
	)

	if fuera_de_zona:
		objetivo = Vector2(
			clamp(
				global_position.x,
				centro_zona.x - mitad_ancho,
				centro_zona.x + mitad_ancho
			),
			clamp(
				global_position.y,
				centro_zona.y - mitad_alto,
				centro_zona.y + mitad_alto
			)
		)

		tiempo_rumbo = 0.0

	if tiempo_rumbo <= 0.0 \
	or global_position.distance_to(objetivo) < 12.0:
		elegir_objetivo()

	var direccion: Vector2 = global_position.direction_to(objetivo)
	var velocidad_actual: float = randf_range(
		velocidad_minima,
		velocidad_maxima
	)

	velocity = direccion * velocidad_actual


func elegir_objetivo() -> void:
	objetivo = Vector2(
		centro_zona.x + randf_range(
			-ancho_zona / 2.0,
			ancho_zona / 2.0
		),
		centro_zona.y + randf_range(
			-alto_zona / 2.0,
			alto_zona / 2.0
		)
	)

	tiempo_rumbo = randf_range(
		tiempo_cambio_rumbo * 0.5,
		tiempo_cambio_rumbo * 1.5
	)


func perseguir() -> void:
	if not is_instance_valid(jugador):
		jugador = null
		estado = Estado.PATRULLANDO
		elegir_objetivo()
		return

	var distancia: float = global_position.distance_to(
		jugador.global_position
	)

	# El ataque tiene prioridad sobre la persecucion.
	if distancia <= distancia_inicio_ataque:
		iniciar_ataque()
		return

	var direccion: Vector2 = global_position.direction_to(
		jugador.global_position
	)

	velocity = direccion * velocidad_persecucion


func iniciar_ataque() -> void:
	if not is_instance_valid(jugador):
		return

	direccion_ataque = global_position.direction_to(
		jugador.global_position
	)

	if direccion_ataque == Vector2.ZERO:
		direccion_ataque = Vector2.RIGHT

	estado = Estado.ATACANDO
	tiempo_estado = duracion_embestida
	velocity = direccion_ataque * velocidad_ataque


func _al_detectar_cuerpo(cuerpo: Node2D) -> void:
	if cuerpo.is_in_group("player"):
		jugador = cuerpo
		estado = Estado.PERSIGUIENDO
		tiempo_rumbo = 0.0


func _al_salir_cuerpo(cuerpo: Node2D) -> void:
	if cuerpo == jugador:
		jugador = null

		if estado == Estado.PERSIGUIENDO:
			estado = Estado.PATRULLANDO
			elegir_objetivo()
