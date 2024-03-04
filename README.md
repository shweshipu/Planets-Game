# Planets-game
> Solo project from 2021-2022. I didn't know that i should have been using version control at the time. I really wish I had.

## What it looks like right now
![presentation gif](https://github.com/shweshipu/Planets-Game/blob/master/readme-assets/presentation.gif?raw=true)

## Postmortem
The goal of this project was to make a game similar to games from the [Sid Meier's Civilization](https://en.wikipedia.org/wiki/Civilization_(video_game)) series. <br>
The main difference being that instead of playing on a Hex grid map, It would be played on multiple [Goldberg polyhedra](https://en.wikipedia.org/wiki/Goldberg_polyhedron) acting as planets. As players progress, they would make it to other planets.

So far, only the goldberg polyhedra were implemented, mostly thanks to [this fine person's adaptation](https://github.com/Em3rgencyLT/Hexasphere) of [this other fine person's amazing code](https://github.com/arscan/hexasphere.js/). I just adapted it to GDScript. <br> 
I also made some precursor code laying out planned game mechanics.
Currently this project has been abandoned, but I may come back to it later.

What I learned from this project:
- exposure to javascript
- some of godot's graphic generating libraries
- version control's essentialness
- its very satisfying to make code where you can see the results in color

## Setup
This project uses [Godot Engine](https://godotengine.org/) version 3. 
To run it, open it with the godot engine.
Most of the code is in the [Scripts/Planet](https://github.com/shweshipu/Planets-Game/tree/master/Scripts/Planet) and [Scripts/Celestial](https://github.com/shweshipu/Planets-Game/tree/master/Scripts/Celestial) folders. Most of the other files in Scripts/ are just skeletons for future planned mechanics. <br>



## Other credits
Many assets were used under public domain licenses. most of them are in /addons/
