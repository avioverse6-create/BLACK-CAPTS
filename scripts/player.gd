extends CharacterBody3D

const SPEED := 5.0
const ACCELERATION := 14.0
const GRAVITY := 18.0
const LOOK_SENSITIVITY := 0.0045
const PITCH_MIN := deg_to_rad(-48.0)
const PITCH_MAX := deg_to_rad(22.0)

var camera_pivot: Node3D
var camera_pitch := deg_to_rad(-13.0)
var look_finger := -1

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
    camera.rotation.x = camera_pitch
    camera.current = true
    camera_pivot.add_child(camera)

func _input(event: InputEvent) -> void:
    var screen_width := get_viewport().get_visible_rect().size.x

    if event is InputEventScreenTouch:
        if event.pressed and event.position.x > screen_width * 0.42 and look_finger == -1:
            look_finger = event.index
        elif not event.pressed and event.index == look_finger:
            look_finger = -1

    elif event is InputEventScreenDrag and event.index == look_finger:
        camera_pivot.rotation.y -= event.relative.x * LOOK_SENSITIVITY
        camera_pitch = clamp(
            camera_pitch - event.relative.y * LOOK_SENSITIVITY,
            PITCH_MIN,
            PITCH_MAX
        )
        var camera := camera_pivot.get_child(0) as Camera3D
        camera.rotation.x = camera_pitch

func _physics_process(delta: float) -> void:
    var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var local_direction := Vector3(input_dir.x, 0, input_dir.y)
    var direction := local_direction.rotated(Vector3.UP, camera_pivot.rotation.y)

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
