
"""
Static class to hold the solar calculation function.

this function tells how much to modify energy gotten by sun based on the building's Latitude (North-South)
"""
static func calcSolarAmount(latitude: float):
	#reduce sunlight amount based on latitude, but keep it at least 0.15 for gameplay
	return max(sin(deg2rad(90-latitude)),0.15)
	##90 degrees lat = poles (no light hit surface
	##0 degrees lat = equator (100% light hit surface)
	#i could probably use cos() instead but whatever i already did the math
