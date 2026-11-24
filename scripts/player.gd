extends CharacterBody3D

const SPEED := 5.0
const ACCELERATION := 14.0
const GRAVITY := 18.0
var camera_pivot: Node3D

func _ready() -> void:
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.38
    capsule.height = 1.8
    var body := MeshInstance3D.new()
    body.mesh = capsule
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.18, 0.32, 0.48)
    body.material_override = mat
    body.position.y = 0.9
    add_child(body)

    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.38
    shape.height = 1.8
    collision.shape = shape
    collision.position.y = 0.9
    add_child(collision)

    camera_pivot = Node3D.new()
    camera_pivot.position = Vector3(0, 1.45, 0)
    add_child(camera_pivot)
    var camera := Camera3D.new()
    camera.position = Vector3(0, 2.4, 6.5)
    camera.rotation_degrees.x = -13
    camera.current = true
    camera_pivot.add_child(camera)

func _physics_process(delta: float) -> void:
    var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction := Vector3(input_dir.x, 0, input_dir.y)
    if direction.length() > 0.05:
        direction = direction.normalized()
        velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
        velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
        rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 9.0)
    else:
        velocity.x = move_toward(velocity.x, 0.0, ACCELERATION * delta)
        velocity.z = move_toward(velocity.z, 0.0, ACCELERATION * delta)

    if not is_on_floor():
        velocity.y -= GRAVITY * delta
    else:
        velocity.y = 0.0
    move_and_slide()
