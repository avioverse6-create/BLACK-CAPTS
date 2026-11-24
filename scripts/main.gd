extends Node3D

const PlayerScript = preload("res://scripts/player.gd")
const NPCScript = preload("res://scripts/npc.gd")
const JoystickScript = preload("res://scripts/mobile_joystick.gd")
const CollectibleScript = preload("res://scripts/collectible.gd")

var player_node
var dialogue_label: Label
var dialogue_timer: Timer
var token_label: Label
var token_count := 0

func _ready() -> void:
    _make_environment()
    _make_map()
    _make_player()
    _make_npcs()
    _make_collectibles()
    _make_hud()

func _make_environment() -> void:
    var world := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.68, 0.79, 0.88)
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.68, 0.76, 0.86)
    env.ambient_light_energy = 0.8
    world.environment = env
    add_child(world)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-52, -25, 0)
    sun.light_energy = 1.1
    sun.shadow_enabled = true
    add_child(sun)

    var snow := GPUParticles3D.new()
    snow.name = "Snowfall"
    snow.amount = 420
    snow.lifetime = 8.0
    snow.position = Vector3(0, 8, 0)
    snow.visibility_aabb = AABB(Vector3(-32, -8, -32), Vector3(64, 24, 64))
    var particle_mesh := SphereMesh.new()
    particle_mesh.radius = 0.035
    particle_mesh.height = 0.07
    var snow_material := StandardMaterial3D.new()
    snow_material.albedo_color = Color(0.96, 0.98, 1.0)
    particle_mesh.material = snow_material
    snow.draw_pass_1 = particle_mesh
    var process := ParticleProcessMaterial.new()
    process.direction = Vector3(0.12, -1.0, 0.04)
    process.initial_velocity_min = 0.7
    process.initial_velocity_max = 1.8
    process.gravity = Vector3(0, -0.15, 0)
    process.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
    process.emission_box_extents = Vector3(30, 8, 30)
    snow.process_material = process
    add_child(snow)

func _make_map() -> void:
    _box("Snow ground", Vector3(0, -0.35, 0), Vector3(88, 0.6, 88), Color(0.83, 0.89, 0.94))

    # Main north-south avenue.
    _box("Main road", Vector3(0, 0.0, 0), Vector3(8, 0.08, 88), Color(0.25, 0.29, 0.34))
    for z in range(-40, 41, 5):
        _box("Main center line dash", Vector3(0, 0.055, z), Vector3(0.12, 0.02, 2.2), Color(0.88, 0.87, 0.76))
    _box("West sidewalk", Vector3(-5.0, 0.06, 0), Vector3(2.0, 0.18, 88), Color(0.54, 0.59, 0.64))
    _box("East sidewalk", Vector3(5.0, 0.06, 0), Vector3(2.0, 0.18, 88), Color(0.54, 0.59, 0.64))

    # A second street creates a real four-way junction and opens a new block.
    _box("South district road", Vector3(0, 0.0, 27), Vector3(64, 0.08, 7), Color(0.25, 0.29, 0.34))
    for x in range(-29, 30, 5):
        _box("District center line dash", Vector3(x, 0.055, 27), Vector3(2.2, 0.02, 0.12), Color(0.88, 0.87, 0.76))
    _box("District north sidewalk", Vector3(0, 0.06, 22.8), Vector3(64, 0.18, 1.4), Color(0.54, 0.59, 0.64))
    _box("District south sidewalk", Vector3(0, 0.06, 31.2), Vector3(64, 0.18, 1.4), Color(0.54, 0.59, 0.64))
    for x in range(-3, 4):
        _box("Main crosswalk stripe", Vector3(x * 0.9, 0.06, -2.0), Vector3(0.58, 0.025, 2.8), Color(0.91, 0.93, 0.94))
        _box("District crosswalk stripe", Vector3(x * 0.9, 0.06, 27.0), Vector3(0.58, 0.025, 2.5), Color(0.91, 0.93, 0.94))

    _building("Cabin", Vector3(-10, 0, -9), Vector3(9, 6, 8), Color(0.43, 0.34, 0.29))
    _building("Shop", Vector3(11, 0, -5), Vector3(10, 7, 9), Color(0.34, 0.42, 0.49))
    _building("House", Vector3(-11, 0, 12), Vector3(8, 5, 8), Color(0.48, 0.43, 0.37))
    _building("North apartment", Vector3(-15, 0, -35), Vector3(10, 9, 10), Color(0.39, 0.43, 0.48))
    _building("North garage", Vector3(15, 0, -35), Vector3(9, 5, 9), Color(0.42, 0.37, 0.32))
    _building("South house", Vector3(-15, 0, 38), Vector3(10, 6, 9), Color(0.47, 0.39, 0.32))
    _building("South workshop", Vector3(15, 0, 38), Vector3(11, 6, 9), Color(0.34, 0.40, 0.43))

    for x in [-25.0, -21.0, 21.0, 25.0]:
        for z in [-20.0, -7.0, 8.0, 17.0, 37.0]:
            _tree(Vector3(x, 0, z))

    for side in [-1.0, 1.0]:
        for z in [-40.0, -22.0, -8.0, 8.0, 18.0, 38.0]:
            _street_lamp(Vector3(side * 5.55, 0, z))
    for x in [-28.0, -14.0, 14.0, 28.0]:
        _street_lamp(Vector3(x, 0, 32.2))
    _bus_stop()

