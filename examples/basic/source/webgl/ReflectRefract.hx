package webgl;
import haxor.component.Camera;
import haxor.component.MeshRenderer;
import haxor.core.Application;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.Entity;
import haxor.core.IUpdateable;
import haxor.core.Resource;
import haxor.core.Time;
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
import haxor.texture.TextureCube;
import js.Browser;
import js.html.ButtonElement;
import js.html.Element;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Loads a ColladaFile and gets the asset within it.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class ReflectRefract extends Application implements IUpdateable
{
	
	var asset : Entity;
	
	var angle : Float;
	
	var reflect_material : Material;
	
	var refract_material : Material;
	
	var asset_renderer : MeshRenderer;
	
	/**
	 * Loads the basic 'Flat' shader.
	 */
	override function Load():Void 
	{		
		//Load the shaders
		Asset.LoadShader("haxor/unlit/FlatReflect", "http://haxor.thelaborat.org/resources/shader/unlit/FlatReflect.shader");
		Asset.LoadShader("haxor/unlit/FlatRefract", "http://haxor.thelaborat.org/resources/shader/unlit/FlatRefract.shader");
		
		//Loads a cross shaped cubemap and separates it in 6 textures (rather slow)
		Asset.LoadTextureCube("environ", "http://haxor.thelaborat.org/resources/texture/skybox/cross/bourke.jpg");
		
		//Loads the ColladaFile and puts it in the 'asset' slot
		Asset.LoadCollada("asset", "http://haxor.thelaborat.org/resources/primitive/bunny.DAE");
		
		var field : Element = cast Browser.document.getElementById("field");		
		field.innerText = "Loading... (Will take a while, a cross shaped cubemap is being split)";
		
	}
	
	/**
	 * Method called after the load of the assets.
	 */
	override function Initialize():Void 
	{
		trace("ReflectRefract> Initialize");
		
		
		var field : Element = cast Browser.document.getElementById("field");		
		field.innerText  = "Press 1 to Reflect shader\n";
		field.innerText += "Press 2 to Refract shader";
		field.style.color = "#000";
		
		angle = 0.0;
		
		//Gets the environment map
		var environ : TextureCube = Asset.Get("environ");
		
		//Loading of collada files results in a 'ColladaFile' instance
		//This class stores information without creating the 'Entity' instance.
		var cf : ColladaFile = Asset.Get("asset");
		
		//'GetAsset()' will effectively create the instance.
		asset = cf.GetAsset();
		asset.name = "asset_reflect";
		
		var mr : MeshRenderer;
		
		//Searches in the hierarchy for the first occurrence of the 'MeshRenderer' component.
		mr = asset_renderer = asset.GetComponentInChildren(MeshRenderer);
		
		//Creates a material that handles rendering information like shader, depth test, render queue.
		var mat : Material = new Material();		
		
		mat.name 	= "AssetMaterial";
		mat.shader  = Asset.Get("haxor/unlit/FlatReflect"); 		//Gets the shader loaded in the 'Load' method		
		mat.SetUniform("SkyboxTexture",environ);			 		//Sets the 'SkyboxTexture' Uniform to the loaded texture.
		mat.SetUniform("SkyboxColor", Color.white);		 			//Sets the 'SkyboxColor' Uniform that will tint the skybox color		
		mat.cull 	= CullMode.Back;								//Indicates that the sides with its back pointed to camera will not be rendered
					
				
		//Sets the material
		mr.material = reflect_material = mat;
		
		//Duplicates the material to make it Refractive
		mat = refract_material = Resource.Instantiate(mat);		
		mat.shader  = Asset.Get("haxor/unlit/FlatRefract"); 		//Gets the shader loaded in the 'Load' method		
		mat.SetUniform("IOR", 2.4);							 		//Sets the 'IOR' to 'diamond'
		
		//Creates an entity and adds a camera in it
		//It is necessary to have at least one camera in the scene
		var cam : Camera = (new Entity()).AddComponent(Camera);
		
		//Tells that the camera must clear the Depth buffer and the background using the skybox
		cam.clear = ClearFlag.SkyboxDepth;
		
		//Sets the skybox texture
		cam.skybox = environ;
		
		//moves the camera slightly back so we can see the triangle
		cam.transform.position = new Vector3(0, 1.0,2.5);
		
		//Makes the camera look downwards
		cam.LookAt(Vector3.zero);
		
		
		//Default FPS = 45
		fps = 60;
		
		//Register the interface IUpdateable in the execution pool.
		Engine.Add(this);		
	}
	
	/**
	 * Execution loop.
	 */
	public function OnUpdate():Void
	{		
		angle += Time.deltaTime * 30.0;			
		asset.transform.rotation = Quaternion.FromAxisAngle(Vector3.up, angle).Multiply(Quaternion.FromAxisAngle(Vector3.right, -90));
		
		//Press '1' and '2' keys to change the material
		if (Input.Hit(KeyCode.D1)) asset_renderer.material = reflect_material; else
		if (Input.Hit(KeyCode.D2)) asset_renderer.material = refract_material;
	}
	
}