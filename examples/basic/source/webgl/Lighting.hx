package webgl;
import haxor.component.Camera;
import haxor.component.Light;
import haxor.component.MeshRenderer;
import haxor.component.PointLight;
import haxor.component.Transform;
import haxor.core.Application;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.Entity;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.editor.Gizmo;
import haxor.graphics.CullMode;
import haxor.graphics.Material;
import haxor.graphics.MeshTemplate.Mesh3;
import haxor.importer.ColladaFile;
import haxor.math.Color;
import haxor.math.Mathf;
import haxor.math.Matrix4;
import haxor.math.Quaternion;
import haxor.math.Vector3;
import haxor.texture.Texture.TextureWrap;
import haxor.texture.TextureHTML;
import js.Browser;
import js.html.ButtonElement;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Loads a ColladaFile and shows it with some lights on the scene
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class Lighting extends Application implements IUpdateable
{
	
	var asset : Entity;
	
	var angle : Float;
	
	var light : PointLight;
	
	var light_container : Transform;
	
	/**
	 * Loads the basic 'Flat' shader.
	 */
	override function Load():Void 
	{		
		//Loads the shader 'FlatTexture' and stores it in the id 'haxor/diffuse/Diffuse'
		Asset.LoadShader("haxor/diffuse/Diffuse", "http://haxor.thelaborat.org/resources/shader/diffuse/Diffuse.shader");
		
		//Loads the ImageElement 'metal.jpg' and stores it as a TextureHTML in 'steel'
		Asset.LoadTextureHTML("metal", "http://haxor.thelaborat.org/resources/texture/misc/metal.jpg");
		
		
		//Loads the ColladaFile and puts it in the 'asset' slot
		Asset.LoadCollada("asset", "http://haxor.thelaborat.org/resources/primitive/teapot.DAE");
	}
	
	/**
	 * Method called after the load of the assets.
	 */
	override function Initialize():Void 
	{
		trace("Lighting> Initialize");
		
		angle = 0.0;
		
		//Loading of collada files results in a 'ColladaFile' instance
		//This class stores information without creating the 'Entity' instance.
		var cf : ColladaFile = Asset.Get("asset");
		
		//'GetAsset()' will effectively create the instance.
		asset = cf.GetAsset();
		asset.name = "asset";
		
		//Fetches the texture from the asset library
		var tex : TextureHTML = Asset.Get("metal");
		//Sets the UV wrap to repeat in both directions
		tex.wrap = TextureWrap.RepeatX | TextureWrap.RepeatY;
		
		//Searches in the hierarchy for the first occurrence of the 'MeshRenderer' component.
		var mr : MeshRenderer = asset.GetComponentInChildren(MeshRenderer);
		
		//Creates a material that handles rendering information like shader, depth test, render queue.
		var mat : Material = new Material();
		mat.name 	= "AssetMaterial";
		mat.shader  = Asset.Get("haxor/diffuse/Diffuse");	 		//Gets the shader loaded in the 'Load' method		
		mat.SetUniform("Tint", Color.white);				 		//Sets the 'Tint' Uniform.
		mat.SetUniform("DiffuseTexture", Asset.Get("metal")); 		//Sets the 'DiffuseTexture' Uniform to the loaded texture.
		mat.cull 	= CullMode.Back;								//Indicates that the sides with its back pointed to camera will not be rendered
		
		//Important to activate lights
		mat.lighting = true;										//Tells that this material will use lights		
		
		//Sets the material
		mr.material = mat;
		
		//Container of the light that will be rotated
		light_container = (new Entity()).transform;
		
		//Sets the light ambient to slightly bright
		Light.ambient = new Color(0.05, 0.05, 0.05);
		
				
		//Creates the light
		light = PointLight.Create(new Color(0.9, 1.0, 1.0), 3.0, 1.0, 1.0);
				
		//Puts the light inside the container
		light.transform.parent = light_container;
		
		//Sets the light position a little external and on top of the asset
		light.transform.position = new Vector3(0.5, 0.3, 0.0);
		
		
		
		//Creates the light
		light = PointLight.Create(new Color(1.0, 0.0, 0.0), 2.0, 1.0, 0.5);
				
		//Puts the light inside the container
		light.transform.parent = light_container;
		
		//Sets the light position a little external and on top of the asset
		light.transform.position = new Vector3(-0.3, 0.0, 0.0);
		
		
		
		//Creates an entity and adds a camera in it
		//It is necessary to have at least one camera in the scene
		var cam : Camera = (new Entity()).AddComponent(Camera);
		
		//Sets the clear color
		cam.background = new Color(0.1, 0.1, 0.1);
		
		//moves the camera slightly back so we can see the triangle
		cam.transform.position = new Vector3(0, 0.4, 1.0);
		
		//Apply a LookAt transform on the camera.
		cam.LookAt(Vector3.zero);
		
		//Default FPS = 45
		fps = 60;
			
		//Enable this to see the light gizmos and help your debugging.
		//Gizmo.lights = true;
		
		//Register the interface IUpdateable in the execution pool.
		Engine.Add(this);		
	}
	
	/**
	 * Execution loop.
	 */
	public function OnUpdate():Void
	{		
		angle += Time.deltaTime*3;		
		//asset.transform.rotation = Quaternion.FromAxisAngle(Vector3.up, angle*10.0).Multiply(Quaternion.FromAxisAngle(Vector3.right, -90));		
		light_container.transform.rotation = Quaternion.FromAxisAngle(Vector3.up, -angle * 45.0);
	}
	
}