func _box(label: String, at: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
    var body := StaticBody3D.new()
    body.name = label + " Collider"
    body.position = at
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = size
    collision.shape = shape
    body.add_child(collision)
    add_child(body)

    var node := MeshInstance3D.new()
    node.name = label
    var mesh := BoxMesh.new()
    mesh.size = size
    node.mesh = mesh
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.roughness = 1.0
    node.material_override = mat
    body.add_child(node)
    return node

func _building(label: String, at: Vector3, size: Vector3, color: Color) -> void:
    _box(label, at + Vector3(0, size.y * 0.5, 0), size, color)
    _box(label + " snow roof", at + Vector3(0, size.y + 0.18, 0), Vector3(size.x + 0.5, 0.35, size.z + 0.5), Color(0.93, 0.97, 1.0))
    var window_mat := StandardMaterial3D.new()
    window_mat.albedo_color = Color(0.12, 0.20, 0.27)
    window_mat.roughness = 0.7
    for side in [-1.0, 1.0]:
        for row in range(2):
            for col in range(2):
                var window := MeshInstance3D.new()
                var pane := BoxMesh.new()
                pane.size = Vector3(1.25, 1.05, 0.08)
                window.mesh = pane
                window.material_override = window_mat
                window.rotation.y = PI * 0.5
                window.position = at + Vector3(side * (size.x * 0.5 + 0.045), 1.8 + row * 2.0, -1.8 + col * 3.5)
                add_child(window)

func _street_lamp(at: Vector3) -> void:
    var pole := MeshInstance3D.new()
    var pole_mesh := CylinderMesh.new()
    pole_mesh.top_radius = 0.055
    pole_mesh.bottom_radius = 0.09
    pole_mesh.height = 5.0
    pole.mesh = pole_mesh
    pole.position = at + Vector3(0, 2.5, 0)
    var metal := StandardMaterial3D.new()
    metal.albedo_color = Color(0.16, 0.20, 0.24)
    pole.material_override = metal
    add_child(pole)

    var arm := MeshInstance3D.new()
    var arm_mesh := BoxMesh.new()
    arm_mesh.size = Vector3(0.85, 0.09, 0.10)
    arm.mesh = arm_mesh
    arm.position = at + Vector3(0.34, 4.85, 0)
    arm.material_override = metal
    add_child(arm)

    var lamp := MeshInstance3D.new()
    var lamp_mesh := BoxMesh.new()
    lamp_mesh.size = Vector3(0.34, 0.14, 0.32)
    lamp.mesh = lamp_mesh
    lamp.position = at + Vector3(0.72, 4.78, 0)
    var glow := StandardMaterial3D.new()
    glow.albedo_color = Color(1.0, 0.86, 0.58)
    glow.emission_enabled = true
    glow.emission = Color(1.0, 0.72, 0.35)
    glow.emission_energy_multiplier = 0.7
    lamp.material_override = glow
    add_child(lamp)

func _bus_stop() -> void:
    var base := Vector3(7.1, 0, -13.0)
    _box("Bus stop platform", base + Vector3(0, 0.08, 0), Vector3(3.0, 0.16, 2.2), Color(0.49, 0.55, 0.60))
    _box("Bus stop back panel", base + Vector3(0, 1.35, -0.92), Vector3(2.8, 2.5, 0.10), Color(0.24, 0.34, 0.40))
    _box("Bus stop roof", base + Vector3(0, 2.65, 0), Vector3(3.1, 0.18, 2.3), Color(0.18, 0.24, 0.29))
    for x in [-1.3, 1.3]:
        _box("Bus stop support", base + Vector3(x, 1.25, 0), Vector3(0.10, 2.5, 0.10), Color(0.16, 0.20, 0.24))
    _box("Bus stop bench seat", base + Vector3(0, 0.62, -0.48), Vector3(2.1, 0.12, 0.42), Color(0.34, 0.25, 0.19))

func _tree(at: Vector3) -> void:
    _box("Tree trunk", at + Vector3(0, 1.1, 0), Vector3(0.45, 2.2, 0.45), Color(0.27, 0.20, 0.16))
    var crown := _box("Snowy pine", at + Vector3(0, 3.0, 0), Vector3(2.1, 2.5, 2.1), Color(0.72, 0.83, 0.85))
    crown.rotation_degrees.y = 45

func _make_collectibles() -> void:
    var positions := [
        Vector3(-7.0, 1.0, -16.0),
        Vector3(8.0, 1.0, -19.0),
        Vector3(-14.0, 1.0, 3.0),
        Vector3(14.0, 1.0, 8.0),
        Vector3(0.0, 1.0, 25.0),
        Vector3(-20.0, 1.0, -34.0),
        Vector3(22.0, 1.0, 38.0)
    ]
    for i in range(positions.size()):
        var token := Area3D.new()
        token.name = "TownToken_%d" % (i + 1)
        token.set_script(CollectibleScript)
        token.position = positions[i]
        token.collected.connect(_on_token_collected)
        add_child(token)

func _on_token_collected() -> void:
    token_count += 1
    if token_label:
        token_label.text = "ЖЕТОНЫ  %d / 7" % token_count

func _make_player() -> void:
    player_node = CharacterBody3D.new()
    player_node.name = "Player"
    player_node.set_script(PlayerScript)
    player_node.position = Vector3(0, 1.1, 8)
    add_child(player_node)
    player_node.interaction_message.connect(_show_dialogue)

func _make_npcs() -> void:
    var positions := [Vector3(-5, 1, -4), Vector3(6, 1, 3), Vector3(12, 1, 14), Vector3(-12, 1, -31), Vector3(18, 1, 35)]
    for i in range(positions.size()):
        var npc := CharacterBody3D.new()
        npc.name = "TownNPC_%d" % (i + 1)
        npc.set_script(NPCScript)
        npc.position = positions[i]
        add_child(npc)

func _make_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)

    var title := Label.new()
    title.text = "BLACK-CAPTS  •  WINTER TEST"
    title.position = Vector2(22, 18)
    title.add_theme_font_size_override("font_size", 18)
    title.add_theme_color_override("font_color", Color(0.08, 0.13, 0.19))
    layer.add_child(title)

    token_label = Label.new()
    token_label.text = "ЖЕТОНЫ  0 / 7"
    token_label.position = Vector2(22, 48)
    token_label.add_theme_font_size_override("font_size", 15)
    token_label.add_theme_color_override("font_color", Color(0.08, 0.13, 0.19, 0.92))
    layer.add_child(token_label)

    var camera_hint := Label.new()
    camera_hint.text = "СВАЙП СПРАВА — КАМЕРА"
    camera_hint.anchor_left = 1.0
    camera_hint.anchor_right = 1.0
    camera_hint.offset_left = -300
    camera_hint.offset_right = -22
    camera_hint.offset_top = 20
    camera_hint.add_theme_font_size_override("font_size", 14)
    camera_hint.add_theme_color_override("font_color", Color(0.12, 0.18, 0.24, 0.85))
    camera_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    layer.add_child(camera_hint)

    var joystick := Control.new()
    joystick.name = "MobileJoystick"
    joystick.set_script(JoystickScript)
    joystick.anchor_left = 0.0
    joystick.anchor_top = 1.0
    joystick.anchor_right = 0.0
    joystick.anchor_bottom = 1.0
    joystick.offset_left = 24
    joystick.offset_top = -194
    joystick.offset_right = 194
    joystick.offset_bottom = -24
    layer.add_child(joystick)

    dialogue_label = Label.new()
    dialogue_label.anchor_left = 0.5
    dialogue_label.anchor_right = 0.5
    dialogue_label.offset_left = -300
    dialogue_label.offset_right = 300
    dialogue_label.offset_top = 70
    dialogue_label.offset_bottom = 132
    dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    dialogue_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    dialogue_label.add_theme_font_size_override("font_size", 18)
    dialogue_label.add_theme_color_override("font_color", Color(0.08, 0.13, 0.19))
    dialogue_label.visible = false
    layer.add_child(dialogue_label)

    dialogue_timer = Timer.new()
    dialogue_timer.name = "DialogueAutoHide"
    dialogue_timer.one_shot = true
    dialogue_timer.wait_time = 5.0
    dialogue_timer.timeout.connect(_hide_dialogue)
    add_child(dialogue_timer)

    var interact_button := Button.new()
    interact_button.text = "ПОГОВОРИТЬ"
    interact_button.anchor_left = 1.0
    interact_button.anchor_top = 1.0
    interact_button.anchor_right = 1.0
    interact_button.anchor_bottom = 1.0
    interact_button.offset_left = -230
    interact_button.offset_top = -92
    interact_button.offset_right = -24
    interact_button.offset_bottom = -28
    interact_button.add_theme_font_size_override("font_size", 17)
    interact_button.add_theme_color_override("font_color", Color(0.96, 0.98, 1.0))
    interact_button.add_theme_color_override("font_hover_color", Color.WHITE)
    var button_style := StyleBoxFlat.new()
    button_style.bg_color = Color(0.10, 0.23, 0.34, 0.92)
    button_style.corner_radius_top_left = 16
    button_style.corner_radius_top_right = 16
    button_style.corner_radius_bottom_left = 16
    button_style.corner_radius_bottom_right = 16
    button_style.border_width_left = 1
    button_style.border_width_right = 1
    button_style.border_width_top = 1
    button_style.border_width_bottom = 1
    button_style.border_color = Color(0.65, 0.78, 0.88, 0.42)
    interact_button.add_theme_stylebox_override("normal", button_style)
    interact_button.pressed.connect(Callable(player_node, "interact"))
    layer.add_child(interact_button)

    var move_label := Label.new()
    move_label.text = "ДВИЖЕНИЕ"
    move_label.position = Vector2(56, 18)
    move_label.anchor_top = 1.0
    move_label.anchor_bottom = 1.0
    move_label.offset_top = -34
    move_label.offset_bottom = -12
    move_label.add_theme_font_size_override("font_size", 11)
    move_label.add_theme_color_override("font_color", Color(0.22, 0.29, 0.36, 0.72))
    layer.add_child(move_label)

func _show_dialogue(message: String) -> void:
    if dialogue_label:
        dialogue_label.text = message
        dialogue_label.visible = true
        if dialogue_timer:
            dialogue_timer.start()

func _hide_dialogue() -> void:
    if dialogue_label:
        dialogue_label.visible = false
