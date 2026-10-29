extends CharacterBody2D


const velocidad = 100
@onready var player = $".."
@onready var animacion = $AnimatedSprite2D


func _physics_process(_delta):
	if Input.is_action_pressed("izquierda"):
		player.position.x -= _delta * velocidad
		animacion.play("izquierda")
	elif Input.is_action_pressed("derecha"):
		player.position.x += _delta * velocidad
		animacion.play("derecha")
	elif Input.is_action_pressed("arriba"):
		player.position.y -= _delta * velocidad
		animacion.play("arriba")
	elif Input.is_action_pressed("abajo"):
		player.position.y += _delta * velocidad
		animacion.play("abajo")
	else:
		animacion.stop()
		animacion.play("quieto_frente")
		pass
		#hola soy bruno
		
	move_and_slide()
