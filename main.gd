extends Node

@export var mob_scene: PackedScene = preload("res://Enimy.tscn")
@export var mouse_sensitivity: float = 0.002

@onready var camera = $Pivot/Meguminn/Camera3D # กล้องที่ติดกับ Player

var rotation_y: float = 0.0  # หมุนซ้ายขวา (yaw)
var rotation_x: float = 0.0  # หมุนขึ้นลง (pitch)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-90), deg_to_rad(90)) # ล็อกไม่ให้ก้มเงยเกิน
		$Pivot/Meguminn.rotation.y = rotation_y            # หมุนตัวละครซ้าย-ขวา
		camera.rotation.x = rotation_x     # หมุนกล้องขึ้น-ลง

func _ready() -> void:
	print("ready")
	$ModTimer.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_mod_timer_timeout():
	# Create a new instance of the Mob scene.
	print("mod spawn")
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Pivot/Meguminn.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	$ModTimer.start()

func _on_player_hit():
	$MobTimer.stop()
