extends Node
class_name MeshDetails

        #private readonly List<Vector3> 
var _vertices = [];
        #private readonly List<int> 
var _triangles = [];

#List<Vector3> vertices, List<int> triangles
func _init(vertices, triangles):
	_vertices = vertices;
	_triangles = triangles;

func get_Vertices():
	#public List<Vector3> Vertices => _vertices;
	return _vertices
func get_Triangles():
	#public List<int> Triangles => _triangles;
	return _triangles


"""
using System.Collections.Generic;
using UnityEngine;

namespace Code.Hexasphere
{
    public class MeshDetails
    {
        private readonly List<Vector3> _vertices;
        private readonly List<int> _triangles;

        public MeshDetails(List<Vector3> vertices, List<int> triangles)
        {
            _vertices = vertices;
            _triangles = triangles;
        }

        public List<Vector3> Vertices => _vertices;

        public List<int> Triangles => _triangles;
    }
}
"""
