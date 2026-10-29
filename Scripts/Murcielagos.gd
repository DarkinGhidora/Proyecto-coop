extends CharacterBody2D


const vel = 50

func _ready() -> void:
	velocity.x = vel
	$AnimatedSprite2D.play("aletea")
	
	
func _physics_process(delta: float) -> void:
	velocity.x = vel
	
	move_and_slide()
