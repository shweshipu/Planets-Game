#extends Reference
#class_name Hexasphere
#"""
#TODO
#I think whats wrong is that i need to convert all the points stuff to be an array, or mess with how godot does dictionaries
#
#"""
#
##variables
#var radius;
#var tiles;
#var tileLookup;
#var points;
#var faceString;
#"""
#var Tile = require('./tile'),
#    Face = require('./face'),
#    Point = require('./point');
#"""
#func _init(newRadius, numDivisions, hexSize):
#	var Point = load("res://Scripts/Hex_Sphere/Point.gd");
#	var Face = load("res://Scripts/Hex_Sphere/Face.gd");
#
#	radius = newRadius;
#	var tao = 1.61803399;
#
#	var corners = [ 
#		##make a point for each corner of an ICOSAHEDRON
#		 Point.new(1000, tao * 1000, 0),
#		 Point.new(-1000, tao * 1000, 0),
#		 Point.new(1000,-tao * 1000,0),
#		 Point.new(-1000,-tao * 1000,0),
#		 Point.new(0,1000,tao * 1000),
#		 Point.new(0,-1000,tao * 1000),
#		 Point.new(0,1000,-tao * 1000),
#		 Point.new(0,-1000,-tao * 1000),
#		 Point.new(tao * 1000,0,1000),
#		 Point.new(-tao * 1000,0,1000),
#		 Point.new(tao * 1000,0,-1000),
#		 Point.new(-tao * 1000,0,-1000)
#	];
#
#	points = {};
#
#	for i in range(0, len(corners)):
#		points[corners[i]] = corners[i];
#
#	##make the faces of an ICOSAHEDRON
#	var faces = [
#         Face.new(corners[0], corners[1], corners[4], false),
#         Face.new(corners[1], corners[9], corners[4], false),
#         Face.new(corners[4], corners[9], corners[5], false),
#         Face.new(corners[5], corners[9], corners[3], false),
#         Face.new(corners[2], corners[3], corners[7], false),
#         Face.new(corners[3], corners[2], corners[5], false),
#         Face.new(corners[7], corners[10], corners[2], false),
#         Face.new(corners[0], corners[8], corners[10], false),
#         Face.new(corners[0], corners[4], corners[8], false),
#         Face.new(corners[8], corners[2], corners[10], false),
#         Face.new(corners[8], corners[4], corners[5], false),
#         Face.new(corners[8], corners[5], corners[2], false),
#         Face.new(corners[1], corners[0], corners[6], false),
#         Face.new(corners[11], corners[1], corners[6], false),
#         Face.new(corners[3], corners[9], corners[11], false),
#         Face.new(corners[6], corners[10], corners[7], false),
#         Face.new(corners[3], corners[11], corners[7], false),
#         Face.new(corners[11], corners[6], corners[7], false),
#         Face.new(corners[6], corners[0], corners[10], false),
#         Face.new(corners[9], corners[1], corners[11], false)
#    ];
#
#
#	var newFaces = [];
#	##Divide the faces of that icosahedron
#	for f in range(0, len(faces)):
#		# console.log("-0---");
#		var prev = null;
#		var bottom = [faces[f].points[0]];
#		var left = faces[f].points[0].subdivide(faces[f].points[1], numDivisions, self);##made it so the point can access this easier   #null);#getPointIfExists); ## yo you can pass a raw function as a parameter?
#		var right = faces[f].points[0].subdivide(faces[f].points[2], numDivisions, self);#null);#getPointIfExists);
#
#		#no the for loop is not the bug, future me, maybe the passed reference?
#		for i in range(1, numDivisions+1):
#			prev = bottom;
#			bottom = left[i].subdivide(right[i], i, self);#getPointIfExists);
#			for j in range(0, i):
#				var nf = Face.new(prev[j], bottom[j], bottom[j+1], null); ## added null cuz js defaults omitted variables as that (undefined) anyways?
#				newFaces.append(nf);
#
#				if(j > 0):
#					nf = Face.new(prev[j-1], prev[j], bottom[j], null); ## what?! why does it call init twice????
#					newFaces.append(nf);
#
#	faces = newFaces;
#
#	var newPoints = {};
#	for p in points.values():#im assuming values
#		var np = points[p].project(radius, null); #added null cuz js ommission rules
#		newPoints[np] = np;
#
#	self.points = newPoints;
#
#	self.tiles = [];
#	self.tileLookup = {};
#
#	# create tiles and store in a lookup for references
#	for p in points.values(): # Om assuming values
#		var newTile = load("res://Scripts/Hex_Sphere/Tile.gd").new(points[p], hexSize);
#		self.tiles.append(newTile);
#		self.tileLookup[newTile.toString()] = newTile;
#
#	# resolve neighbor references now that all have been created
#	for t in range(len(self.tiles)):
#		var _this = self;
#		#convert array.map
#		var neighborIds2 = [];
#		for i in tiles[t].neighborIds:
#			if i in _this.tileLookup.values(): ##?Im assuming I want the values?
#				neighborIds2.append(i);
#		self.tiles[t].neighbors = neighborIds2;
#
#func getPointIfExists(point):##was embedded in constructor
#
#	#print("CHECKING POINT",point.toString())
#	### HMMMMMM THE IF STATEMENT IS NEVER TRUE. BIT STRANGE INNIT?
#
##	var isIn;
##	var foundPoint
##	for i in points:
##		if(point.compareTo(i)):
##			isIn = true;
##			foundPoint = i
##
##	if(isIn):#self.points.has(point)): #if(points[point]):
##		# console.log("EXISTING!");
##		#print("this one already exists!:", foundPoint.toString()) ##gotta check if this activates on original
##		#return points[point]; #sussy baka?
##		return foundPoint
##
##	else:
##		# console.log("NOT EXISTING!");
##		points[point] = point;
##		#print("NOT EXISTING")
##		return point; 
##IDK what the heck i wrote up there so im rewriting it. i doubt its the bug though.
#	if(self.points.has(point)):
#		#print("EXISTING!");
#		return points[point];
#	else:
#		#print("NOT EXISTING!");
#		points[point] = point;
#	return point;
#
#
#
#### js code
#"""
#var Hexasphere = function(radius, numDivisions, hexSize){
#
#    this.radius = radius;
#    var tao = 1.61803399;
#    var corners = [
#        new Point(1000, tao * 1000, 0),
#        new Point(-1000, tao * 1000, 0),
#        new Point(1000,-tao * 1000,0),
#        new Point(-1000,-tao * 1000,0),
#        new Point(0,1000,tao * 1000),
#        new Point(0,-1000,tao * 1000),
#        new Point(0,1000,-tao * 1000),
#        new Point(0,-1000,-tao * 1000),
#        new Point(tao * 1000,0,1000),
#        new Point(-tao * 1000,0,1000),
#        new Point(tao * 1000,0,-1000),
#        new Point(-tao * 1000,0,-1000)
#    ];
#
#    var points = {};
#
#    for(var i = 0; i< corners.length; i++){
#        points[corners[i]] = corners[i];
#    }
#
#    var faces = [
#        new Face(corners[0], corners[1], corners[4], false),
#        new Face(corners[1], corners[9], corners[4], false),
#        new Face(corners[4], corners[9], corners[5], false),
#        new Face(corners[5], corners[9], corners[3], false),
#        new Face(corners[2], corners[3], corners[7], false),
#        new Face(corners[3], corners[2], corners[5], false),
#        new Face(corners[7], corners[10], corners[2], false),
#        new Face(corners[0], corners[8], corners[10], false),
#        new Face(corners[0], corners[4], corners[8], false),
#        new Face(corners[8], corners[2], corners[10], false),
#        new Face(corners[8], corners[4], corners[5], false),
#        new Face(corners[8], corners[5], corners[2], false),
#        new Face(corners[1], corners[0], corners[6], false),
#        new Face(corners[11], corners[1], corners[6], false),
#        new Face(corners[3], corners[9], corners[11], false),
#        new Face(corners[6], corners[10], corners[7], false),
#        new Face(corners[3], corners[11], corners[7], false),
#        new Face(corners[11], corners[6], corners[7], false),
#        new Face(corners[6], corners[0], corners[10], false),
#        new Face(corners[9], corners[1], corners[11], false)
#    ];
#
#    var getPointIfExists = function(point){
#        if(points[point]){
#            // console.log("EXISTING!");
#            return points[point];
#        } else {
#            // console.log("NOT EXISTING!");
#            points[point] = point;
#            return point;
#        }
#    };
#
#
#    var newFaces = [];
#
#    for(var f = 0; f< faces.length; f++){
#        // console.log("-0---");
#        var prev = null;
#        var bottom = [faces[f].points[0]];
#        var left = faces[f].points[0].subdivide(faces[f].points[1], numDivisions, getPointIfExists);
#        var right = faces[f].points[0].subdivide(faces[f].points[2], numDivisions, getPointIfExists);
#        for(var i = 1; i<= numDivisions; i++){
#            prev = bottom;
#            bottom = left[i].subdivide(right[i], i, getPointIfExists);
#            for(var j = 0; j< i; j++){
#                var nf = new Face(prev[j], bottom[j], bottom[j+1]); 
#                newFaces.push(nf);
#
#                if(j > 0){
#                    nf = new Face(prev[j-1], prev[j], bottom[j]);
#                    newFaces.push(nf);
#                }
#            }
#        }
#    }
#
#    faces = newFaces;
#
#    var newPoints = {};
#    for(var p in points){
#        var np = points[p].project(radius);
#        newPoints[np] = np;
#    }
#
#    points = newPoints;
#
#    this.tiles = [];
#    this.tileLookup = {};
#
#    // create tiles and store in a lookup for references
#    for(var p in points){
#        var newTile = new Tile(points[p], hexSize);
#        this.tiles.push(newTile);
#        this.tileLookup[newTile.toString()] = newTile;
#    }
#
#    // resolve neighbor references now that all have been created
#    for(var t in this.tiles){
#        var _this = this;
#        this.tiles[t].neighbors = this.tiles[t].neighborIds.map(function(item){return _this.tileLookup[item]});
#    }
#
#};
#"""
#
#func toJson():
#	var tiles2
#	for i in self.tiles:
#		tiles2.push(i.toJson());
#	return JSON.stringify({
#        radius: self.radius,
#        tiles: tiles2
#    });
#### js code
#"""
#Hexasphere.prototype.toJson = function() {
#
#    return JSON.stringify({
#        radius: this.radius,
#        tiles: this.tiles.map(function(tile){return tile.toJson()})
#    });
#}
#"""
#
#func toObj():
#	var objV = [];
#	var objF = [];
#	var objText = "# vertices \n";
#	var vertexIndexMap = {};
#
#	for i in range(0, self.tiles.length):
#		var t = self.tiles[i];
#
#		var F = []
#		for j in range(0, t.boundary.length):
#			var index = vertexIndexMap[t.boundary[j]];
#			if(index == null):
#				objV.push(t.boundary[j]);
#				index = objV.length;
#				vertexIndexMap[t.boundary[j]] = index;
#
#			F.push(index)
#
#		objF.push(F);
#
#	for i in range(0, objV.length):
#		objText += 'v ' + objV[i].x + ' ' + objV[i].y + ' ' + objV[i].z + '\n';
#
#
#	objText += '\n# faces\n';
#	for i in range(0, objF.length):
#		faceString = 'f';
#		for j in range(0, objF[i].length):
#			faceString = faceString + ' ' + objF[i][j];
#
#		objText += faceString + '\n';
#
#	return objText;
#### js code
#"""
#Hexasphere.prototype.toObj = function() {
#
#    var objV = [];
#    var objF = [];
#    var objText = "# vertices \n";
#    var vertexIndexMap = {};
#
#    for(var i = 0; i< this.tiles.length; i++){
#        var t = this.tiles[i];
#
#        var F = []
#        for(var j = 0; j< t.boundary.length; j++){
#            var index = vertexIndexMap[t.boundary[j]];
#            if(index == undefined){
#                objV.push(t.boundary[j]);
#                index = objV.length;
#                vertexIndexMap[t.boundary[j]] = index;
#            }
#            F.push(index)
#        }
#
#        objF.push(F);
#    }
#
#    for(var i =0; i< objV.length; i++){
#        objText += 'v ' + objV[i].x + ' ' + objV[i].y + ' ' + objV[i].z + '\n';
#    }
#
#    objText += '\n# faces\n';
#    for(var i =0; i< objF.length; i++){
#        faceString = 'f';
#        for(var j = 0; j < objF[i].length; j++){
#            faceString = faceString + ' ' + objF[i][j];
#        }
#        objText += faceString + '\n';
#    }
#
#    return objText;
#}
#"""
####module.exports = Hexasphere;
