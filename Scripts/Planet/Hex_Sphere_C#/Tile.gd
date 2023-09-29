extends Node
class_name Tile

var Point = load("res://Scripts/Planet/Hex_Sphere_C#/Point.gd")
var Face = load("res://Scripts/Planet/Hex_Sphere_C#/Face.gd")

var _center : Point;
var _radius : float;
var _size : float;

var _faces = [] #: Face
var _points = [] #: Point
var _neighbourCenters = [] #: Point
var _neighbours = [] #: Tile
#added by shwesh
var _poly #setget set_poly, get_poly#: Polygon

func _init(center : Point, radius : float, size : float):
	_points = []#new List<Point>();
	_faces = []#new List<Face>();
	_neighbourCenters = []#new List<Point>();
	_neighbours = []#new List<Tile>();

	_center = center;
	_radius = radius;
	_size = max(0.01, min(1.0, size));
	
	assert(radius != 0)
	
	var icosahedronFaces = center.GetOrderedFaces();
	StoreNeighbourCenters(icosahedronFaces);
	BuildFaces(icosahedronFaces);

func get_Points():
	#public List<Point> Points => _points;
	return _points
func get_Faces():
	#public List<Face> Faces => _faces;
	return _faces
func get_Neighbours():
	#public List<Tile> Neighbours => _neighbours;
	return _neighbours

#waiting for 4.0 with list casts #List<Tile> 
func ResolveNeighbourTiles(allTiles) -> void:
	var neighbourIds = []
	for center in _neighbourCenters:
		neighbourIds.append(center.get_ID())
	#List<string> neighbourIds = _neighbourCenters.Select(center => center.ID).ToList();

	var whereList = []
	for tile in allTiles:
		if neighbourIds.has(tile._center.get_ID()):
			whereList.append(tile)
	_neighbours = whereList
	#_neighbours = allTiles.Where(tile => neighbourIds.Contains(tile._center.ID)).ToList();

func ToString() -> String:
	return _center.to_string()
	#return $"{_center.Position.x},{_center.Position.y},{_center.Position.z}";

func ToJson() -> String:
	#idk if i need this either aaaaaa
	#return "Tile to json not implemented yet"
	var pointJsons = ""
	for point in _points:
		pointJsons += ","+point.ToJson()
	pointJsons = pointJsons.substr(1)
	return "{\"centerPoint\":"+_center.ToJson()+",\"boundary\":["+pointJsons+"]}";


#takes a list of Faces
func StoreNeighbourCenters(icosahedronFaces) -> void:
	for face in icosahedronFaces:
		var otherPoints = face.GetOtherPoints(_center)
		for point in otherPoints:
			var isInNeighbourCenters = false
			for centerPoint in _neighbourCenters:
				if centerPoint.get_ID() == point.get_ID():
					isInNeighbourCenters = true
			if not isInNeighbourCenters:
				_neighbourCenters.append(point)
	"""
	icosahedronFaces.ForEach(face =>
	{
		List<Point> otherPoints = face.GetOtherPoints(_center);
		otherPoints.ForEach(point =>
		{
			if (_neighbourCenters.FirstOrDefault(centerPoint => centerPoint.ID == point.ID) == null)
			{
				_neighbourCenters.Add(point);
			}
		});
	});
	"""

#private, takes list of faces
func BuildFaces(icosahedronFaces) -> void:
	var polygonPoints = []
	for face in icosahedronFaces:
		polygonPoints.append(lerp(_center.get_Position(), face.GetCenter().get_Position(), _size))
	#List<Vector3> polygonPoints = icosahedronFaces.Select(face => Vector3.Lerp(_center.Position, face.GetCenter().Position, _size)).ToList();

	for pos in polygonPoints:
		_points.append(Point.new(pos).ProjectToSphere(_radius,0.5))
	#polygonPoints.ForEach(pos => _points.Add(new Point(pos).ProjectToSphere(_radius, 0.5f)));

	_faces.append(Face.new(_points[0], _points[1], _points[2]));
	_faces.append(Face.new(_points[0], _points[2], _points[3]));
	_faces.append(Face.new(_points[0], _points[3], _points[4]));

	if (_points.size() > 5):
		_faces.append(Face.new(_points[0], _points[4], _points[5]));



###added by shwesh
func get_center():
	return _center
	
func get_poly():
	return _poly
func set_poly(newPoly):
	_poly = newPoly
"""
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Code.Hexasphere
{
	public class Tile
	{
		private readonly Point _center;
		private readonly float _radius;
		private readonly float _size;

		private readonly List<Face> _faces;
		private readonly List<Point> _points;
		private readonly List<Point> _neighbourCenters;
		private List<Tile> _neighbours;

		public Tile(Point center, float radius, float size)
		{
			_points = new List<Point>();
			_faces = new List<Face>();
			_neighbourCenters = new List<Point>();
			_neighbours = new List<Tile>();

			_center = center;
			_radius = radius;
			_size = Mathf.Max(0.01f, Mathf.Min(1f, size));

			List<Face> icosahedronFaces = center.GetOrderedFaces();
			StoreNeighbourCenters(icosahedronFaces);
			BuildFaces(icosahedronFaces);
		}

		public List<Point> Points => _points;
		public List<Face> Faces => _faces;
		public List<Tile> Neighbours => _neighbours;

		public void ResolveNeighbourTiles(List<Tile> allTiles)
		{
			List<string> neighbourIds = _neighbourCenters.Select(center => center.ID).ToList();
			_neighbours = allTiles.Where(tile => neighbourIds.Contains(tile._center.ID)).ToList();
		}

		public override string ToString()
		{
			return $"{_center.Position.x},{_center.Position.y},{_center.Position.z}";
		}

		public string ToJson()
		{
			return $"{{\"centerPoint\":{_center.ToJson()},\"boundary\":[{string.Join(",",_points.Select(point => point.ToJson()))}]}}";
		}

		private void StoreNeighbourCenters(List<Face> icosahedronFaces)
		{
			icosahedronFaces.ForEach(face =>
			{
				List<Point> otherPoints = face.GetOtherPoints(_center);
				otherPoints.ForEach(point =>
				{
					if (_neighbourCenters.FirstOrDefault(centerPoint => centerPoint.ID == point.ID) == null)
					{
						_neighbourCenters.Add(point);
					}
				});
			});
		}

		private void BuildFaces(List<Face> icosahedronFaces)
		{
			List<Vector3> polygonPoints = icosahedronFaces.Select(face => Vector3.Lerp(_center.Position, face.GetCenter().Position, _size)).ToList();
			polygonPoints.ForEach(pos => _points.Add(new Point(pos).ProjectToSphere(_radius, 0.5f)));
			_faces.Add(new Face(_points[0], _points[1], _points[2]));
			_faces.Add(new Face(_points[0], _points[2], _points[3]));
			_faces.Add(new Face(_points[0], _points[3], _points[4]));
			if (_points.Count > 5)
			{
				_faces.Add(new Face(_points[0], _points[4], _points[5]));
			}
		}
	}
}
"""
