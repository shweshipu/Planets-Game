#extends Reference
#
#var hexSize
#
#var centerPoint
#var faces 
#var boundary
#var neighborIds # this holds the centerpoints, will resolve to references after
#var neighbors # this is filled in after all the tiles have been created
#
#
#
#
#### not necessary in godot
##var Point = require('./point');
#
#func vector(p1, p2):
#	return Vector3(p2.x-p1.x,p2.y-p1.y,p2.z-p1.z);
#### js code
#"""
#function vector(p1, p2){
#    return {
#        x: p2.x - p1.x,
#        y: p2.y - p1.y,
#        z: p2.z - p1.z
#    }
#
#}
#"""
#
#func calculateSurfaceNormal(p1,p2,p3):
#
#	var U = vector(p1, p2)
#	var V = vector(p1, p3)
#
#	var N = Vector3(
#		U.y * V.z - U.z * V.y,
#		U.z * V.x - U.x * V.z,
#		U.x * V.y - U.y * V.x
#	)
#	return N;
#
#	##I decided to just use the godot implementation
#	#var P = Plane(p1,p2,p3);
#	#return P.normal;
#
#### js code
#"""
#// https://www.khronos.org/opengl/wiki/Calculating_a_Surface_Normal
#// Set Vector U to (Triangle.p2 minus Triangle.p1)
#// Set Vector V to (Triangle.p3 minus Triangle.p1)
#// Set Normal.x to (multiply U.y by V.z) minus (multiply U.z by V.y)
#// Set Normal.y to (multiply U.z by V.x) minus (multiply U.x by V.z)
#// Set Normal.z to (multiply U.x by V.y) minus (multiply U.y by V.x)
#function calculateSurfaceNormal(p1, p2, p3){
#
#    U = vector(p1, p2)
#    V = vector(p1, p3)
#
#    N = {
#        x: U.y * V.z - U.z * V.y,
#        y: U.z * V.x - U.x * V.z,
#        z: U.x * V.y - U.y * V.x
#    };
#
#    return N;
#
#}
#"""
#
#func pointingAwayFromOrigin(p,v):
#	return ((p.x * v.x) >= 0) && ((p.y * v.y) >= 0) && ((p.z * v.z) >= 0)
#### js code
#"""
#function pointingAwayFromOrigin(p, v){
#    return ((p.x * v.x) >= 0) && ((p.y * v.y) >= 0) && ((p.z * v.z) >= 0)
#}
#"""
#
#func normalizeVector(v):
#	var m = sqrt((v.x * v.x) + (v.y * v.y) + (v.z * v.z));
#	return [(v.x/m),(v.y/m),(v.z/m)]
#
#### js code
#"""
#function normalizeVector(v){
#    var m = Math.sqrt((v.x * v.x) + (v.y * v.y) + (v.z * v.z));
#
#    return {
#        x: (v.x/m),
#        y: (v.y/m),
#        z: (v.z/m)
#    };
#
#}
#"""
#
#func _init(newCenterPoint, newHexSize):
#	if(newHexSize == null):#undefined):
#		newHexSize = 1;
#
#	hexSize = max(.01, min(1.0, newHexSize));
#
#	self.centerPoint = newCenterPoint;
#	self.faces = centerPoint.getOrderedFaces();
#	self.boundary = [];
#	self.neighborIds = []; # this holds the centerpoints, will resolve to references after
#	self.neighbors = []; # this is filled in after all the tiles have been created
#
#	var neighborHash = {};
#	for f in range(0, len(self.faces)):
#		print("len of tile's faces is ",len(self.faces))
#		#print(f, "= hewo")
#		# build boundary
#		self.boundary.append(self.faces[f].getCentroid(false).segment(self.centerPoint, hexSize));
#		print(self.faces[f].getCentroid(false).segment(self.centerPoint, hexSize).toString())
#		# get neighboring tiles
#		var otherPoints = self.faces[f].getOtherPoints(self.centerPoint);
#		for o in range(0,2):
#			neighborHash[otherPoints[o]] = 1;
#
#	self.neighborIds = neighborHash;
#
#	# Some of the faces are pointing in the wrong direction
#	# Fix this.  Should be a better way of handling it
#	# than flipping them around afterwards
#
#	###print(len(boundary));
#	## i think it might be funky js index out of bounds stuff? if so this is a solution
#	#if(len(boundary) >=4): bruh past me just put off a bug lmao
#
#	var normal = calculateSurfaceNormal(self.boundary[1], self.boundary[2], self.boundary[3]);
#
#	if(!pointingAwayFromOrigin(self.centerPoint, normal)):
#			self.boundary.invert()##self.boundary.reverse();
#	#else:
#		 #self.boundary.invert()##self.boundary.reverse();
#
#### js code
#"""
#var Tile = function(centerPoint, hexSize){
#
#    if(hexSize == undefined){
#        hexSize = 1;
#    }
#
#    hexSize = Math.max(.01, Math.min(1.0, hexSize));
#
#    this.centerPoint = centerPoint;
#    this.faces = centerPoint.getOrderedFaces();
#    this.boundary = [];
#    this.neighborIds = []; // this holds the centerpoints, will resolve to references after
#    this.neighbors = []; // this is filled in after all the tiles have been created
#
#    var neighborHash = {};
#    for(var f=0; f< this.faces.length; f++){
#        // build boundary
#        this.boundary.push(this.faces[f].getCentroid().segment(this.centerPoint, hexSize));
#
#        // get neighboring tiles
#        var otherPoints = this.faces[f].getOtherPoints(this.centerPoint);
#        for(var o = 0; o < 2; o++){
#            neighborHash[otherPoints[o]] = 1;
#        }
#
#    }
#
#    this.neighborIds = Object.keys(neighborHash);
#
#    // Some of the faces are pointing in the wrong direction
#    // Fix this.  Should be a better way of handling it
#    // than flipping them around afterwards
#
#    var normal = calculateSurfaceNormal(this.boundary[1], this.boundary[2], this.boundary[3]);
#
#    if(!pointingAwayFromOrigin(this.centerPoint, normal)){
#        this.boundary.reverse();
#    }
#
#
#
#};
#"""
#
#func getLatLon(radius, boundaryNum):
#	var point = self.centerPoint;
#	if((typeof(boundaryNum) == TYPE_INT || typeof(boundaryNum) == TYPE_REAL) && boundaryNum < self.boundary.length):
#		point = self.boundary[boundaryNum];
#	var phi = acos(float(point.y) / radius); #lat 
#	var theta = fposmod((atan2(point.x, point.z) + PI + PI / 2) , (PI * 2)) - PI; # lon
#
#	# theta is a hack, since I want to rotate by Math.PI/2 to start.  sorryyyyyyyyyyy
#	return (Vector2(180 * phi / PI - 90, 180 * theta / PI )) #Lat,Lon
#
#### js code
#"""
#Tile.prototype.getLatLon = function(radius, boundaryNum){
#    var point = this.centerPoint;
#    if(typeof boundaryNum == "number" && boundaryNum < this.boundary.length){
#        point = this.boundary[boundaryNum];
#    }
#    var phi = Math.acos(point.y / radius); //lat 
#    var theta = (Math.atan2(point.x, point.z) + Math.PI + Math.PI / 2) % (Math.PI * 2) - Math.PI; // lon
#
#    // theta is a hack, since I want to rotate by Math.PI/2 to start.  sorryyyyyyyyyyy
#    return {
#        lat: 180 * phi / Math.PI - 90,
#        lon: 180 * theta / Math.PI
#    };
#};
#"""
#
#func scaledBoundary(scale):
#	scale = max(0, min(1, scale));
#
#	var ret = [];
#	for i in range(0,self.boundary.length):
#		ret.push(self.centerPoint.segment(self.boundary[i], 1 - scale));
#
#	return ret;
#### js code
#"""
#Tile.prototype.scaledBoundary = function(scale){
#
#    scale = Math.max(0, Math.min(1, scale));
#
#    var ret = [];
#    for(var i = 0; i < this.boundary.length; i++){
#        ret.push(this.centerPoint.segment(this.boundary[i], 1 - scale));
#    }
#
#    return ret;
#};
#"""
#
#func toJson():
#	# this.centerPoint = centerPoint;
#	# this.faces = centerPoint.getOrderedFaces();
#	# this.boundary = [];
#	var boundary2 = [];
#	for i in range(0, boundary.length):
#			boundary2.push(self.boundary[i].point.toJson());
#	return {
#		centerPoint: self.centerPoint.toJson(),
#		boundary: boundary2
#			};	
#
#### js code
#"""
#Tile.prototype.toJson = function(){
#    // this.centerPoint = centerPoint;
#    // this.faces = centerPoint.getOrderedFaces();
#    // this.boundary = [];
#    return {
#        centerPoint: this.centerPoint.toJson(),
#        boundary: this.boundary.map(function(point){return point.toJson()})
#    };
#
#}
#"""
#func toString():
#	return self.centerPoint.toString();
#### js code
#"""
#Tile.prototype.toString = function(){
#    return this.centerPoint.toString();
#};
#"""
#
####module.exports = Tile;
