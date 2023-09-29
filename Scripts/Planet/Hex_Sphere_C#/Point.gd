extends Node
class_name Point

var Face = load("res://Scripts/Planet/Hex_Sphere_C#/Face.gd")

var _id : String;
var _position : Vector3;
var _faces = [];

const PointComparisonAccuracy : float = 0.000001;

func _init(position : Vector3):
	_id = self.name#Guid.NewGuid().ToString();
	_position = position;
	_faces = [];

"""
this is a private constructor for returning a copy of self, used exclusively in ProjectToSphere.
godot doesnt have constructor overloading so im just gonna manually change the variables to be this thing's stuff
implemented as copy_self_at()

#private 
func Point(Vector3 position, string id, List<Face> faces)
{
	_faces = new List<Face>();

	_id = id;
	_position = position;
	_faces = faces;
}
"""
#private
func copy_self_at(position : Vector3) -> Point: #only used in ProjectToSphere()
	"""
	stupid frickin godot 3 doesnt have method overloading, constructor overloading, so this method exists

	it also doesnt allow you to do cyclic references ffs

	also oml just let me reference other classes with static typing smh
	"""
	#in place of private constructor, i did this (had to break private variable regulations)
	var returnPoint = load("res://Scripts/Planet/Hex_Sphere_C#/Point.gd").new(position) #godot 3 wont let me do a cyclic reference SMH 
	returnPoint._id = self._id
	returnPoint._faces = self._faces

	return returnPoint

func get_Position() -> Vector3:
	#public Vector3 Position => _position;
	return _position
func get_ID() -> String:
	#public string ID => _id;
	return _id
func get_Faces():
	#public List<Face> Faces => _faces;
	return _faces

func AssignFace(face : Face) -> void:
	_faces.append(face);

func Subdivide(target : Point, count : int, findDuplicatePointIfExists : FuncRef):
	var segments = []
	segments.append(self);
	var i: int = 1
	while(i<=count):
		var x : float = _position.x * (1 - float(i) / count) + target.get_Position().x * (float(i) / count);
		var y : float = _position.y * (1 - float(i) / count) + target.get_Position().y * (float(i) / count);
		var z : float = _position.z * (1 - float(i) / count) + target.get_Position().z * (float(i) / count);

		var newPoint = findDuplicatePointIfExists.call_func(load("res://Scripts/Planet/Hex_Sphere_C#/Point.gd").new(Vector3(x, y, z)));
		segments.append(newPoint);
		i+=1

	segments.append(target);
	return segments;


func ProjectToSphere(radius : float, t : float) -> Point:
	var projectionPoint : float = radius / _position.length();
	var x : float = _position.x * projectionPoint * t;
	var y : float = _position.y * projectionPoint * t;
	var z : float = _position.z * projectionPoint * t;

	return copy_self_at(Vector3(x,y,z))
	#return new Point(new Vector3(x, y, z), _id, _faces);

func GetOrderedFaces():
	if (_faces.size() == 0):
		return _faces;
	var orderedList = _faces.duplicate(true)#[0]] what
	#List<Face> orderedList = new List<Face> {_faces[0]};

	var currentFace : Face = orderedList[0];
	while (orderedList.size() < _faces.size()):
		var existingIds = []
		for face in orderedList:
			existingIds.append(face.get_ID())
		#List<string> existingIds = orderedList.Select(face => face.ID).ToList();

		var neighbour : Face
		for face in _faces:
			if existingIds.has(face.get_ID()) and face.IsAdjacentToFace(currentFace):
				neighbour = face
				break
		#var neighbour : Face = _faces.First(face => !existingIds.Contains(face.ID) && face.IsAdjacentToFace(currentFace));
		currentFace = neighbour;
		orderedList.append(currentFace);

	return orderedList;


static func IsOverlapping(a : Point, b : Point) -> bool:
	return \
	 abs(a.get_Position().x - b.get_Position().x) <= PointComparisonAccuracy && \
	 abs(a.get_Position().y - b.get_Position().y) <= PointComparisonAccuracy && \
	 abs(a.get_Position().z - b.get_Position().z) <= PointComparisonAccuracy;


func ToString() -> String:
	return str(_position.x, _position.y, _position.z)
	#return $"{_position.x},{_position.y},{_position.z}";

func ToJson() -> String:
	#idk if i need this so ima wait to translate, it doesnt really error for now tho so idk if it even needs changed ¯\_ (ツ)_/¯
	return "Point to json not yet implemented"#$"{{\"x\":{_position.x},\"y\":{_position.y},\"z\":{_position.z}, \"guid\":\"{_id}\"}}";


"""
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Code.Hexasphere
{
	public class Point
	{
		private readonly string _id;
		private readonly Vector3 _position;
		private readonly List<Face> _faces;

		private const float PointComparisonAccuracy = 0.000001f;

		public Point(Vector3 position)
		{
			_id = Guid.NewGuid().ToString();
			_position = position;
			_faces = new List<Face>();
		}

		private Point(Vector3 position, string id, List<Face> faces)
		{
			_faces = new List<Face>();

			_id = id;
			_position = position;
			_faces = faces;
		}

		public Vector3 Position => _position;

		public string ID => _id;

		public List<Face> Faces => _faces;

		public void AssignFace(Face face)
		{
			_faces.Add(face);
		}

		public List<Point> Subdivide(Point target, int count, Func<Point, Point> findDuplicatePointIfExists)
		{
			List<Point> segments = new List<Point>();
			segments.Add(this);

			for (int i = 1; i <= count; i++)
			{
				float x = _position.x * (1 - (float) i / count) + target.Position.x * ((float) i / count);
				float y = _position.y * (1 - (float) i / count) + target.Position.y * ((float) i / count);
				float z = _position.z * (1 - (float) i / count) + target.Position.z * ((float) i / count);

				Point newPoint = findDuplicatePointIfExists(new Point(new Vector3(x, y, z)));
				segments.Add(newPoint);
			}

			segments.Add(target);
			return segments;
		}

		public Point ProjectToSphere(float radius, float t)
		{
			float projectionPoint = radius / _position.magnitude;
			float x = _position.x * projectionPoint * t;
			float y = _position.y * projectionPoint * t;
			float z = _position.z * projectionPoint * t;
			return new Point(new Vector3(x, y, z), _id, _faces);
		}

		public List<Face> GetOrderedFaces()
		{
			if (_faces.Count == 0) return _faces;
			List<Face> orderedList = new List<Face> {_faces[0]};

			Face currentFace = orderedList[0];
			while (orderedList.Count < _faces.Count)
			{
				List<string> existingIds = orderedList.Select(face => face.ID).ToList();
				Face neighbour = _faces.First(face => !existingIds.Contains(face.ID) && face.IsAdjacentToFace(currentFace));
				currentFace = neighbour;
				orderedList.Add(currentFace);
			}

			return orderedList;
		}

		public static bool IsOverlapping(Point a, Point b)
		{
			return
				Mathf.Abs(a.Position.x - b.Position.x) <= PointComparisonAccuracy &&
				Mathf.Abs(a.Position.y - b.Position.y) <= PointComparisonAccuracy &&
				Mathf.Abs(a.Position.z - b.Position.z) <= PointComparisonAccuracy;
		}

		public override string ToString()
		{
			return $"{_position.x},{_position.y},{_position.z}";
		}

		public string ToJson()
		{
			return $"{{\"x\":{_position.x},\"y\":{_position.y},\"z\":{_position.z}, \"guid\":\"{_id}\"}}";
		}
	}
}
"""
