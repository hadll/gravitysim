extends Node2D

var instances = []

var latest_collisions = {}

@export var solver_max_iterations = 16

func RegisterMass(mass):
	instances.append(mass)
	latest_collisions[mass] = null

func _ready() -> void:
	process_priority = 1

func ElasticCollision(object_one, object_two):
	return object_one.velocity - 2*object_two.mass/(object_one.mass + object_two.mass) * (object_one.velocity - object_two.velocity).dot(object_one.position - object_two.position) / object_one.position.distance_squared_to(object_two.position) * (object_one.position - object_two.position)

func MassRatio(object_one, object_two):
	return object_two.mass/(object_one.mass + object_two.mass)

func _process(delta: float) -> void:
	for instance in instances:
		instance.position += instance.velocity
		latest_collisions[instance] = null
	var any_touchers = true
	var iterations = 0
	while any_touchers and iterations < solver_max_iterations:
		iterations += 1
		any_touchers = false
		for instance in instances:
			if instance.frozen:
				continue
			for other_instance in instances:
				if other_instance == instance:
					continue
				if other_instance.position.distance_to(instance.position) < other_instance.radius + instance.radius:
					var push_vector = (other_instance.position - instance.position).normalized() * ((other_instance.radius + instance.radius) - (other_instance.position.distance_to(instance.position)))
					any_touchers = true
					if other_instance.frozen == false:
						other_instance.position += push_vector * MassRatio(instance, other_instance)
						instance.position -= push_vector * MassRatio(other_instance, instance)
						var new_other_instance_velocity = ElasticCollision(other_instance, instance)
						instance.velocity = ElasticCollision(instance, other_instance)
						other_instance.velocity = new_other_instance_velocity
					else:
						instance.position -= push_vector *1.01
						instance.velocity *= -1
					latest_collisions[instance] = instance.position.move_toward(other_instance.position, instance.radius)
	queue_redraw()

func _draw():
	for instance in instances:
		if latest_collisions[instance] == null:
			continue
		draw_circle(latest_collisions[instance], 5, Color.RED)
	#shush
