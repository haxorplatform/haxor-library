package webgl;
import haxor.component.Animation;
import haxor.component.AnimationClip;
import haxor.component.Camera;
import haxor.component.CameraOrbit;
import haxor.component.Component;
import haxor.component.Light;
import haxor.component.MeshRenderer;
import haxor.component.SkinnedMeshRenderer;
import haxor.core.Application;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.Entity;
import haxor.core.IRenderable;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.editor.Gizmo;
import haxor.graphics.BlendMode;
import haxor.graphics.CullMode;
import haxor.graphics.Material;
import haxor.graphics.MeshTemplate.Mesh3;
import haxor.graphics.RenderQueue;
import haxor.graphics.Shader;
import haxor.importer.ColladaFile;
import haxor.input.Input;
import haxor.input.KeyCode;
import haxor.math.Color;
import haxor.math.Mathf;
import haxor.math.Quaternion;
import haxor.math.Vector3;
import js.Browser;
import js.html.ButtonElement;
import js.html.Element;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Loads a ColladaFile with the model and other Colladas with the animations.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class SkinningAnimationOrbit extends Application implements IUpdateable implements IRenderable
{
	
	var character : Entity;
	
	var character_animation : Animation;
	
	var angle : Float;
	
	var field : Element;
	
	var orbit : CameraOrbit;
	
	var characters : Array<SkinnedMeshRenderer>;
	
	var render_clock : Float;
	
	var render_fps : Float;
	
	var render_count : Float;
	
	var visible_count : Float;
	
	/**
	 * Loads the basic 'Flat' shader.
	 */
	override function Load():Void 
	{		
		//Loads the shader 'FlatTextureSkin' and stores it in the id 'haxor/unlit/FlatTextureSkin'
		
		//========================
		//The 'Skin' part is very important because this shader is responsible by applying the joints transforms to the vertexes.
		//========================
		Asset.LoadShader("haxor/unlit/FlatTextureSkin", "http://haxor.thelaborat.org/resources/shader/unlit/FlatTextureSkin.shader");
		
		//Loads the texture
		Asset.LoadTextureHTML("character_diffuse", "http://haxor.thelaborat.org/resources/character/skeleton/grunt/DiffuseTexture.png");
		
		//Loads the mesh and hierarchy of the character
		Asset.LoadCollada("character", "http://haxor.thelaborat.org/resources/character/skeleton/grunt/model.DAE");
		
		//Loads the clips of animation.
		//Each clip is a sequence of position,scale,rotation that moves the character joints
		//Asset.LoadCollada("character_idle01", "http://haxor.thelaborat.org/resources/character/skeleton/grunt/animation_idle01.DAE");
		//Asset.LoadCollada("character_idle02", "http://haxor.thelaborat.org/resources/character/skeleton/grunt/animation_idle02.DAE");
		Asset.LoadCollada("character_run",    "http://haxor.thelaborat.org/resources/character/skeleton/grunt/animation_run.DAE");
		
	}
	
	/**
	 * Method called after the load of the assets.
	 */
	override function Initialize():Void 
	{
		trace("SkinningAnimationOrbit> Initialize");
				
		characters = [];
		
		field  = cast Browser.document.getElementById("field");		
	
		render_clock = 0.0;
		render_fps = 0.0;
		
		visible_count = 1.0;
		
		angle = 0.0;
		
		var collada_animation : ColladaFile;				
		collada_animation = Asset.Get("character_run");
		
		var character_shader : Shader = Asset.Get("haxor/unlit/FlatTextureSkin");
		
		var mat_diffuse : Material;
		var mat_transparent : Material;
		
		//Creates a material that handles rendering information like shader, depth test, render queue.
		var mat : Material;
				
		mat = new Material();
		mat.name 	= "AssetMaterialOpaque";
		mat.shader  = character_shader; 									//Gets the shader loaded in the 'Load' method		
		mat.SetUniform("DiffuseTexture", Asset.Get("character_diffuse")); 	//Sets the 'DiffuseTexture' Uniform to the loaded texture.
		mat.SetUniform("Tint", Color.white);
		
						
		//Sets the material
		mat_diffuse = mat;
		
		
		mat = new Material();
		mat.name 	= "AssetMaterialTransparent";
		mat.shader  = character_shader; 									//Gets the shader loaded in the 'Load' method		
		mat.SetUniform("DiffuseTexture", Asset.Get("character_diffuse")); 	//Sets the 'DiffuseTexture' Uniform to the loaded texture.
		mat.SetBlending(BlendMode.SrcAlpha, BlendMode.OneMinusSrcAlpha);    //Alpha Blend flags
		mat.SetUniform("Tint", Color.white);
		mat.queue   = RenderQueue.Transparent;								//Sets the render order to one of the last queues to allow the transparent stuff blend with the background
			
			
			
		//Sets the material
		mat_transparent = mat;
		
		
		for (i in 0...80)
		{
		
			//Loading of collada files results in a 'ColladaFile' instance
			//This class stores information without creating the 'Entity' instance.
			var cf : ColladaFile = Asset.Get("character");
			
			//'GetAsset()' will effectively create the instance.
			character = new Entity();
			
			character = cf.GetAsset();
			character.name = "asset";
			
			
			//Scales the character down
			character.transform.scale = new Vector3(0.002, 0.002, 0.002);
			
			var px : Float = ((i % 10) * 0.2)-1.0;
			var pz : Float = (Mathf.Floor(i / 10) * 0.2)-1.0;
			
			character.transform.position = new Vector3(px,0,pz);
			
			collada_animation.AddAnimations(character);
			
			//Equivalent to '.GetComponent(Animation)'
			character_animation = character.animation;
			
			for (i in 0...character_animation.clips.length)
			{
				var c : AnimationClip = character_animation.clips[i];
				trace("SkinningAnimation> Clip[" + i + "] = " + c.name);			
				//Tells that the clip will keep repeating the animation
				c.wrap = AnimationWrap.Loop;
				c.name = "clip" + i;	
				c.speed = Mathf.Lerp(0.9, 1.1, Math.random());
				character_animation.Play(c);
			}
			
			
			
			//Searches in the hierarchy for the occurrences of the 'MeshRenderer' component.
			var mrl : Array<Component> = character.GetComponentsInChildren(SkinnedMeshRenderer);
			
			//The renderer needed for skinning is this one.
			var mr : SkinnedMeshRenderer;
			
			//First MeshRenderer = body (opaque material)
			mr = cast mrl[0];
			
			characters.push(mr);
			
							
			//Sets the material
			mr.material = mat_diffuse;
			
			//Second renderer = eyes (transparent)
			mr = cast mrl[1];
			
			mr.enabled = false;
			
			//Sets the material
			mr.material = mat_transparent;
		
		}
		
		//Creates an entity and adds a camera in it
		//It is necessary to have at least one camera in the scene
		var cam : Camera;
		
		orbit = CameraOrbit.Create(3.0, 0, 0);
		
		var ci : CameraOrbitInput = orbit.AddComponent(CameraOrbitInput);
		ci.zoomSpeed = 0.1;
		
		cam = orbit.camera;
		
		//Sets the clear color
		cam.background = new Color(0, 0, 0);
			
		cam.near = 0.01;
		cam.far = 50.0;
		
		
		//Default FPS = 45
		fps = 60;
		
		//Register the interface IUpdateable in the execution pool.
		Engine.Add(this);		
	}
	
	public function OnRender():Void
	{
		render_count++;
	}
	
	
	/**
	 * Execution loop.
	 */
	public function OnUpdate():Void
	{	
		visible_count = Mathf.Clamp(visible_count, 0, characters.length);
		
		var vc : Int = cast Mathf.Floor(visible_count);		
		
		for (i in 0...characters.length)
		{
			characters[i].enabled = i<vc;
		}
		
		render_clock += Time.deltaTime;
		
		if (render_clock >= 1.0)
		{
			render_clock -= 1.0;
			render_fps = render_count;
			render_count = 0;			
		}
		var log : String = "";
		
		log += "Press A to Add a Character\n";		
		log += "Press Z to Remove a Character\n";
		log += Mathf.Floor(render_fps) + "fps\n";
		log += "Characters: " + vc;
		
		field.innerText = log;
		
		//angle += Time.deltaTime * 40.0;		
		//character.transform.rotation = Quaternion.FromAxisAngle(Vector3.up, angle).Multiply(Quaternion.FromAxisAngle(Vector3.right, -90));		
		
		if (Input.IsDown(KeyCode.A))
		{
			visible_count += Time.deltaTime * 8.0;
		}
		
		if (Input.IsDown(KeyCode.Z))
		{
			visible_count -= Time.deltaTime * 8.0;
		}
		
		
		
		if (Input.Hit(KeyCode.D4))
		{
			Gizmo.transforms = !Gizmo.transforms;
		}
		
		var p : Vector3 = orbit.pivot.position;
		
		if (Input.IsDown(KeyCode.Up))
		{
			p.y += Time.deltaTime * 1.0;
		}
		
		if (Input.IsDown(KeyCode.Down))
		{
			p.y -= Time.deltaTime * 1.0;
		}
		
		orbit.pivot.position = p;
		
		if (Input.IsDown(KeyCode.Left))
		{
			orbit.camera.fov -= Time.deltaTime * 45.0;
		}
		
		if (Input.IsDown(KeyCode.Right))
		{
			orbit.camera.fov += Time.deltaTime * 45.0;
		}
	}
	
}