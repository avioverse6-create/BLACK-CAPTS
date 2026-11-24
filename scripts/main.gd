extends Node3D

const PlayerScript = preload("res://scripts/player.gd")
const NPCScript = preload("res://scripts/npc.gd")

func _ready() -> void:
    _make_environment()
    _make_map()
    _make_player()
    _make_npcs()
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
    _box("Snow ground", Vector3(0, -0.35, 0), Vector3(64, 0.6, 64), Color(0.83, 0.89, 0.94))
    _box("Main road", Vector3(0, 0.0, 0), Vector3(8, 0.08, 64), Color(0.25, 0.29, 0.34))
    _box("Road marking", Vector3(0, 0.055, 0), Vector3(0.12, 0.02, 64), Color(0.88, 0.87, 0.76))

    _building("Cabin", Vector3(-10, 0, -9), Vector3(9, 6, 8), Color(0.43, 0.34, 0.29))
    _building("Shop", Vector3(11, 0, -5), Vector3(10, 7, 9), Color(0.34, 0.42, 0.49))
    _building("House", Vector3(-11, 0, 12), Vector3(8, 5, 8), Color(0.48, 0.43, 0.37))

    for x in [-22.0, -17.0, 17.0, 22.0]:
        for z in [-20.0, -7.0, 8.0, 22.0]:
            _tree(Vector3(x, 0, z))

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

func _tree(at: Vector3) -> void:
    _box("Tree trunk", at + Vector3(0, 1.1, 0), Vector3(0.45, 2.2, 0.45), Color(0.27, 0.20, 0.16))
    var crown := _box("Snowy pine", at + Vector3(0, 3.0, 0), Vector3(2.1, 2.5, 2.1), Color(0.72, 0.83, 0.85))
    crown.rotation_degrees.y = 45

func _make_player() -> void:
    var player := CharacterBody3D.new()
    player.name = "Player"
    player.set_script(PlayerScript)
    player.position = Vector3(0, 1.1, 8)
    add_child(player)

func _make_npcs() -> void:
    var positions := [Vector3(-5, 1, -4), Vector3(6, 1, 3), Vector3(12, 1, 14)]
    for i in range(positions.size()):
        var npc := CharacterBody3D.new()
        npc.name = "TownNPC_%d" % (i + 1)
        npc.set_script(NPCScript)
        npc.position = positions[i]
        add_child(npc)

func _make_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var label := Label.new()
    label.text = "BLACK-CAPTS  •  WINTER TEST"
    label.position = Vector2(22, 18)
    label.add_theme_font_size_override("font_size", 18)
    label.add_theme_color_override("font_color", Color(0.08, 0.13, 0.19))
    layer.add_child(label)

    _add_move_button(layer, "▲", "ui_up", Vector2(112, -154))
    _add_move_button(layer, "▼", "ui_down", Vector2(112, -54))
    _add_move_button(layer, "◀", "ui_left", Vector2(12, -104))
    _add_move_button(layer, "▶", "ui_right", Vector2(212, -104))

func _add_move_button(layer: CanvasLayer, caption: String, action: String, offset: Vector2) -> void:
    var button := Button.new()
    button.text = caption
    button.custom_minimum_size = Vector2(88, 88)
    button.position = offset
    button.anchor_left = 0.0
    button.anchor_top = 1.0
    button.anchor_right = 0.0
    button.anchor_bottom = 1.0
    button.add_theme_font_size_override("font_size", 28)
    button.add_theme_color_override("font_color", Color(0.1, 0.16, 0.22))
    button.modulate = Color(1, 1, 1, 0.82)
    button.button_down.connect(func(): Input.action_press(action))
    button.button_up.connect(func(): Input.action_release(action))
    layer.add_child(button)
