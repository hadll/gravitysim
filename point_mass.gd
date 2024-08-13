extends Node2D
class_name PointMass

@export var frozen = false

@export var mass:float = 100000

@export var radius = 20

var gravitational_constant = 0.00000000006673

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MassRegistry.RegisterMass(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if frozen or not %TimeController.playing:
		return
	var pull_vector = Vector2.ZERO
	for other_instance in %MassRegistry.instances:
		if other_instance == self:
			continue
		var force = gravitational_constant * other_instance.mass * mass / position.distance_to(other_instance.position)
		pull_vector += (other_instance.position - position).normalized() * force
	velocity += pull_vector
	velocity *= 1
	$DebugVelocityVisual.points = [
		Vector2.ZERO,
		velocity * 100
	]
