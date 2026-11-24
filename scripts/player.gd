extends CharacterBody3D

signal interaction_message(message: String)

const SPEED := 5.0
const ACCELERATION := 14.0
const GRAVITY := 18.0
const LOOK_SENSITIVITY := 0.0045
const PITCH_MIN := deg_to_rad(-12.0)
const PITCH_MAX := deg_to_rad(48.0)
const MODEL_PATH := "res://assets/characters/casual-walker.glb"

var camera_pivot: Node3D
var camera_pitch := deg_to_rad(13.0)
var look_finger := -1
var animation_player: AnimationPlayer
var current_visual_animation := ""

func _ready() -> void:
    _make_collision()
    _load_character_model()
    _make_camera()

func _make_collision() -> void:
    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.36
    shape.height = 1.8
    collision.shape = shape
    collision.position.y = 0.9
    add_child(collision)

func _load_character_model() -> void:
    if ResourceLoader.exists(MODEL_PATH):
        var packed := load(MODEL_PATH) as PackedScene
        if packed:
            var model := packed.instantiate()
            var visual := Node3D.new()
            visual.name = "CharacterVisual"
            visual.rotation.y = PI
            visual.add_child(model)
            add_child(visual)
            var players := visual.find_children("*", "AnimationPlayer", true, false)
            if not players.is_empty():
                animation_player = players[0] as AnimationPlayer
            _play_visual_animation("idle")
            return

    var capsule := CapsuleMesh.new()
    capsule.radius = 0.36
    capsule.height = 1.8
    var body := MeshInstance3D.new()
    body.name = "TemporaryPlayerPlaceholder"
    body.mesh = capsule
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.18, 0.32, 0.48)
    body.material_override = mat
    body.position.y = 0.9
    add_child(body)

func _make_camera() -> void:
    camera_pivot = Node3D.new()
    camera_pivot.position = Vector3(0, 1.45, 0)
    add_child(camera_pivot)
    var spring := SpringArm3D.new()
    spring.spring_length = 6.5
    spring.margin = 0.25
    spring.rotation.y = PI
    spring.position = Vector3(0, 1.0, 0)
    camera_pivot.add_child(spring)
    var camera := Camera3D.new()
    camera.position = Vector3(0, 0.25, 0)
    camera.rotation = Vector3(camera_pitch, PI, 0)
    camera.current = true
    spring.add_child(camera)

func _unhandled_input(event: InputEvent) -> void:
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
        var spring := camera_pivot.get_child(0) as SpringArm3D
        var camera := spring.get_child(0) as Camera3D
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
        _play_visual_animation("walk")
    else:
        velocity.x = move_toward(velocity.x, 0.0, ACCELERATION * delta)
        velocity.z = move_toward(velocity.z, 0.0, ACCELERATION * delta)
        _play_visual_animation("idle")

    if not is_on_floor():
        velocity.y -= GRAVITY * delta
    else:
        velocity.y = 0.0
    move_and_slide()

func _play_visual_animation(wanted: String) -> void:
    if animation_player == null or current_visual_animation == wanted:
        return
    for animation_name in animation_player.get_animation_list():
        if animation_name.to_lower().contains(wanted):
            animation_player.play(animation_name)
            current_visual_animation = wanted
            return

func interact() -> void:
    var nearest: Node3D = null
    var nearest_distance := 3.2
    for npc in get_tree().get_nodes_in_group("town_npcs"):
        if not is_instance_valid(npc):
            continue
        var distance := global_position.distance_to(npc.global_position)
        if distance < nearest_distance:
            nearest = npc
            nearest_distance = distance
    if nearest and nearest.has_method("get_dialogue"):
        interaction_message.emit(str(nearest.call("get_dialogue")))
    else:
        interaction_message.emit("Подойдите ближе к жителю.")
