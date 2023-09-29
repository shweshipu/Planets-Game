extends Node
class_name Hexasphere

var _radius : float;
var _divisions : int;
var _hexSize : float;
var _meshDetails : MeshDetails; 

var Point = load("res://Scripts/Planet/Hex_Sphere_C#/Point.gd")
var Tile = load("res://Scripts/Planet/Hex_Sphere_C#/Tile.gd")

#List<Tile> 
var _tiles = [];
#List<Point> 
var _points = [];
#List<Face> 
var _icosahedronFaces = [];


#added by shwesh for godot function pass
var CachePoint : FuncRef = funcref(self,"CachePoint")

func _init(radius : float, divisions : int, hexSize: float):

	_radius = radius;
	_divisions = divisions;
	_hexSize = hexSize;

	_tiles = [] #new List<Tile>();
	_points = [] #new List<Point>();

	_icosahedronFaces = ConstructIcosahedron();
	#print(_icosahedronFaces)
	SubdivideIcosahedron();
	ConstructTiles();
	#_meshDetails = StoreMeshDetails();
	print("hexasphere ready")

func get_Tiles():
	#public List<Tile> Tiles => _tiles;
	return _tiles
func get_MeshDetails():
	#public MeshDetails MeshDetails => _meshDetails;
	return _meshDetails

func ToJson() -> String:
	#again im not implementing this yet but its not erroring
	#return "hexasphere to json not implemented yet"#$"{{\"radius\":{_radius},\"tiles\":[{string.Join(",",_tiles.Select(tile => tile.ToJson()))}]}}";
	#nvm this is important for saving processing later
	var tileJsons = ""
	for tile in _tiles:
		tileJsons += ","+tile.ToJson()
	tileJsons = tileJsons.substr(1)
	return "{\"radius\":"+str(_radius)+",\"tiles\":["+tileJsons+"]}";

""" not sure if this is used? gonna wait on this one
func ToObj() -> String: #oh frick this looks complicated
{
	var objString : String = $"#Hexasphere. Radius {_radius}, divisions {_divisions}, hexagons scaled to {_hexSize}\n";
	objString += string.Join("\n",_meshDetails.Vertices.Select(vertex => $"v {vertex.x} {vertex.y} {vertex.z}"));
	##+1 to all values as .obj indexes start from 1 -.-
	List<int> offsetTriangles = _meshDetails.Triangles.Select(index => index + 1).ToList();
	for (var i = 0; i < offsetTriangles.Count; i+=3)
	{
		objString += 
			$"f {offsetTriangles[i]} {offsetTriangles[i + 1]} {offsetTriangles[i + 2]}\n";
	}

	return objString;
}
"""

