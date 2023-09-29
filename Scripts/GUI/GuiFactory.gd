extends Node
class_name GuiFactory

var subGuiFactDict = \
	{ #if you need to add a new thing, you can prolly append it here, or make a custom GUIFactory(not sub) that delegates differently
		"A_Unit" : preload("res://Scripts/GUI/SubGuiFactories/GuiUnitFact.gd"),
		"A_Vessel" : preload("res://Scripts/GUI/SubGuiFactories/GuiVesselFact.gd"), 
		"Rocket" : preload("res://Scripts/GUI/SubGuiFactories/GuiRocketFact.gd"),
		"A_Building" : preload("res://Scripts/GUI/SubGuiFactories/GuiBuildingFact.gd"),
		"A_SpaceConstruct" : preload("res://Scripts/GUI/SubGuiFactories/GuiSpaceConstructFact.gd"),
	}


func get_gui_popup(object : Node) :#-> ?: 
	"""
	pulls up the appropriate menu depending on what 3d object the user clicked on screen. 
	(button clicks are not handled here, just the mouse raycasts)
	"""
	if(not subGuiFactDict.has(object.get_class())):
		print ("Theres no gui factory for the clicked object!!!")
		return null
	#deligates the job to the subfactories
	subGuiFactDict[object.get_class()].get_gui_popup()
