extends CharacterBody3D

var home := Vector3.ZERO
var timer := 0.0
var target := Vector3.ZERO
const WALK_SPEED := 1.15

func _ready() -> void:
    home = global_position
    target = home
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.34
    capsule.height = 1.7
    var body := MeshInstance3D.new()
    body.mesh = capsule
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.52, 0.31, 0.24)
    body.material_override = mat
    body.position.y = 0.85
    add_child(body)

    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.34
    shape.height = 1.7
    collision.shape = shape
    collision.position.y = 0.85
    add_child(collision)

func _physics_process(delta: float) -> void:
    timer -= delta
    if timer <= 0.0:
        timer = randf_range(2.0, 5.0)
        target = home + Vector3(randf_range(-3.0, 3.0), 0, randf_range(-3.0, 3.0))

    var direction := target - global_position
    direction.y = 0
    if direction.length() > 0.35:
        direction = direction.normalized()
        velocity.x = direction.x * WALK_SPEED
        velocity.z = direction.z * WALK_SPEED
        rotation.y = atan2(-direction.x, -direction.z)
    else:
        velocity.x = move_toward(velocity.x, 0.0, 4.0 * delta)
        velocity.z = move_toward(velocity.z, 0.0, 4.0 * delta)

    if not is_on_floor():
        velocity.y -= 18.0 * delta
    else:
        velocity.y = 0.0
    move_and_slide()