#returns list of faces
func ConstructIcosahedron():
	#these are consts but godot doesnt like having them in a function apparently
	#var tao : float = PI / 2.0; #wth its not supposed to be tao in the first place its phi, im surprised it doesnt look off
	var tao = 1.61803399 #the golden ratio, phi
	var defaultSize : float = 100;

	#List<Point> 
	var icosahedronCorners = \
	[
		Point.new(Vector3(defaultSize, tao * defaultSize, 0)),
		Point.new(Vector3(-defaultSize, tao * defaultSize, 0)),
		Point.new(Vector3(defaultSize, -tao * defaultSize, 0)),
		Point.new(Vector3(-defaultSize, -tao * defaultSize, 0)),
		Point.new(Vector3(0, defaultSize, tao * defaultSize)),
		Point.new(Vector3(0, -defaultSize, tao * defaultSize)),
		Point.new(Vector3(0, defaultSize, -tao * defaultSize)),
		Point.new(Vector3(0, -defaultSize, -tao * defaultSize)),
		Point.new(Vector3(tao * defaultSize, 0, defaultSize)),
		Point.new(Vector3(-tao * defaultSize, 0, defaultSize)),
		Point.new(Vector3(tao * defaultSize, 0, -defaultSize)),
		Point.new(Vector3(-tao * defaultSize, 0, -defaultSize))
	];
	for point in icosahedronCorners:
		CachePoint(point)	
	#icosahedronCorners.ForEach(point => CachePoint(point));

	#return new List<Face> 
	#for some reason i gotta return the array after assigning? not sure why
	var returnArray = \
	[
		Face.new(icosahedronCorners[0], icosahedronCorners[1], icosahedronCorners[4], false),
		Face.new(icosahedronCorners[1], icosahedronCorners[9], icosahedronCorners[4], false),
		Face.new(icosahedronCorners[4], icosahedronCorners[9], icosahedronCorners[5], false),
		Face.new(icosahedronCorners[5], icosahedronCorners[9], icosahedronCorners[3], false),
		Face.new(icosahedronCorners[2], icosahedronCorners[3], icosahedronCorners[7], false),
		Face.new(icosahedronCorners[3], icosahedronCorners[2], icosahedronCorners[5], false),
		Face.new(icosahedronCorners[7], icosahedronCorners[10], icosahedronCorners[2], false),
		Face.new(icosahedronCorners[0], icosahedronCorners[8], icosahedronCorners[10], false),
		Face.new(icosahedronCorners[0], icosahedronCorners[4], icosahedronCorners[8], false),
		Face.new(icosahedronCorners[8], icosahedronCorners[2], icosahedronCorners[10], false),
		Face.new(icosahedronCorners[8], icosahedronCorners[4], icosahedronCorners[5], false),
		Face.new(icosahedronCorners[8], icosahedronCorners[5], icosahedronCorners[2], false),
		Face.new(icosahedronCorners[1], icosahedronCorners[0], icosahedronCorners[6], false),
		Face.new(icosahedronCorners[3], icosahedronCorners[9], icosahedronCorners[11], false),
		Face.new(icosahedronCorners[6], icosahedronCorners[10], icosahedronCorners[7], false),
		Face.new(icosahedronCorners[3], icosahedronCorners[11], icosahedronCorners[7], false),
		Face.new(icosahedronCorners[11], icosahedronCorners[6], icosahedronCorners[7], false),
		Face.new(icosahedronCorners[6], icosahedronCorners[0], icosahedronCorners[10], false),
		Face.new(icosahedronCorners[11], icosahedronCorners[1], icosahedronCorners[6], false),
		Face.new(icosahedronCorners[9], icosahedronCorners[1], icosahedronCorners[11], false)
	];
	return returnArray


#private 
func CachePoint(point : Point) -> Point:
	var existingPoint = null
	for candidatePoint in _points:
		if Point.IsOverlapping(candidatePoint,point):
			existingPoint = candidatePoint
			break
	#Point existingPoint = _points.FirstOrDefault(candidatePoint => Point.IsOverlapping(candidatePoint, point));
	if (existingPoint != null):
		return existingPoint;

	_points.append(point);
	return point;



#private 
func SubdivideIcosahedron() -> void:

	for icoFace in _icosahedronFaces:
		var facePoints = icoFace.get_Points()
		var previousPoints = []
		var bottomSide = [facePoints[0]]
		var leftSide = facePoints[0].Subdivide(facePoints[1], _divisions, CachePoint); #passes function
		var rightSide = facePoints[0].Subdivide(facePoints[2], _divisions, CachePoint);
		var i = 1
		while i <= _divisions: #just doing a while loop cuz im worried doing range() might mess it up and i dont wanna think right now
			previousPoints = bottomSide;
			bottomSide = leftSide[i].Subdivide(rightSide[i], i, CachePoint);
			var j = 0
			while j < i:
				##Don\'t need to store faces, their points will have references to them.
				Face.new(previousPoints[j], bottomSide[j], bottomSide[j+1]);
				if (j == 0):
					j+=1
					continue;
				Face.new(previousPoints[j-1], previousPoints[j], bottomSide[j]);
				j+=1
			i+=1
	"""
	_icosahedronFaces.ForEach(icoFace =>
	{
		List<Point> facePoints = icoFace.Points;
		List<Point> previousPoints;
		List<Point> bottomSide = new List<Point> {facePoints[0]};
		List<Point> leftSide = facePoints[0].Subdivide(facePoints[1], _divisions, CachePoint);
		List<Point> rightSide = facePoints[0].Subdivide(facePoints[2], _divisions, CachePoint);
		for (int i = 1; i <= _divisions; i++)
		{
			previousPoints = bottomSide;
			bottomSide = leftSide[i].Subdivide(rightSide[i], i, CachePoint);
			for (int j = 0; j < i; j++)
			{
				##Don\'t need to store faces, their points will have references to them.
				new Face(previousPoints[j], bottomSide[j], bottomSide[j+1]);
				if (j == 0) continue;
				new Face(previousPoints[j-1], previousPoints[j], bottomSide[j]);
			}
		}
	});
	"""


