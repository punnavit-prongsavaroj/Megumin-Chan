extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO
signal hit
var attack = true
var coldown = true
# And this function at the bottom.
func die():
	hit.emit()
	position = Vector3(0,0,0)
	
func _physics_process(delta):
	var input_dir = Vector3.ZERO

	# ตรวจ input
	if Input.is_action_pressed("right"):
		input_dir.x -= 1
		$Megumin.rotation = Vector3(0, deg_to_rad(90), 0)

	if Input.is_action_pressed("left"):
		input_dir.x += 1
		$Megumin.rotation = Vector3(0, deg_to_rad(-90), 0)

	if Input.is_action_pressed("back"):
		input_dir.z -= 1
		$Megumin.rotation = Vector3(0, deg_to_rad(180), 0)

	if Input.is_action_pressed("forward"):
		input_dir.z += 1
		$Megumin.rotation = Vector3(0, deg_to_rad(0), 0)

	if Input.is_action_pressed("Attack"):
		if coldown == true :
			print("player attack")
			$Megumin/AnimationPlayer3.stop()
			$Megumin/AnimationPlayer3.play("mixamo_com")
			attack = false
			await get_tree().create_timer(1).timeout
			$Megumin/AnimationPlayer3.stop()
			attack = true
			coldown = false
	var direction = (transform.basis * input_dir).normalized()	
	var is_moving = direction != Vector3.ZERO

	# --- Animation ---
	if is_moving:
		# เล่นแอนิเมชันวิ่ง
		if not $Megumin/AnimationPlayer4.is_playing():
			$Megumin.rotation = (Vector3(0,0,0))
			$Megumin/AnimationPlayer4.play("mixamo_com")
		# หยุด idle ถ้ายังเล่นอยู่
		if $Megumin/AnimationPlayer2.is_playing():
			$Megumin/AnimationPlayer2.stop()
	else:
		# หยุดวิ่งแล้วเล่น idle
		if $Megumin/AnimationPlayer4.is_playing():
			$Megumin/AnimationPlayer4.stop()
		if not $Megumin/AnimationPlayer2.is_playing():
			pass
	# --- การเคลื่อนไหว ---


	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# แรงโน้มถ่วง
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
	else:
		target_velocity.y = 0

	velocity = target_velocity
	move_and_slide()
	
		
func _on_mob_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("mob"):
		if attack:
			print("mod attack")
			die()
			pass
		else:
			body.squash()
func _on_player_hit():
	$"../../ModTimer".stop()



func colddown_on_coldown_timeout() -> void:
	print("coldown finnish")
	coldown = true
	pass # Replace with function body.
	pass # Replace with function body.
