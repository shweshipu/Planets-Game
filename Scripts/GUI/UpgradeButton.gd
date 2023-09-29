extends Button
class_name UpgradeButton
"""
This class simultaneously functions as a button, linked list style node (it has a next), and a holder class for an upgrade
"""
#points to the next UpgradeButton in the upgrades heirarchy. This should be assigned in the inspector (yea i know i almost never use it but here it makes alot of sense)
var next:UpgradeButton
#holds an upgrade. This should be assigned in the inspector (yea i know i almost never use it but here it makes alot of sense)
var upgrade:Upgrade
#where we send upgrade too.
var manager:UpgradeManager
#is it enabled
var enabled:bool

#Override
func _button_pressed():
	#enable the next button and send our upgrade off to be used.
	self.next.activate()
	self.manager.takeNewUpgrade(self.upgrade)

func activate():
	self.enabled = true
