extends MeshInstance #change this all to be MultiMeshInstance instead

var arr = []
var verts
var uvs
var normals
var indices
var mat = SpatialMaterial.new()
var color = Color(0.9,0.1,0.1);

var tempMesh = Mesh.new()

func _init():
	arr.resize(Mesh.ARRAY_MAX)
	
	self.verts = PoolVector3Array()
	self.uvs = PoolVector2Array()
	self.normals = PoolVector3Array()
	self.indices = PoolIntArray()
	
	
	
	pass

func _ready():
	"""
	var arr = []
	arr.resize(Mesh.ARRAY_MAX)
	
	# PoolVectorXXArrays for mesh construction.
	this.verts = PoolVector3Array()
	this.uvs = PoolVector2Array()
	this.normals = PoolVector3Array()
	this.indices = PoolIntArray()
	
	#######################################
	## Insert code here to generate mesh ##
	
	verts = 
	
	#######################################
	"""
	# Assign arrays to mesh array.
	arr[Mesh.ARRAY_VERTEX] = self.verts
	arr[Mesh.ARRAY_TEX_UV] = self.uvs
	arr[Mesh.ARRAY_NORMAL] = self.normals
	arr[Mesh.ARRAY_INDEX] = self.indices
	
	verts.push_back(Vector3(1,0,0))
	verts.push_back(Vector3(1,0,1))
	verts.push_back(Vector3(0,0,1))
	verts.push_back(Vector3(0,0,0))
	verts.push_back(Vector3(0,1,0))
	verts.push_back(Vector3(0,-1,0))
	"""
	uvs.push_back(Vector2(0,0))
	uvs.push_back(Vector2(0,1))
	uvs.push_back(Vector2(1,1))
	uvs.push_back(Vector2(1,0))
	"""
	mat.albedo_color = color
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)
	
	for v in verts.size():
		st.add_color(color)
		#st.add_uv(uvs[v])
		st.add_vertex(verts[v])
	
	st.commit(tempMesh)
	
	#$MeshInstance
	self.mesh=tempMesh
	
	#addTriangle(Vector3(-1, -1, 0),
	 #Vector3(-1, 1, 0),
	 #Vector3(1, 1, 0))
	draw()
func draw():
	# Create mesh surface from mesh array.
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr) # No blendshapes or compression used.

# add a vertices to it
func addVert():
	pass
#pass 3 vector 3s here
func addTriangle(a, b, c):
	#TODO
	##do i just pass this to a godot function?
	self.verts.append(a);
	self.verts.append(b);
	self.verts.append(c);
	#maybe this ^ weill work??? idk
