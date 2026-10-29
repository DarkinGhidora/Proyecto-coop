extends CharacterBody2D


const velocidad = 150
@onready var player = $".."
@onready var animacion = $AnimatedSprite2D


func _physics_process(_delta):
	if Input.is_action_pressed("izquierda"):
		player.position.x -= _delta * velocidad
		animacion.play("izquierda")
	if Input.is_action_pressed("derecha"):
		player.position.x += _delta * velocidad
		animacion.play("derecha")
	if Input.is_action_pressed("arriba"):
		player.position.y -= _delta * velocidad
		animacion.play("arriba")
	if Input.is_action_pressed("abajo"):
		player.position.y += _delta * velocidad
		


	move_and_slide()
