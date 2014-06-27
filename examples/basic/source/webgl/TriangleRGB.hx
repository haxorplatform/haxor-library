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
 * Most basic demo. Creates a Triangle with RGB in its vertex color and shows it rotating at 90.0 degrees / second.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class TriangleRGB extends Application implements IUpdateable
{
	
	var tris : Entity;
	
	var angle : Float;
	
	/**
	 * Loads the basic 'Flat' shader.
	 */
	override function Load():Void 
	{		
		//Loads the shader 'Flat' and stores it in the id 'haxor/unlit/Flat'
		Asset.LoadShader("haxor/unlit/Flat","http://haxor.thelaborat.org/resources/shader/unlit/Flat.shader");
	}
	
	/**
	 * Initialize already created elements here.
	 */
	override function Build():Void 
	{
		trace("TriangleRGB> Build");				
	}
	
	override function Initialize():Void 
	{
		trace("TriangleRGB> Initialize");
		
		angle = 0.0;
		
		tris = new Entity();
		tris.name = "triangle";
		
		//Adds component responsible of rendering meshes using the passed material.
		var mr : MeshRenderer = tris.AddComponent(MeshRenderer);
		
		//Creates a material that handles rendering information like shader, depth test, render queue.
		var mat : Material = new Material();
		mat.name = "TriangleMaterial";
		mat.shader = Asset.Get("haxor/unlit/Flat"); //Gets the shader loaded in the 'Load' method
		mat.SetUniform("Tint", Color.white); 		//Sets the 'Tint' Uniform to white
		mat.cull = CullMode.None;					//Indicates that both front and back face will be rendered
				
		//Creates a Mesh with Vector3 components.
		var msh : Mesh3 = new Mesh3();
		msh.name = "TriangleMesh";
		
		//sets the mesh vertex in the render order (no need for indexes)
		msh.vertex =
		[
		new Vector3( -1.0, 0.0, 0.0),
		new Vector3(  1.0, 0.0, 0.0),
		new Vector3(  0.0, 1.5, 0.0)		
		];
		
		//sets each vertex color
		msh.color =
		[
		Color.red,Color.green,Color.blue
		];
		
		//Sets the renderer mesh
		mr.mesh = msh;
		//Sets the material
		mr.material = mat;
		
		
		//Creates an entity and adds a camera in it
		//It is necessary to have at least one camera in the scene
		var cam : Camera = (new Entity()).AddComponent(Camera);
		
		//Sets the clear color
		cam.background = new Color(0.1, 0.1, 0.1);
		
		//moves the camera slightly back so we can see the triangle
		cam.transform.position = new Vector3(0, 0.5, 2);
		
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
		tris.transform.rotation = Quaternion.FromAxisAngle(Vector3.up, angle);		
	}
	
}