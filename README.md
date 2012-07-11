![FEZ Logo](http://i.imgur.com/YWPMM.png)


FEZ
=================

A lua library that helps you create component based projects.

-- Note --
The example in this branch is currently broken.
I'll try to get a fix up as soon as I can, meanwhile you can still use FEZ, the example should
still give you an idea of how the API works, hey you could event challenge yourself and try to get the 
example working! (Nah just kidding, i'll fix it.)

About
==========

Lua Entity System is a lua library to help you get started with component based programming.

In component based programming, entities are made up of components, the entity itself is just a number that identifies a collection of components.
The components hold the data and do the logic.

In the Lua Entity System, there are four kinds of components:
* Attributes
* Behaviours
* Controllers
* Renderers

Attributes hold data about an object and nothing else, they mainly consist of getters and setters to the data. Some attributes might do validation to the data or perform transformations. The point of the attribute is to separate data from logic.

Behaviours perform logic code, usually using the data from the entities attributes. Behaviours belong to an entity and that entity is passed to it's update method.

Controllers don't belong to any entity, you need to update controllers explicitly. Controllers have an updateEntity method which is by default run for every entity. Controllers can set a filter so they only perform logic on entities with the given components.

Renderers are the same as controllers, we just use this term to separate logic from rendering. 