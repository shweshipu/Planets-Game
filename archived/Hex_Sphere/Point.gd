#extends Reference
#
#var x
#var y
#var z
#var faces
#
#
#func _init(new_x,new_y,new_z):
#	if(new_x != null && new_y != null && new_z != null):
#		self.x = new_x#format(x,".3f");#.toFixed(3); ##this just rounds them? do i need it? format doesnt seem to exist in godot
#		self.y = new_y#format(y,".3f");#.toFixed(3);
#		self.z = new_z#format(z,".3f");#.toFixed(3);
#	self.faces = [];
#
#
#
#### js code
#"""
#var Point = function(x,y,z){
#    if(x !== undefined && y !== undefined && z !== undefined){
#        this.x = x.toFixed(3);
#        this.y = y.toFixed(3);
#        this.z = z.toFixed(3);
#    }
#
#    this.faces = [];
#}
#"""
#
#func subdivide(point, count, mySphere): #checkPoint):
#	var segments = []
#	segments.append(self)
#	count = float(count) ##JS DOESNT DO INT DIVISION BY DEFAULT
#	for i in range(1, count): 
#		var np = load("res://Scripts/Hex_Sphere/Point.gd").new(self.x * (1-(i/count)) + point.x * (i/count),
#		 self.y * (1-(i/count)) + point.y * (i/count), 
#		 self.z * (1-(i/count)) + point.z * (i/count));
#		np = mySphere.getPointIfExists(np);#load("res://Scripts/Hex_Sphere/Hexasphere.gd").getPointIfExists(np); ## was checkPoint(np) //passed function?
#		segments.append(np);
#	segments.append(point);
#	return segments;
#
#### js code
#"""
#Point.prototype.subdivide = function(point, count, checkPoint){
#
#    var segments = [];
#    segments.push(this);
#
#    for(var i = 1; i< count; i++){
#        var np = new Point(this.x * (1-(i/count)) + point.x * (i/count),
#            this.y * (1-(i/count)) + point.y * (i/count),
#            this.z * (1-(i/count)) + point.z * (i/count));
#        np = checkPoint(np);
#        segments.push(np);
#    }
#
#    segments.push(point);
#
#    return segments;
#
#}
#"""
#func segment(point, percent):
#	percent = max(0.01, min(1, percent));
#	var ax = point.x * (1-percent) + self.x * percent;
#	var ay = point.y * (1-percent) + self.y * percent;
#	var az = point.z * (1-percent) + self.z * percent;
#
#	var newPoint = load("res://Scripts/Hex_Sphere/Point.gd").new(ax,ay,az);
#	return newPoint;
#### js code
#"""
#Point.prototype.segment = function(point, percent){
#    percent = Math.max(0.01, Math.min(1, percent));
#
#    var x = point.x * (1-percent) + this.x * percent;
#    var y = point.y * (1-percent) + this.y * percent;
#    var z = point.z * (1-percent) + this.z * percent;
#
#    var newPoint = new Point(x,y,z);
#    return newPoint;
#
#};
#"""
#func midpoint(point, location):
#	return self.segment(point, .5);
#### js code
#"""
#Point.prototype.midpoint = function(point, location){
#    return this.segment(point, .5);
#}
#"""
#
#func project(radius, percent):
#	if(percent == null):
#		percent = 1.0;
#	percent = max(0, min(1, percent));
#	##wth are these even here for? they arent used???? they cause div by zero error???
#	"""
#	var yx = self.y / self.x;
#	var zx = self.z / self.x;
#	var yz = self.z / self.y;
#	"""
#	var mag = sqrt(pow(self.x, 2) + pow(self.y, 2) + pow(self.z, 2));
#	var ratio = float(radius)/ mag;
#
#	self.x = self.x * ratio * percent;
#	self.y = self.y * ratio * percent;
#	self.z = self.z * ratio * percent;
#	return self;
#### js code
#"""
#Point.prototype.project = function(radius, percent){
#    if(percent == undefined){
#        percent = 1.0;
#    }
#
#    percent = Math.max(0, Math.min(1, percent));
#    var yx = this.y / this.x;
#    var zx = this.z / this.x;
#    var yz = this.z / this.y;
#
#    var mag = Math.sqrt(Math.pow(this.x, 2) + Math.pow(this.y, 2) + Math.pow(this.z, 2));
#    var ratio = radius/ mag;
#
#    this.x = this.x * ratio * percent;
#    this.y = this.y * ratio * percent;
#    this.z = this.z * ratio * percent;
#    return this;
#
#};
#"""
#func registerFace(face):
#	self.faces.append(face);
#### js code
#"""
#Point.prototype.registerFace = function(face){
#    this.faces.push(face);
#}
#"""
#func getOrderedFaces():
#	var workingArray = faces.duplicate(true); ### just instance a copy (NOT REFERENCE!!) of the array #self.faces.slice();
#	var ret = [];
#
#	var i = 0;
#	print("length of centerpoint's ordered faces is ",len(self.faces))
#	print("faces are: ", printFaces());
#	while(i < len(self.faces)):
#		#print("hewowow ",i)
#		if(i == 0):
#
#			ret.append(workingArray[i]);
#			workingArray.remove(i); #.splice(i,1); ### remove at index i
#		else:
#			var hit = false;
#			var j = 0;
#			print("len(workingArray)=",len(workingArray))
#			while(j < len(workingArray) && !hit):
#				print( "i:", i, " j:", j)
#				if(workingArray[j].isAdjacentTo(ret[i-1])): ##why does this error? when is it supposed to be adjacent to
#					print("it was adjacent")
#					hit = true;
#					ret.append(workingArray[j]);
#					workingArray.remove(j)#.splice(j, 1);
#				j+=1;
#
#
#		i+=1;
#
#	return ret;
#
#
#
##yet another godot fix attempt kinda. ##nevermind the godot's duplicate isnt the bug. also this isnt the rounding error cause?
#func copyFaces():
#	var newFaceArray = []
#	for i in range(len(self.faces)):
#		newFaceArray.append(load("res://Scripts/Hex_Sphere/Face.gd").new(faces[i].points[0],faces[i].points[1],faces[i].points[2],false)) #DO NOT HAVE POINTS REGISTER THESE	
#	return newFaceArray
#func JSIndex(array, index): #IS THIS EVEN IT???????????? #####GET ORDERED FACES HAS ERROR?
#	#Javescript doesnt have index out of bounds errors on arrays, so this adapts it.
#	#print("CHECKING EEEEE")
#	if(index<len(array)):
#		#print("SENDING INDEX thing")
#		return array[index];
#	else:
#		#print("NULL BRO")
#		return null;
#### js code
#"""
#Point.prototype.getOrderedFaces = function(){
#    var workingArray = this.faces.slice();
#    var ret = [];
#
#    var i = 0;
#    while(i < this.faces.length){
#        if(i == 0){
#            ret.push(workingArray[i]);
#            workingArray.splice(i,1);
#        } else {
#            var hit = false;
#            var j = 0;
#            while(j < workingArray.length && !hit){
#                if(workingArray[j].isAdjacentTo(ret[i-1])){
#                    hit = true;
#                    ret.push(workingArray[j]);
#                    workingArray.splice(j, 1);
#                }
#                j++;
#            }
#        }
#        i++;
#    }
#
#    return ret;
#}
#"""
#
#func findCommonFace(other, notThisFace):
#	for i in range(0,self.faces.length):
#		for j in range(0, other.faces.length):
#			if(self.faces[i].id == other.faces[j].id && self.faces[i].id != notThisFace.id):
#				return self.faces[i];
#	return null;
#### js code
#"""
#Point.prototype.findCommonFace = function(other, notThisFace){
#    for(var i = 0; i< this.faces.length; i++){
#        for(var j = 0; j< other.faces.length; j++){
#            if(this.faces[i].id === other.faces[j].id && this.faces[i].id !== notThisFace.id){
#                return this.faces[i];
#            }
#        }
#    }
#
#    return null;
#}
#"""
#func toJson():
#	return [self.x, self.y, self.z]
#### js code
#"""
#Point.prototype.toJson = function(){
#    return {
#        x: this.x,
#        y: this.y,
#        z: this.z
#    };
#}
#"""
#
#func toString():
#	return '(' + str(self.x) + ',' + str(self.y) + ',' + str(self.z) + ')';
#### js code
#"""
#Point.prototype.toString = function(){
#    return '' + this.x + ',' + this.y + ',' + this.z;
#}
#"""
#### not necessary in godot
##module.exports = Point;
#func _to_string():
#	return toString()
#
#####made to do value comparison instead of reference, which was toString()'s purpose
##compare two points
#func compareTo(other):
#	var isSame = false
#	#print("comparing:(", self.x,",",self.y,",",self.z,") with (",other.x,",",other.y,",",other.z,")")
#	if(self.x == other.x && self.y == other.y && self.z == other.z): #(self.x < other.x *1.01 && self.x > other.x*0.99) && (self.y < other.y*1.01 && self.y > other.y*0.99) && (self.z < other.z*1.01 && self.z > other.z*0.99)
#		isSame = true
#	#if(self.faces == other.faces): ##gdscript is wierd and only does non-reference comparison on arrays
#	#	isSame = true
#	#if(self.x < other.x *1.05 && self.x > other.x*0.95) && (self.y < other.y*1.05 && self.y > other.y*0.95) && (self.z < other.z*1.05 && self.z > other.z*0.95):
#	#	isSame = true
#	return isSame 
#
####also made by shwesh
#func printFaces():
#	var ret = ""
#	for face in self.faces:
#		ret = ret + str(face)
#	return ret