#private
func ConstructTiles() -> void:
	for point in _points:
		_tiles.append(Tile.new(point, _radius, _hexSize))
	for tile in _tiles:
		tile.ResolveNeighbourTiles(_tiles)
	"""
	_points.ForEach(point =>
	{
		_tiles.Add(new Tile(point, _radius, _hexSize));
	});
	_tiles.ForEach(tile => tile.ResolveNeighbourTiles(_tiles));
	"""




		#private 
func StoreMeshDetails() -> MeshDetails:

	#List<Point> 
	var vertices = []#new List<Point>();
	#List<int> 
	var triangles = []#new List<int>();
	for tile in _tiles:
		for point in tile.get_Points():
			vertices.append(point)
		for face in tile.get_Faces():
			for point in face.get_Points():
				var vertexIndex : int
				var curIndex = 0
				for vertex in vertices:
					if vertex.get_ID() == point.get_ID():
						vertexIndex = curIndex
					curIndex+=1
				#vertices.find(vertex => vertex.ID == point.ID);
				triangles.append(vertexIndex)
	"""
	_tiles.ForEach(tile =>
	{
		tile.Points.ForEach(point =>
		{
			vertices.Add(point);
		});
		tile.Faces.ForEach(face =>
		{
			face.Points.ForEach(point =>
			{
				int vertexIndex = vertices.FindIndex(vertex => vertex.ID == point.ID);
				triangles.Add(vertexIndex);
			});
		});
	});
	"""
	var selectList = []
	for point in vertices:
		point.get_Position()
	return MeshDetails.new(selectList, triangles);
	#return new MeshDetails(vertices.Select(point => point.Position).ToList(), triangles);

#~~~~~end of file~~~~~#

