extends Camera

func _input(event):
	if event is InputEventMouseMotion and\
	   Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.x += -event.relative.y
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
		rotation_degrees.y += -event.relative.x
	elif event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_Q:
				$Dither.visible = not $Dither.visible 
			elif event.scancode == KEY_E:
				$Outlines.visible = not $Outlines.visible 

func Vec3(num) -> Vector3:
	return Vector3(num, num, num)


func _process(delta):
	var input = Vec3(Input.get_axis("left", "right")) * Vector3.RIGHT +\
	  Vec3(Input.get_axis("up", "down")) * Vector3.FORWARD * -1
	transform = transform.translated(input * 5 * delta)
