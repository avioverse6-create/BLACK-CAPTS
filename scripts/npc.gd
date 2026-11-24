extends CharacterBody3D

var home := Vector3.ZERO
var timer := 0.0
var target := Vector3.ZERO
var display_name := "Житель"
var animation_player: AnimationPlayer
var current_visual_animation := ""
var dialogue_index := 0

const WALK_SPEED := 1.15
const GRAVITY := 18.0
const MODEL_PATH := "res://assets/characters/casual-walker.glb"
const DIALOGUES := [
    "Зимой дороги совсем скользкие. Будь осторожнее.",
    "Говорят, возле магазина скоро откроют новую работу.",
    "Привет! Хороший сегодня день для прогулки.",
    "Я тут живу неподалёку. Рад новым лицам."
]

func _ready() -> void:
    add_to_group("town_npcs")
    home = global_position
    target = home
    display_name = "Житель %s" % str(name).get_slice("_", 1)
    _make_collision()
    _load_character_model()
    _make_name_tag()

func _make_collision() -> void:
    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.32
    shape.height = 1.75
    collision.shape = shape
    collision.position.y = 0.875
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
    capsule.radius = 0.32
    capsule.height = 1.75
    var body := MeshInstance3D.new()
    body.mesh = capsule
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.52, 0.31, 0.24)
    body.material_override = mat
    body.position.y = 0.875
    add_child(body)

    var head := MeshInstance3D.new()
    var head_mesh := SphereMesh.new()
    head_mesh.radius = 0.22
    head_mesh.height = 0.44
    head.mesh = head_mesh
    var head_mat := StandardMaterial3D.new()
    head_mat.albedo_color = Color(0.73, 0.55, 0.42)
    head.material_override = head_mat
    head.position.y = 1.82
    add_child(head)

func _make_name_tag() -> void:
    var tag := Label3D.new()
    tag.text = display_name
    tag.position = Vector3(0, 2.35, 0)
    tag.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    tag.font_size = 30
    tag.pixel_size = 0.006
    tag.modulate = Color(0.92, 0.96, 1.0)
    tag.outline_size = 6
    tag.outline_modulate = Color(0.06, 0.09, 0.13, 0.88)
    add_child(tag)

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
        _play_visual_animation("walk")
    else:
        velocity.x = move_toward(velocity.x, 0.0, 4.0 * delta)
        velocity.z = move_toward(velocity.z, 0.0, 4.0 * delta)
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

func get_dialogue() -> String:
    var line: String = DIALOGUES[dialogue_index % DIALOGUES.size()]
    dialogue_index += 1
    return "%s: %s" % [display_name, line]
