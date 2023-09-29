#extends Reference
#
#"""
#var Point = require('./point');
#"""
#var centroid;
#var points;
#var id;
#var _faceCount = 0
#### js code
#"""
#var _faceCount = 0;
#"""
#
#func _init(point1, point2, point3, register):
#	self.id = _faceCount;
#	_faceCount+=1;
#
#	if(register == null):
#		register = true;
#
#	self.points = [
#		point1,
#		point2,
#		point3
#		];
#	if(register):
#		point1.registerFace(self);
#		point2.registerFace(self);
#		point3.registerFace(self);
#### js code
#"""
#var Face = function(point1, point2, point3, register){
#    this.id = _faceCount++;
#
#    if(register == undefined){
#        register = true;
#    }
#
#    this.points = [
#        point1,
#        point2,
#        point3
#        ];
#    if(register){
#        point1.registerFace(this);
#        point2.registerFace(this);
#        point3.registerFace(this);
#    }
#};
#"""
#
#func getOtherPoints(point1):
#	var other = [];
#	for i in range(0, len(self.points)):
#		if(self.points[i].toString() != point1.toString()):
#			other.append(self.points[i]);
#
#	return other;
#### js code
#"""
#Face.prototype.getOtherPoints = function(point1){
#    var other = [];
#    for(var i = 0; i < this.points.length; i++){
#        if(this.points[i].toString() !== point1.toString()){
#            other.push(this.points[i]);
#        }
#    }
#    return other;
#}
#"""
#func findThirdPoint(point1, point2):
#	for i in range(0, self.points.length):
#		if(self.points[i].toString() != point1.toString() && self.points[i].toString() != point2.toString()):
#			return self.points[i];
#
#### js code
#"""
#Face.prototype.findThirdPoint = function(point1, point2){
#    for(var i = 0; i < this.points.length; i++){
#        if(this.points[i].toString() !== point1.toString() && this.points[i].toString() !== point2.toString()){
#            return this.points[i];
#        }
#    }
#}
#"""
#
#func isAdjacentTo(face2):
#	# adjacent if 2 of the points are the same
#	var count = 0;
#	for i in range(0, len(self.points)):
#		for j in range(0, len(face2.points)):
#			##NOT ACTUALLY DIFFERENT AAAAA
#			## compare by value instead? or by reference? i think its by value originally anyway 
#			if(self.points[i].compareTo(face2.points[j])):#self.points[i].toString() == face2.points[j].toString()):
#				count+=1;
#	return (count == 2);
#### js code
#"""
#Face.prototype.isAdjacentTo = function(face2){
#    // adjacent if 2 of the points are the same
#
#    var count = 0;
#    for(var i = 0; i< this.points.length; i++){
#        for(var j =0 ; j< face2.points.length; j++){
#            if(this.points[i].toString() == face2.points[j].toString()){
#                count++;
#
#            }
#        }
#    }
#
#    return (count == 2);
#}
#"""
#
#func getCentroid(clear): ##just set it to false for undefined
#	if(self.centroid && !clear):
#		return self.centroid;
#
#	var ax = (self.points[0].x + self.points[1].x + self.points[2].x)/3.0;
#	var ay = (self.points[0].y + self.points[1].y + self.points[2].y)/3.0;
#	var az = (self.points[0].z + self.points[1].z + self.points[2].z)/3.0;
#
#	var acentroid = load("res://Scripts/Hex_Sphere/Point.gd").new(ax,ay,az);
#
#	self.centroid = acentroid;
#
#	return acentroid;
#
#### js code
#"""
#Face.prototype.getCentroid = function(clear){
#    if(this.centroid && !clear){
#        return this.centroid;
#    }
#
#    var x = (this.points[0].x + this.points[1].x + this.points[2].x)/3;
#    var y = (this.points[0].y + this.points[1].y + this.points[2].y)/3;
#    var z = (this.points[0].z + this.points[1].z + this.points[2].z)/3;
#
#    var centroid = new Point(x,y,z);
#
#    this.centroid = centroid;
#
#    return centroid;
#
#}
#"""
####module.exports = Face;
#func _to_string():
#	#return('Points:\n'+ str(self.points[0].toString())+'\n'+str(self.points[1].toString()) +'\n'+str(self.points[2].toString())+'\ncentroid:\n'+str(self.centroid)+'\n')
#	return('centroid:\n'+str(getCentroid(false))+'\n')
