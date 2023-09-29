extends Node
class_name Face

var Point = load("res://Scripts/Planet/Hex_Sphere_C#/Point.gd")

var _id : String
var _points #: []

func _init(point1, point2, point3, trackFaceInPoints:bool = true):
	#im not sure what this does so...
	#_id = Guid.NewGuid().ToString();
	_id = self.name

	var centerX : float = (point1.get_Position().x + point2.get_Position().x + point3.get_Position().x) / 3.0;
	var centerY : float = (point1.get_Position().y + point2.get_Position().y + point3.get_Position().y) / 3.0;
	var centerZ : float = (point1.get_Position().z + point2.get_Position().z + point3.get_Position().z) / 3.0;
	var center : Vector3 = Vector3(centerX, centerY, centerZ);

	#Determine correct winding order
	var normal : Vector3 = GetNormal(point1, point2, point3);

	if IsNormalPointingAwayFromOrigin(center, normal):
	    _points = [point1, point2, point3] 
	else: 
	    _points = [point1, point3, point2]

	if (trackFaceInPoints):
		for point in _points:
			point.AssignFace(self)
		#i think ^ thats what it --> is?  _points.ForEach(point => point.AssignFace(this));


func get_ID() -> String: #TODO ctrl replace all 'ID' with get_ID()
	#I think this is the use case for what they put?
	#public string ID => _id;
	return _id

func get_Points():#TODO ctrl replace all 'Points' with get_Points()
	#public List<Point> Points => _points;
	return _points;

#waiting for godot4 when i can specify return types of lists
func GetOtherPoints(point):
	if (!IsPointPartOfFace(point)):
	    print("Given point must be one of the points on the face!");

	var returnList = []
	for facePoint in _points:
		if facePoint.get_ID() != point.get_ID():
			returnList.append(facePoint)
	return returnList#_points.Where(facePoint => facePoint.ID != point.ID).ToList();

func IsAdjacentToFace(face:Face) -> bool:
	var thisFaceIds = []

	for point in _points:
		thisFaceIds.append(point.get_ID())
	#List<string> thisFaceIds = _points.Select(point => point.ID).ToList();

	var otherFaceIds = []
	for point in face.get_Points():
		otherFaceIds.append(point.get_ID())
	#List<string> otherFaceIds = face.Points.Select(point => point.ID).ToList();

	var count = 0
	for faceId1 in thisFaceIds:
		for faceId2 in otherFaceIds:
			#i think just checking if same instance is all we need?
			if faceId1 == faceId2:
				count+=1
	return count == 2
	#return thisFaceIds.Intersect(otherFaceIds).ToList().Count == 2;


func GetCenter() :#-> Point:
	var centerX : float = (_points[0].get_Position().x + _points[1].get_Position().x + _points[2].get_Position().x) / 3.0;
	var centerY : float = (_points[0].get_Position().y + _points[1].get_Position().y + _points[2].get_Position().y) / 3.0;
	var centerZ : float = (_points[0].get_Position().z + _points[1].get_Position().z + _points[2].get_Position().z) / 3.0;

	return Point.new(Vector3(centerX, centerY, centerZ));

#private
func IsPointPartOfFace(point) -> bool:
	for facePoint in _points:
		if facePoint.get_ID() == point.get_ID():
			return true
	return false
	#return _points.Any(facePoint => facePoint.ID == point.ID);

#private. godot is giving me annoying "cyclic dependency" crap so i cant type these point inputs
static func GetNormal(point1, point2, point3) -> Vector3:
	var side1 : Vector3 = point2.get_Position() - point1.get_Position();
	var side2 : Vector3 = point3.get_Position() - point1.get_Position();

	var cross : Vector3 = side1.cross(side2) #Vector3.Cross(side1, side2);

	return cross / cross.length()#cross.magnitude;


#private
static func IsNormalPointingAwayFromOrigin(surface : Vector3, normal : Vector3) -> bool:
	#Does adding the normal vector to the center point of the face get you closer or further from the center of the polyhedron?
	return Vector3.ZERO.distance_to(surface) < Vector3.ZERO.distance_to(surface+normal)
	#return Vector3.Distance(Vector3.zero, surface) < Vector3.Distance(Vector3.zero, surface + normal);




"""
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Code.Hexasphere
{
    public class Face
    {
        private readonly string _id;
        private readonly List<Point> _points;

        public Face(Point point1, Point point2, Point point3, bool trackFaceInPoints = true)
        {
            _id = Guid.NewGuid().ToString();

            float centerX = (point1.Position.x + point2.Position.x + point3.Position.x) / 3;
            float centerY = (point1.Position.y + point2.Position.y + point3.Position.y) / 3;
            float centerZ = (point1.Position.z + point2.Position.z + point3.Position.z) / 3;
            Vector3 center = new Vector3(centerX, centerY, centerZ);

            //Determine correct winding order
            Vector3 normal = GetNormal(point1, point2, point3);
            _points = IsNormalPointingAwayFromOrigin(center, normal) ? 
                new List<Point> {point1, point2, point3} : 
                new List<Point> {point1, point3, point2};

            if (trackFaceInPoints)
            {
                _points.ForEach(point => point.AssignFace(this));
            }
        }

        public string ID => _id;

        public List<Point> Points => _points;

        public List<Point> GetOtherPoints(Point point)
        {
            if (!IsPointPartOfFace(point))
            {
                throw new ArgumentException("Given point must be one of the points on the face!");
            }

            return _points.Where(facePoint => facePoint.ID != point.ID).ToList();
        }

        public bool IsAdjacentToFace(Face face)
        {
            List<string> thisFaceIds = _points.Select(point => point.ID).ToList();
            List<string> otherFaceIds = face.Points.Select(point => point.ID).ToList();
            return thisFaceIds.Intersect(otherFaceIds).ToList().Count == 2;
        }

        public Point GetCenter()
        {
            float centerX = (_points[0].Position.x + _points[1].Position.x + _points[2].Position.x) / 3;
            float centerY = (_points[0].Position.y + _points[1].Position.y + _points[2].Position.y) / 3;
            float centerZ = (_points[0].Position.z + _points[1].Position.z + _points[2].Position.z) / 3;

            return new Point(new Vector3(centerX, centerY, centerZ));
        }

        private bool IsPointPartOfFace(Point point)
        {
            return _points.Any(facePoint => facePoint.ID == point.ID);
        }

        private static Vector3 GetNormal(Point point1, Point point2, Point point3)
        {
            Vector3 side1 = point2.Position - point1.Position;
            Vector3 side2 = point3.Position - point1.Position;

            Vector3 cross = Vector3.Cross(side1, side2);

            return cross / cross.magnitude;
        }

        private static bool IsNormalPointingAwayFromOrigin(Vector3 surface, Vector3 normal)
        {
            //Does adding the normal vector to the center point of the face get you closer or further from the center of the polyhedron?
            return Vector3.Distance(Vector3.zero, surface) < Vector3.Distance(Vector3.zero, surface + normal);
        }
    }
}
"""
