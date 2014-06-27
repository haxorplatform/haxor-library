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
import haxor.texture.Texture2D;
import haxor.texture.TextureCube;
import haxor.texture.TextureHTML;
import js.Browser;
import js.html.ButtonElement;
import js.html.Element;
import js.html.Event;
import js.html.Image;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Loads 6 images and shows a cubemap.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class Cubemap extends Application implements IUpdateable
{
	
	
	/**
	 * Loads the assets for this application.
	 */
	override function Load():Void 
	{		
		
		
		Web.root = "http://haxor.thelaborat.org/";
		
		//Loads the 6 textures.		
		Asset.LoadTextureHTML("px", "./resources/texture/skybox/nvlobby/right.jpg");		
		Asset.LoadTextureHTML("py", "./resources/texture/skybox/nvlobby/top.jpg");
		Asset.LoadTextureHTML("pz", "./resources/texture/skybox/nvlobby/front.jpg");
		Asset.LoadTextureHTML("nx", "./resources/texture/skybox/nvlobby/left.jpg");				
		Asset.LoadTextureHTML("ny", "./resources/texture/skybox/nvlobby/bottom.jpg");
		Asset.LoadTextureHTML("nz", "./resources/texture/skybox/nvlobby/back.jpg");				
	
	
		
		var field : Element = cast Browser.document.getElementById("field");		
		field.innerText = "Loading...";
		
	}
	
	/**
	 * Method called after the load of the assets.
	 */
	override function Initialize():Void 
	{
		trace("Cubemap> Initialize");
		
		var field : Element = cast Browser.document.getElementById("field");		
		field.innerText = "Cubemap Viewer";
		
		//Creates the environment map
		var environ : TextureCube = new TextureCube();
		
		//Sets each side with the loaded textures.
		environ.px = Asset.Get("px");
		environ.py = Asset.Get("py");
		environ.pz = Asset.Get("pz");
		
		environ.nx = Asset.Get("nx");
		environ.ny = Asset.Get("ny");
		environ.nz = Asset.Get("nz");
		
		//Apply the changes.
		environ.Apply();
		
	
		//Creates an Orbit Camera to see things around.
		var orbit : CameraOrbit = CameraOrbit.Create(0.1, 0, 0);
		orbit.smooth = 5.0;
		
		//Creates an Orbit Camera Input to control it using the mouse.
		var orbit_input : CameraOrbitInput = orbit.AddComponent(CameraOrbitInput);
		orbit_input.zoom = false;		
		orbit_input.rotateSpeed = 0.1;
		
		
		//It is necessary to have at least one camera in the scene
		var cam : Camera = orbit.camera;
		
		//Tells that the camera must clear the Depth buffer and the background using the skybox
		cam.clear = ClearFlag.SkyboxDepth;
		
		//Sets the skybox texture
		cam.skybox = environ;
		
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