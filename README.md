![](http://i.imgur.com/reO20Eq.png)  

This repository aims to offer some initial tools that will allow testing features of the engine more easier. Unpack them on your host and access them from your application using the `Asset`  and `Web` classes.

# Tips

* Asset - Use this class in the `Load` method of the `Application` class.  
        It will load the asset and store its reference inside an  
        internal `Map<string,Resource>`  
  
* Web   - This class is used to load stuff and listen to a callback with progress and complete events.  
  
# Get Started

haxor_project_template.zip - This zip contains a FD project set so you can compile and play the most basic Haxor Application.

You can fetch it from here too: [http://goo.gl/KNtRaC]

# Resources

* Collada  - Loaded and converted to Entity instances.

* Material - Define properties of rendering like Z-Testing, Blending, Shaders, Uniform Variables,...

* Shader   - Subset of GLSL ES 1.0 scripts that handle the transformation of vertex and writing of pixels in the screen.
	   
* Skin     - Set of images used to create DOM user interfaces. (WIP)

# Folders @ [resources]

* [asset]    models and their textures to test the creation
            of static/animated renderers.

* [examples] projects and sources to run Haxor examples and learn about the features.

* [material] xml files that describes different type of materials. 

* [shader]   xml files that describes Vertex and Fragment shaders used by materials.

* [dom]      artwork for use in DOM elements targeted to UI implementation.

* [sound]    audio in mp3 and ogg formats to use in <audio> tags and in the future WebAudio API.

* [texture]  different type of images and cubemaps (texture XML file to describe wrapping and interpolation is WIP)