"""
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Code.Hexasphere
{
	public class Hexasphere
	{
		private readonly float _radius;
		private readonly int _divisions;
		private readonly float _hexSize;
		private readonly MeshDetails _meshDetails;

		private readonly List<Tile> _tiles;
		private readonly List<Point> _points;
		private readonly List<Face> _icosahedronFaces;

		public Hexasphere(float radius, int divisions, float hexSize)
		{
			_radius = radius;
			_divisions = divisions;
			_hexSize = hexSize;

			_tiles = new List<Tile>();
			_points = new List<Point>();

			_icosahedronFaces = ConstructIcosahedron();
			SubdivideIcosahedron();
			ConstructTiles();
			_meshDetails = StoreMeshDetails();
		}

		public List<Tile> Tiles => _tiles;
		public MeshDetails MeshDetails => _meshDetails;

		public string ToJson()
		{
			return $"{{\"radius\":{_radius},\"tiles\":[{string.Join(",",_tiles.Select(tile => tile.ToJson()))}]}}";
		}

		public string ToObj()
		{
			string objString = $"#Hexasphere. Radius {_radius}, divisions {_divisions}, hexagons scaled to {_hexSize}\n";
			objString += string.Join("\n",_meshDetails.Vertices.Select(vertex => $"v {vertex.x} {vertex.y} {vertex.z}"));
			//+1 to all values as .obj indexes start from 1 -.-
			List<int> offsetTriangles = _meshDetails.Triangles.Select(index => index + 1).ToList();
			for (var i = 0; i < offsetTriangles.Count; i+=3)
			{
				objString +=
					$"f {offsetTriangles[i]} {offsetTriangles[i + 1]} {offsetTriangles[i + 2]}\n";
			}

			return objString;
		}

		private List<Face> ConstructIcosahedron()
		{
			const float tao = Mathf.PI / 2;
			const float defaultSize = 100f;

			List<Point> icosahedronCorners = new List<Point>
			{
				new Point(new Vector3(defaultSize, tao * defaultSize, 0f)),
				new Point(new Vector3(-defaultSize, tao * defaultSize, 0f)),
				new Point(new Vector3(defaultSize, -tao * defaultSize, 0f)),
				new Point(new Vector3(-defaultSize, -tao * defaultSize, 0f)),
				new Point(new Vector3(0, defaultSize, tao * defaultSize)),
				new Point(new Vector3(0, -defaultSize, tao * defaultSize)),
				new Point(new Vector3(0, defaultSize, -tao * defaultSize)),
				new Point(new Vector3(0, -defaultSize, -tao * defaultSize)),
				new Point(new Vector3(tao * defaultSize, 0f, defaultSize)),
				new Point(new Vector3(-tao * defaultSize, 0f, defaultSize)),
				new Point(new Vector3(tao * defaultSize, 0f, -defaultSize)),
				new Point(new Vector3(-tao * defaultSize, 0f, -defaultSize))
			};
			icosahedronCorners.ForEach(point => CachePoint(point));

			return new List<Face>
			{
				new Face(icosahedronCorners[0], icosahedronCorners[1], icosahedronCorners[4], false),
				new Face(icosahedronCorners[1], icosahedronCorners[9], icosahedronCorners[4], false),
				new Face(icosahedronCorners[4], icosahedronCorners[9], icosahedronCorners[5], false),
				new Face(icosahedronCorners[5], icosahedronCorners[9], icosahedronCorners[3], false),
				new Face(icosahedronCorners[2], icosahedronCorners[3], icosahedronCorners[7], false),
				new Face(icosahedronCorners[3], icosahedronCorners[2], icosahedronCorners[5], false),
				new Face(icosahedronCorners[7], icosahedronCorners[10], icosahedronCorners[2], false),
				new Face(icosahedronCorners[0], icosahedronCorners[8], icosahedronCorners[10], false),
				new Face(icosahedronCorners[0], icosahedronCorners[4], icosahedronCorners[8], false),
				new Face(icosahedronCorners[8], icosahedronCorners[2], icosahedronCorners[10], false),
				new Face(icosahedronCorners[8], icosahedronCorners[4], icosahedronCorners[5], false),
				new Face(icosahedronCorners[8], icosahedronCorners[5], icosahedronCorners[2], false),
				new Face(icosahedronCorners[1], icosahedronCorners[0], icosahedronCorners[6], false),
				new Face(icosahedronCorners[3], icosahedronCorners[9], icosahedronCorners[11], false),
				new Face(icosahedronCorners[6], icosahedronCorners[10], icosahedronCorners[7], false),
				new Face(icosahedronCorners[3], icosahedronCorners[11], icosahedronCorners[7], false),
				new Face(icosahedronCorners[11], icosahedronCorners[6], icosahedronCorners[7], false),
				new Face(icosahedronCorners[6], icosahedronCorners[0], icosahedronCorners[10], false),
				new Face(icosahedronCorners[11], icosahedronCorners[1], icosahedronCorners[6], false),
				new Face(icosahedronCorners[9], icosahedronCorners[1], icosahedronCorners[11], false)
			};
		}

		private Point CachePoint(Point point)
		{
			Point existingPoint = _points.FirstOrDefault(candidatePoint => Point.IsOverlapping(candidatePoint, point));
			if (existingPoint != null)
			{
				return existingPoint;
			}

			_points.Add(point);
			return point;
		}

		private void SubdivideIcosahedron()
		{
			_icosahedronFaces.ForEach(icoFace =>
			{
				List<Point> facePoints = icoFace.Points;
				List<Point> previousPoints;
				List<Point> bottomSide = new List<Point> {facePoints[0]};
				List<Point> leftSide = facePoints[0].Subdivide(facePoints[1], _divisions, CachePoint);
				List<Point> rightSide = facePoints[0].Subdivide(facePoints[2], _divisions, CachePoint);
				for (int i = 1; i <= _divisions; i++)
				{
					previousPoints = bottomSide;
					bottomSide = leftSide[i].Subdivide(rightSide[i], i, CachePoint);
					for (int j = 0; j < i; j++)
					{
						//Don\'t need to store faces, their points will have references to them.
						new Face(previousPoints[j], bottomSide[j], bottomSide[j+1]);
						if (j == 0) continue;
						new Face(previousPoints[j-1], previousPoints[j], bottomSide[j]);
					}
				}
			});
		}

		private void ConstructTiles()
		{
			_points.ForEach(point =>
			{
				_tiles.Add(new Tile(point, _radius, _hexSize));
			});
			_tiles.ForEach(tile => tile.ResolveNeighbourTiles(_tiles));
		}

		private MeshDetails StoreMeshDetails()
		{
			List<Point> vertices = new List<Point>();
			List<int> triangles = new List<int>();
			_tiles.ForEach(tile =>
			{
				tile.Points.ForEach(point =>
				{
					vertices.Add(point);
				});
				tile.Faces.ForEach(face =>
				{
					face.Points.ForEach(point =>
					{
						int vertexIndex = vertices.FindIndex(vertex => vertex.ID == point.ID);
						triangles.Add(vertexIndex);
					});
				});
			});

			return new MeshDetails(vertices.Select(point => point.Position).ToList(), triangles);
		}
	}
}
"""
