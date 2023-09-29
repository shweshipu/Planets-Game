extends Node
class_name UpgradeManager
"""
this class will keep track of what upgrades this player has gotten
frick how do i have things access thissssssss
"""

var upgradesList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func takeNewUpgrade(upgrade : Upgrade):
	self.upgradesList.append(upgrade)
	##do other stuff.
