# Planets-game
> Solo project from 2021-2022. The goal of this project was to make a game similar to games from the [Sid Meier's Civilization](https://en.wikipedia.org/wiki/Civilization_(video_game)) series. <br>
The main difference being that instead of playing on a Hex grid map, It would be played on multiple [Goldberg polyhedra](https://en.wikipedia.org/wiki/Goldberg_polyhedron) acting as planets. As players progress, they would make it to other planets.
> This project has been abandoned, but I may come back to it later.

## What it looks like right now
![presentation gif](https://github.com/shweshipu/Planets-Game/blob/master/readme-assets/presentation.gif?raw=true)

## Postmortem
So far, The planets and the ability to click tiles has been implemented. Next steps would be to add units to be placed on the tiles and implement the ability to move between tiles.
<br> 

What I learned from this project:
- exposure to javascript
- some of godot's graphic generating libraries
- version control's essentialness
- its very satisfying to make code where you can see the results in color

## Setup
This project uses [Godot Engine](https://godotengine.org/) version 3. 
To run it, open it with the godot engine.
Most of the important code is in the [Scripts/Planet](https://github.com/shweshipu/Planets-Game/tree/master/Scripts/Planet) and [Scripts/Celestial](https://github.com/shweshipu/Planets-Game/tree/master/Scripts/Celestial) folders. Most other files in Scripts/ are just skeletons for future planned mechanics. <br>



## Credits
I'm especially thankful to [this fine person's adaptation](https://github.com/Em3rgencyLT/Hexasphere) of [this other fine person's amazing code](https://github.com/arscan/hexasphere.js/). It sped up the process of implementing the planets so I only needed to adapt it to GDScript and fix any bugs that resulted.
Many assets were used under public domain licenses. most of them are in /addons/
