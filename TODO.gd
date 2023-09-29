"""
TODO


~~~Reduce Lag in planet generation~~~
this can be done by saving the coords of the points and the tiles and the hexasphere as a json, 
then loading those when constructing planets.

have one for each division up to 32. maybe i could go as high as 40.

ideally i would want to append the drawhexasphere script to just check if a json exists, and load from that instead. 
if not, just save it after. that way i dont have to deal with it.

atm it needs the toJson functions finished
as well as a load_hexasphere_json() function to be created.
and a short save_hex_json() function in drawhexasphere to be created.

im a bit lazy atm though so i wanna work on other things first



~~~ make tiles have color/texture? ~~~ CHECK
how do? is there a way to do it better?


~~~ Make a ui ~~~


~~~camera zoom out and above~~~
uwu
May not be doing this feature

~~~Unit.gd~~~
make it move tiles, prolly fairly easy? idk tho. <- use Astar for pathfinding
make it have collision for clicking? <- finish planet collider

~~~ui for buttons for next turn and stuff~~~
1priority
"""
