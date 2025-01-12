tool
extends Spatial

onready var sky_mesh = preload("res://assets/simple_skybox/skybox.obj")

export(StreamTexture) var TextureFront = preload("res://Skyboxes/galaxy/galaxy+X.tga")

export(StreamTexture) var TextureBack = preload("res://Skyboxes/galaxy/galaxy-X.tga")

export(StreamTexture) var TextureBottom = preload("res://Skyboxes/galaxy/galaxy-Y.tga")

export(StreamTexture) var TextureUp = preload("res://Skyboxes/galaxy/galaxy+Y.tga")

export(StreamTexture) var TextureLeft = preload("res://Skyboxes/galaxy/galaxy+Z.tga")

export(StreamTexture) var TextureRight = preload("res://Skyboxes/galaxy/galaxy-Z.tga")

func create_mat(texture):
	var m = SpatialMaterial.new()
	m.flags_unshaded = true
	m.albedo_texture = texture
	return m

func _ready():
	var i_mesh = MeshInstance.new()
	i_mesh.name = "SkyMeshInstance"
	i_mesh.mesh = sky_mesh
	add_child(i_mesh)
	i_mesh.set_surface_material(0, create_mat(TextureBottom))
	i_mesh.set_surface_material(1, create_mat(TextureUp))
	i_mesh.set_surface_material(2, create_mat(TextureFront))
	i_mesh.set_surface_material(3, create_mat(TextureLeft))
	i_mesh.set_surface_material(4, create_mat(TextureBack))
	i_mesh.set_surface_material(5, create_mat(TextureRight))
	
