extends Area3D


func _on_body_entered(_body):
	if (_body is RollingCube):
		_body.damage(1);
