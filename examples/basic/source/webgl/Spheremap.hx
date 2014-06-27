package webgl;
import haxor.component.Camera;
import haxor.component.CameraOrbit;
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
import haxor.net.Web;
import haxor.texture.Texture;
import haxor.texture.TextureCube;
import js.Browser;
import js.html.ButtonElement;
import js.html.Element;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Loads 1 spherical map and set it to an sphere model.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class Spheremap extends Application implements IUpdateable
{
	
	
	/**
	 * Loads the assets for this application.
	 */
	override function Load():Void 
	{		
		//Sets the loading root to this URL
		Web.root = "http://haxor.thelaborat.org/resources/";
		
		//Loads the shader 'FlatTexture' and stores it in the id 'haxor/unlit/FlatTexture'
		Asset.LoadShader("haxor/unlit/FlatTexture", "./shader/unlit/FlatTexture.shader");
		
		//Loads the spheremap texture		
		Asset.LoadTextureHTML("sphere_map", "./texture/skybox/little_planet/texture.jpg");
				
		//Loads the ColladaFile and puts it in the 'sphere' slot
		Asset.LoadCollada("sphere", "./primitive/sphere.DAE");
		
		
		var field : Element = cast Browser.document.getElementById("field");		
		field.innerText = "Loading...";
		
	}
	
	/**
	 * Method called after the load of the assets.
	 */
	override function Initialize():Void 
	{
		trace("Spheremap> Initialize");
		
		var field : Element = cast Browser.document.getElementById("field");		
		field.innerText = "Spheremap Viewer";
		
		//Creates the environment map
		var environ : Texture = Asset.Get("sphere_map");
		
		var sphere : Entity = Asset.Get("sphere").GetAsset();
		
		sphere.transform.scale = new Vector3(15, 15, 15); //Scales the sphere to make it the 'environment'.
		
		//Creates the material.
		var mat : Material = new Material();
		
		mat.shader = Asset.Get("haxor/unlit/FlatTexture");  //Sets the shader with Texture only.
		mat.SetUniform("DiffuseTexture", environ); 			//Sets the texture to the sphere map
		mat.invert = true; 									//Inverts the rendering to show the sphere from the inside.
		
		//Find the MeshRenderer that renders the sphere mesh.
		var mr : MeshRenderer = sphere.GetComponentInChildren(MeshRenderer);
		
		//Set its material to the sphere map.
		mr.material = mat;
	
		//Creates an Orbit Camera to see things around.
		var orbit : CameraOrbit = CameraOrbit.Create(-0.1, 0, 0);
		orbit.smooth = 5.0;
		
		//Creates an Orbit Camera Input to control it using the mouse.
		var orbit_input : CameraOrbitInput = orbit.AddComponent(CameraOrbitInput);
		orbit_input.zoom = false;		
		orbit_input.rotateSpeed = 0.3;
		
		
		//It is necessary to have at least one camera in the scene
		var cam : Camera = orbit.camera;
		
		
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
		//Controls the fov to simulate zoom.
		var c : Camera = Camera.list[0];
		var w  :Float = Input.wheel;
		c.fov -= w * 0.1;
	}
	
}