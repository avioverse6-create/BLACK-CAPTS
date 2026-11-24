extends Area3D

signal collected

var token_id := -1

var spin_speed := 1.8
var bob_time := 0.0
var visual: Node3D

func _ready() -> void:
    monitoring = true
    monitorable = false

    var collision := CollisionShape3D.new()
    var shape := SphereShape3D.new()
    shape.radius = 0.8
    collision.shape = shape
    add_child(collision)

    visual = Node3D.new()
    visual.name = "TokenVisual"
    add_child(visual)

    var coin := MeshInstance3D.new()
    var mesh := CylinderMesh.new()
    mesh.top_radius = 0.42
    mesh.bottom_radius = 0.42
    mesh.height = 0.12
    mesh.radial_segments = 16
    coin.mesh = mesh
    coin.rotation_degrees.x = 90.0
    var material := StandardMaterial3D.new()
    material.albedo_color = Color(0.95, 0.68, 0.18)
    material.metallic = 0.55
    material.roughness = 0.28
    material.emission_enabled = true
    material.emission = Color(0.28, 0.13, 0.015)
    coin.material_override = material
    visual.add_child(coin)

    var center := MeshInstance3D.new()
    var center_mesh := SphereMesh.new()
    center_mesh.radius = 0.12
    center_mesh.height = 0.24
    center.mesh = center_mesh
    center.scale = Vector3(1.0, 0.35, 1.0)
    center.rotation_degrees.x = 90.0
    var center_material := StandardMaterial3D.new()
    center_material.albedo_color = Color(1.0, 0.88, 0.48)
    center.material_override = center_material
    visual.add_child(center)

    body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
    if visual == null:
        return
    bob_time += delta
    visual.rotation.y += spin_speed * delta
    visual.position.y = sin(bob_time * 2.2) * 0.12

func _on_body_entered(body: Node3D) -> void:
    if body.name != "Player":
        return
    collected.emit(token_id)
    queue_free()
