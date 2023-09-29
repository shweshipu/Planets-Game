extends Spatial
"""
This class keeps track of what pieces are placed on a tile.

It acts as one node of a planet's graph.

It does not keep track of visuals, its parent is a tile mesh
"""

#what tiles are adjacent in the graph?
var neighbors = [] #Strat_Tile[]
#what things are on this tile?
var pieces = {} #dictionary

func place_piece(key, piece):
	"""
	do various checks, then place a piece in the proper key of the dictionary, then move the piece here.
	"""
	if(not pieces[key] == null):
		return false
	else:
		pieces[key] = piece
		self.add_child(piece)
		piece.position = Vector3.ZERO
