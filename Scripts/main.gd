extends Node

func _ready() -> void:
	# Capturar el mouse dentro de la ventana del juego
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Activar pantalla completa
	get_window().mode = Window.MODE_FULLSCREEN

	# Configurar el escalado de la vista
	var viewport := get_viewport()
	viewport.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	viewport.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE
