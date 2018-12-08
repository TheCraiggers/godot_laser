extends Node2D

var total_length = 30000
var reflection_points = []
onready var space_state = get_world_2d().direct_space_state

func _ready():
	set_physics_process(true)
	set_process(true)

func _process(delta):
	var direction = Vector2(int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A)), int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W)))
	translate(direction * 200 * delta)

func _physics_process(delta):
	var remaining_length = total_length
	var ray_direction = (get_global_mouse_position() - global_position).normalized()
	var from = get_global_position()
	var to = from + ray_direction * remaining_length
	reflection_points = [Vector2(0,0)]
	var ray_result = space_state.intersect_ray(from, to)
	var num_intersections = 0
	while ray_result:
		reflection_points.append(ray_result['position'] - global_position)
		var distance = (ray_result['position'] - from).length()
		remaining_length -= distance
		var reflection_normal = ray_result['normal']
		ray_direction = ray_direction - 2 * (ray_direction.dot(reflection_normal)) * reflection_normal
		from = ray_result['position']
		to = from + ray_direction * remaining_length
		ray_result = space_state.intersect_ray(from, to)
		num_intersections += 1
		if num_intersections > 200 or remaining_length <= 0:
			break
	
	reflection_points.append(to)
	update()

func _draw():
	draw_polyline(reflection_points, Color(255,0,0))