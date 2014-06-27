package webgl;
import haxor.component.Camera;
import haxor.component.MeshRenderer;
import haxor.component.ParticleRenderer;
import haxor.core.Application;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.Entity;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.editor.Gizmo;
import haxor.graphics.BlendMode;
import haxor.graphics.CullMode;
import haxor.graphics.Material;
import haxor.graphics.MeshTemplate.Mesh3;
import haxor.importer.ColladaFile;
import haxor.input.Input;
import haxor.input.KeyCode;
import haxor.math.Color;
import haxor.math.Mathf;
import haxor.math.Quaternion;
import haxor.math.Vector3;
import haxor.texture.Texture.TextureFormat;
import haxor.texture.Texture2D;
import js.Browser;
import js.html.ButtonElement;
import js.html.Element;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Shows a simple particle emitter.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class Particles extends Application implements IUpdateable
{
	
	var asset : Entity;
	
	var particle : ParticleRenderer;
	
	var angle : Float;
	
	/**
	 * Loads the basic 'Flat' shader.
	 */
	override function Load():Void 
	{		
		//Loads the shader 'Particle' and stores it in the id 'haxor/unlit/Particle'
		Asset.LoadShader("haxor/unlit/Particle","http://haxor.thelaborat.org/resources/shader/unlit/Particle.shader");
		
		//Loads the ImageElement 'particle.png' and stores it as a TextureHTML in 'particle'
		Asset.LoadTextureHTML("particle", "http://haxor.thelaborat.org/resources/texture/particle/particle.png");
		
	}
	
	/**
	 * Method called after the load of the assets.
	 */
	override function Initialize():Void 
	{
		trace("Particles> Initialize");
		
		var field : Element = Browser.document.getElementById("field");
		
		
		angle = 0.0;
		
		
		//'GetAsset()' will effectively create the instance.
		asset = new Entity();
		asset.name = "emitter";
		
		//Creates the particle renderer
		particle = asset.AddComponent(ParticleRenderer);
				
		//Creates a spherical emitter.
		var sphere_emitter : SphereEmitter = cast particle.emitter = new SphereEmitter(2.0);
		
		//Flag that tells if the starting velocity will be random or from center out.
		sphere_emitter.random = false;
		
		//Flag that tells if new particles are spawned from the emitter surface or interior.
		sphere_emitter.surface = false;
		
		//XYZ intervals that tells the velocity limits of the particle
		//For instance, with this attribute, it is possible to make a particle only move upwards by setting [0,0,0,1000,0,0].
		sphere_emitter.ranges = [ -1000, 1000, -1000,  1000, -1000, 1000];
		
		//Tells the max number of particles
		particle.count = 2300;
		
		field.innerText = "Hit SPACE to emit 200 particles!\nTotal "+particle.count+" particles.";
		
		//Particles emitted per second
		particle.rate.start = particle.rate.end = 50;
		
		//This particle attribute tells  that the particle will start with size 0.0 and increase until 0.8 with an easing of t ^ 2.0
		particle.life.size.start = new Vector3(0.1,0.1,0.1);
		particle.life.size.end   = new Vector3(1.5,1.5,1.5);
		particle.life.size.curve = 2.0;
		
		
		
		//Flag that tells if the particles are bound by the emitter Transform
		//If 'false' if the emitter moves after the particle shows, the particle will keep going without being affected by the emitter.
		particle.local = false;
		
		//The emitter will keep launching particles
		particle.loop = true;
		
		//The particles will always face camera
		particle.billboard = true;
		
		//Particle will start with lifetime between 'start' and 'end' seconds
		particle.start.life.start    = 0.1;
		particle.start.life.end      = 6.0;
		particle.start.life.random   = true;
		
		//Particle will start with speed multiplier between 'start' and 'end'
		particle.start.speed.start   = 1.0;
		particle.start.speed.end     = 3.0;
		particle.start.speed.random   = true;
		
		
		//Some gravity
		particle.force = new Vector3(0, -1.0, 0);
		
		//Yes you can create textures and manipulate pixels :)
		var color_fade : Texture2D = new Texture2D(4, 1, TextureFormat.RGBA8);
		
		//Sets the pixels
		color_fade.SetPixels([Color.white, Color.yellow, Color.red, Color.empty]);
		
		//Send changes to GPU
		color_fade.Apply();
		
		//Passes the color gradient that will be used to set the particle color over life
		particle.life.color = color_fade;
		
		
		//starts emitting
		particle.Play();
		
		//Creates a material that handles rendering information like shader, depth test, render queue.
		var mat : Material = new Material();
		mat.name 	= "ParticleAdditive";
		mat.shader  = Asset.Get("haxor/unlit/Particle"); 			//Gets the shader loaded in the 'Load' method		
		mat.SetUniform("Texture", Asset.Get("particle")); 			//Sets the 'DiffuseTexture' Uniform to the loaded texture.
		mat.SetBlending(BlendMode.One, BlendMode.One);				//Additive blending
		mat.zwrite = false;											//Disable ZWrite so particles blend with each other
		
		//Sets the material
		particle.material = mat;
		
		
		//Creates an entity and adds a camera in it
		//It is necessary to have at least one camera in the scene
		var cam : Camera = (new Entity()).AddComponent(Camera);
		
		//Sets the clear color
		cam.background = new Color(0.1, 0.1, 0.1);
		
		//moves the camera slightly back so we can see the triangle
		cam.transform.position = new Vector3(0, 0.0, 8.0);
		
		
		cam.LookAt(Vector3.zero);
		
		//Default FPS = 45
		fps = 60;
		
		Gizmo.particles = true;
		
		//Register the interface IUpdateable in the execution pool.
		Engine.Add(this);		
	}
	
	/**
	 * Execution loop.
	 */
	public function OnUpdate():Void
	{		
		angle += Time.deltaTime * 45.0;		
		var s : Float = Mathf.Sin(angle * Mathf.Deg2Rad);
		asset.transform.position = Vector3.Lerp(new Vector3( -2, 0, 0), new Vector3(2, 0, 0), s);
		
		if (Input.Hit(KeyCode.Space))
		{
			particle.Emit(200.0);
		}
		
		//If the queue is full it is necessary to make more room, reseting the pool.
		if (particle.emitted >= particle.count) particle.Reset();
	}
	
}