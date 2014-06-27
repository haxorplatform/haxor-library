package webgl;
import haxor.component.Camera;
import haxor.component.MeshRenderer;
import haxor.core.Application;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.Entity;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.graphics.CullMode;
import haxor.graphics.Material;
import haxor.graphics.MeshTemplate.Mesh3;
import haxor.importer.ColladaFile;
import haxor.math.Color;
import haxor.math.Mathf;
import haxor.math.Quaternion;
import haxor.math.Vector3;
import js.Browser;
import js.html.ButtonElement;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Loads a ColladaFile and gets the asset within it.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class ColladaLoad extends Application implements IUpdateable
{
	
	var asset : Entity;
	
	var angle : Float;
	
	/**
	 * Loads the basic 'Flat' shader.
	 */
	override function Load():Void 
	{	
		
		//Loads the shader 'FlatTexture' and stores it in the id 'haxor/unlit/FlatTexture'
		Asset.LoadShader("haxor/unlit/FlatTexture", "http://haxor.thelaborat.org/resources/shader/unlit/FlatTexture.shader");
		
		//Loads the ImageElement 'steel.jpg' and stores it as a TextureHTML in 'steel'
		Asset.LoadTextureHTML("steel", "http://haxor.thelaborat.org/resources/texture/misc/steel.jpg");
		
		
		//Loads the ColladaFile and puts it in the 'asset' slot
		Asset.LoadCollada("asset", "http://haxor.thelaborat.org/resources/primitive/cube.DAE");
	}
	
	/**
	 * Method called after the load of the assets.
	 */
	override function Initialize():Void 
	{
		trace("ColladaLoad> Initialize");
		
		angle = 0.0;
		
		//Loading of collada files results in a 'ColladaFile' instance
		//This class stores information without creating the 'Entity' instance.
		var cf : ColladaFile = Asset.Get("asset");
		
		//'GetAsset()' will effectively create the instance.
		asset = cf.GetAsset();
		asset.name = "asset";
		
		//Searches in the hierarchy for the first occurrence of the 'MeshRenderer' component.
		var mr : MeshRenderer = asset.GetComponentInChildren(MeshRenderer);
		
		//Creates a material that handles rendering information like shader, depth test, render queue.
		var mat : Material = new Material();
		mat.name 	= "AssetMaterial";
		mat.shader  = Asset.Get("haxor/unlit/FlatTexture"); 		//Gets the shader loaded in the 'Load' method		
		mat.SetUniform("DiffuseTexture", Asset.Get("steel")); 		//Sets the 'DiffuseTexture' Uniform to the loaded texture.
		mat.cull 	= CullMode.Back;								//Indicates that the sides with its back pointed to camera will not be rendered
						
		//Sets the material
		mr.material = mat;
		
		
		//Creates an entity and adds a camera in it
		//It is necessary to have at least one camera in the scene
		var cam : Camera = (new Entity()).AddComponent(Camera);
		
		//Sets the clear color
		cam.background = new Color(0.1, 0.1, 0.1);
		
		//moves the camera slightly back so we can see the triangle
		cam.transform.position = new Vector3(0, 0.0, 1.5);
		
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
		angle += Time.deltaTime * 90.0;		
		asset.transform.rotation = Quaternion.FromAxisAngle(Vector3.up, angle).Multiply(Quaternion.FromAxisAngle(Vector3.right, -90));		
	}
	
}