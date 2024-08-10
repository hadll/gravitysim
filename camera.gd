extends Camera2D

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement_vector = Input.get_vector("camera_pan_left", "camera_pan_right", "camera_pan_up", "camera_pan_down")/2
	velocity += movement_vector
	velocity *= 0.9
	position += velocity

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var zoom_pos = get_local_mouse_position()
			zoom *= 1.05
			print(zoom_pos)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var zoom_pos = get_local_mouse_position()
			zoom *= 0.95
			print(zoom_pos)
