![FEZ Logo](http://i.imgur.com/YWPMM.png)


FEZ
=================

A lua library that helps you create component based projects.


About
==========

Lua Entity System is a lua library to help you get started with component based programming.

In component based programming, entities are made up of components, the entity itself is just a number that identifies a collection of components.
The components hold the data and do the logic.

In the Lua Entity System, there are four kinds of classes:
* Attributes
* Aspects
* Controllers

Entities are simply a unique integer. FEZ has a class called EntityManager which you use to create new entities and to
tie attributes to entities.

Attributes are the components that make up your game objects. They are containers for data and nothing else. 

Aspects are a collection of attributes. When a new entity is created with a certain set of attributes it is added to the aspect.

Controllers contain all the logic of your game. You give controllers an aspect and they update all entities with this aspect.

Yak-Man Example
==========

To get a better idea about how FEZ works take a look a the Yak-Man Example.
You will need LÖVE to run the example, but just looking over the source can help.
You can download LÖVE at http://love2d.org
The example is a work in progress.