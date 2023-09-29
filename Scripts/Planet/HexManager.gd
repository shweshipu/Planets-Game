extends Spatial
class_name HexManager
var Polygon = load("res://Scripts/Planet/Hex_Sphere_C#/Polygon.gd")

var rngSeed
var planetType
var drawer = DrawHexasphere.new()#DrawHexasphere.new(rngSeed,planetType)

var Hexasphere = load("res://Scripts/Planet/Hex_Sphere_C#/Hexasphere.gd")
var _hexasphere #: Hexasphere;
#[Min(5f)]
export(float,5,1000) var radius : float = 10;
#[Range(1, 15)] go til it lags woooooo
export(int,1,50) var divisions : int = 4;
#[Range(0.1f, 1f)]
export(float,0.1,1.0) var hexSize : float = 0.98;

#render of tiles, what is clickable
var polys

var pathfinder = AStar.new()

#our tile logic
var tiles = []
var Strat_Tile = load("res://Scripts/Planet/Strat_Tile.gd")


#used later in A_Celestial
func _init(newradius,newdivisions):
	radius = newradius
	divisions = newdivisions
	fake_ready()

func fake_ready():
	_hexasphere = Hexasphere.new(radius, divisions, hexSize);
	
	polys = drawer.DrawHexasphereMesh(_hexasphere.get_Tiles(),radius)
	add_child(drawer)
	print("tilecount of hexmanager is:",_hexasphere.get_Tiles().size())
	"""
	for poly in polys:
		#pathfinder.add_point(poly.get_center())
		#set pos to be position plus position's distance from center of the hexasphere so that way i can place pieces above the plane
		var pos = poly.position + 
		var tile = Strat_Tile.new(pos)
		poly.add_child(tile)
		self.tiles.append(tile)
		##TODO how do i connect the points
	"""

func polyClick(which : Polygon):
	#TODO
	#pathfinder.
	pass
